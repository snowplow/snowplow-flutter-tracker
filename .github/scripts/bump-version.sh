#!/usr/bin/env bash
# Bump the tracker version across all files that the "Prepare for release"
# commit touches in the Flutter tracker.
# Usage: bump-version.sh <X.Y.Z>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <X.Y.Z>" >&2
  exit 2
fi

NEW_VERSION="$1"

if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid version '$NEW_VERSION' (expected X.Y.Z)" >&2
  exit 2
fi

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

# Pull the old version from pubspec.yaml so we can find the right lines in
# README / lockfiles / overview.dart without false positives elsewhere.
OLD_VERSION="$(grep -E '^version:' pubspec.yaml | head -1 | sed -E 's/^version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)$/\1/')"
if [[ ! "$OLD_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Could not parse current version from pubspec.yaml (got '$OLD_VERSION')" >&2
  exit 1
fi
if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
  echo "Version is already $NEW_VERSION; nothing to bump."
  exit 0
fi
echo "Bumping $OLD_VERSION -> $NEW_VERSION"

sed_inplace() {
  # Cross-platform in-place sed (BSD sed needs an explicit suffix arg).
  local pattern="$1" file="$2"
  sed -i.bak -E "$pattern" "$file"
  rm "$file.bak"
}

# 1. pubspec.yaml — line: version: X.Y.Z
sed_inplace "s/^(version:[[:space:]]*)[0-9]+\.[0-9]+\.[0-9]+$/\1$NEW_VERSION/" pubspec.yaml

# 2. ios/snowplow_tracker.podspec — line: s.version = 'X.Y.Z'
sed_inplace "s/(s\.version[[:space:]]*=[[:space:]]*)'[0-9]+\.[0-9]+\.[0-9]+'/\1'$NEW_VERSION'/" ios/snowplow_tracker.podspec

IOS_VERSION_FILE="ios/snowplow_tracker/Sources/snowplow_tracker/TrackerVersion.swift"

# 3. iOS TrackerVersion.swift — TRACKER_VERSION = "flutter-X.Y.Z"
sed_inplace "s/(TRACKER_VERSION[[:space:]]*=[[:space:]]*)\"flutter-[0-9]+\.[0-9]+\.[0-9]+\"/\1\"flutter-$NEW_VERSION\"/" "$IOS_VERSION_FILE"

# 4. android/.../TrackerVersion.kt — TRACKER_VERSION = "flutter-X.Y.Z"
KOTLIN_VERSION_FILE="$(find android -name TrackerVersion.kt -print -quit)"
if [[ -z "$KOTLIN_VERSION_FILE" ]]; then
  echo "Could not find android TrackerVersion.kt" >&2
  exit 1
fi
sed_inplace "s/(TRACKER_VERSION[[:space:]]*=[[:space:]]*)\"flutter-[0-9]+\.[0-9]+\.[0-9]+\"/\1\"flutter-$NEW_VERSION\"/" "$KOTLIN_VERSION_FILE"

# 5. example/lib/overview.dart — `snowplow_tracker: ^OLD_VERSION` line
sed_inplace "s/(snowplow_tracker:[[:space:]]*\^)$OLD_VERSION/\1$NEW_VERSION/" example/lib/overview.dart

# 6. README.md — `snowplow_tracker: ^OLD_VERSION` line
sed_inplace "s/(snowplow_tracker:[[:space:]]*\^)$OLD_VERSION/\1$NEW_VERSION/" README.md

# 7. example/pubspec.lock — `version: "OLD_VERSION"` (only the snowplow_tracker
#    entry has this exact line; safer to anchor on the literal old version).
sed_inplace "s/^(    version:[[:space:]]*)\"$OLD_VERSION\"$/\1\"$NEW_VERSION\"/" example/pubspec.lock

# Sanity checks: every file must now contain the new version on the expected line.
grep -qE "^version:[[:space:]]*$NEW_VERSION\$" pubspec.yaml
grep -qE "s\.version[[:space:]]*=[[:space:]]*'$NEW_VERSION'" ios/snowplow_tracker.podspec
grep -q "TRACKER_VERSION = \"flutter-$NEW_VERSION\"" "$IOS_VERSION_FILE"
grep -q "TRACKER_VERSION = \"flutter-$NEW_VERSION\"" "$KOTLIN_VERSION_FILE"
grep -q "snowplow_tracker: \^$NEW_VERSION" example/lib/overview.dart
grep -q "snowplow_tracker: \^$NEW_VERSION" README.md
grep -q "version: \"$NEW_VERSION\"" example/pubspec.lock

# Belt-and-braces: refuse to finish if any of the bumped lines still mentions
# the old version. Each pattern is scoped to the specific context (`^X.Y.Z`
# dependency constraint, `version: "X.Y.Z"` lockfile entry, etc.) so that
# unrelated occurrences of the digits — e.g. inside a transitive-package
# sha256 hash — are ignored.
for pat in \
  "snowplow_tracker:[[:space:]]*\^$OLD_VERSION\b" \
  "TRACKER_VERSION[[:space:]]*=[[:space:]]*\"flutter-$OLD_VERSION\"" \
  "s\.version[[:space:]]*=[[:space:]]*'$OLD_VERSION'" \
  "^version:[[:space:]]*$OLD_VERSION$"; do
  if grep -REn "$pat" \
       pubspec.yaml \
       ios/snowplow_tracker.podspec \
       "$IOS_VERSION_FILE" \
       "$KOTLIN_VERSION_FILE" \
       example/lib/overview.dart \
       README.md \
       example/pubspec.lock 2>/dev/null; then
    echo "Pattern '$pat' (old version $OLD_VERSION) still matches one of the bumped files; aborting." >&2
    exit 1
  fi
done

echo "Bumped to $NEW_VERSION across:"
echo "  pubspec.yaml"
echo "  ios/snowplow_tracker.podspec"
echo "  $IOS_VERSION_FILE"
echo "  $KOTLIN_VERSION_FILE"
echo "  example/lib/overview.dart"
echo "  README.md"
echo "  example/pubspec.lock"
