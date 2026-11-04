// Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.
package com.snowplowanalytics.snowplow_tracker

import android.os.SystemClock
import com.snowplowanalytics.snowplow.payload.SelfDescribingJson

/// Entities of a plugin and when each value took effect.
///
/// The tracker creates events in the order they are tracked but adds plugin
/// entities later on a thread pool, in no particular order. Keeping the
/// recent values lets each event get the value that was set when it was
/// tracked. Writes are serialized, reads take no lock.
///
/// Values take effect by the wall clock, as event timestamps use it, and
/// expire by [monotonicClock], so a wall clock moved backwards can't bring
/// back a replaced value for longer than [RETENTION_MS].
class PluginEntitiesStore(
    entities: List<SelfDescribingJson>,
    private val monotonicClock: () -> Long = SystemClock::elapsedRealtime,
    private val wallClock: () -> Long = System::currentTimeMillis,
    now: Long = wallClock()
) {

    /// [replacedAt] is the [monotonicClock] time the value was replaced, null for the current value
    private class Entry(val since: Long, val entities: List<SelfDescribingJson>, val replacedAt: Long? = null)

    /// Values from oldest to newest, replaced as a whole on every write
    @Volatile
    private var history: List<Entry> = listOf(Entry(now, entities))

    /// Replaces the entities, which take effect on the millisecond after [now].
    ///
    /// Events tracked before this call, even in the same millisecond, keep the
    /// previous entities. It returns once the wall clock reaches the next
    /// millisecond, at most 1 ms later, so events tracked after it get the
    /// new entities. If the wall clock moves backwards meanwhile, it stops
    /// waiting after [MAX_WAIT_NANOS] and keeps only the new entities.
    @Synchronized
    fun set(entities: List<SelfDescribingJson>, now: Long = wallClock()) {
        val since = now + 1
        val current = history
        val replacedAt = monotonicClock()
        history = if (now < current.last().since) {
            // the wall clock moved backwards, the previous values would apply to new events
            listOf(Entry(since, entities))
        } else {
            val retained = current.filter { !isExpired(it, replacedAt) }.dropLast(1)
            val replaced = current.last().let { Entry(it.since, it.entities, replacedAt) }
            (retained + replaced + Entry(since, entities)).takeLast(MAX_ENTRIES)
        }
        val deadline = System.nanoTime() + MAX_WAIT_NANOS
        while (wallClock() < since && System.nanoTime() < deadline) {
            Thread.yield()
        }
        if (wallClock() < since) {
            // the wall clock moved backwards, later events would get the previous values
            history = listOf(Entry(wallClock(), entities))
        }
    }

    /// Entities in effect at [timestamp], the current ones if it is null.
    ///
    /// Events from before the oldest value kept get the oldest value.
    fun entitiesAt(timestamp: Long?): List<SelfDescribingJson> {
        val entries = history
        if (timestamp == null) {
            return entries.last().entities
        }
        val monotonicNow = monotonicClock()
        val valid = entries.filter { !isExpired(it, monotonicNow) }
        return (valid.lastOrNull { it.since <= timestamp } ?: valid.first()).entities
    }

    private fun isExpired(entry: Entry, monotonicNow: Long): Boolean =
        entry.replacedAt != null && monotonicNow - entry.replacedAt > RETENTION_MS

    companion object {
        /// How long a value is kept after it is replaced
        const val RETENTION_MS = 60_000L
        const val MAX_ENTRIES = 16

        /// Longest [set] waits for the wall clock to reach the next millisecond
        const val MAX_WAIT_NANOS = 2_000_000L
    }
}
