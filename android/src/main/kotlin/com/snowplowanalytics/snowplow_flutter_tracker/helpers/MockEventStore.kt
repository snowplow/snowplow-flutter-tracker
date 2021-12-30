package com.snowplowanalytics.snowplow_flutter_tracker.helpers

import com.snowplowanalytics.snowplow.emitter.EmitterEvent
import com.snowplowanalytics.snowplow.payload.TrackerPayload
import com.snowplowanalytics.snowplow.payload.Payload
import com.snowplowanalytics.snowplow.emitter.EventStore

class MockEventStore : EventStore {
    var db: HashMap<Long, Payload?> = HashMap()
    var lastInsertedRow: Long = -1

    override fun add(payload: Payload) {
        synchronized(this) {
            lastInsertedRow++
            db.put(lastInsertedRow, payload)
        }
    }

    override fun removeEvent(id: Long): Boolean {
        synchronized(this) {
            return db.remove(id) != null
        }
    }

    override fun removeEvents(ids: List<Long>): Boolean {
        var result = true
        for (id in ids) {
            val removed = removeEvent(id)
            result = result && removed
        }
        return result
    }

    override fun removeAllEvents(): Boolean {
        synchronized(this) {
            db = HashMap()
            lastInsertedRow = 0
        }
        return true
    }

    override fun getSize(): Long {
        return db.size.toLong()
    }

    override fun getEmittableEvents(queryLimit: Int): List<EmitterEvent> {
        synchronized(this) {
            val eventIds: MutableList<Long> = ArrayList()
            val eventPayloads: MutableList<String> = ArrayList()
            var events: MutableList<EmitterEvent> = ArrayList()
            for ((key, value) in db.entries) {
                val payloadCopy: Payload = TrackerPayload()
                value?.map.let { payloadCopy.addMap(it as MutableMap<String, Any>) }
                val event = EmitterEvent(payloadCopy, key!!)
                eventIds.add(event.eventId)
                eventPayloads.add(payloadCopy.map.toString())
                events.add(event)
            }
            if (queryLimit < events.size) {
                events = events.subList(0, queryLimit)
            }
            return events
        }
    }
}
