# Preparing a release

The `Prepare release PR` workflow (`.github/workflows/prepare-release.yml`)
automates the "Prepare for X.Y.Z release" commit and the release PR that
maintainers used to write by hand.

## How a release works now

1. Create the release branch from `main` and merge feature/bug-fix PRs into
   it as usual:
   ```
   git checkout main && git pull
   git checkout -b release/0.10.0
   git push -u origin release/0.10.0
   ```
2. When the branch is ready to ship, go to **Actions → Prepare release PR →
   Run workflow** and fill in:
   - `release_branch`: `release/0.10.0`
   - `dry_run`: leave unchecked for a real run; check it for a preview.
3. The workflow will bump every file the manual "Prepare for release" commit
   used to touch:
   - `pubspec.yaml`
   - `ios/snowplow_tracker.podspec`
   - `ios/snowplow_tracker/Sources/snowplow_tracker/TrackerVersion.swift` (`TRACKER_VERSION = "flutter-X.Y.Z"`)
   - `android/src/main/kotlin/com/snowplowanalytics/snowplow_tracker/TrackerVersion.kt` (same string)
   - `example/lib/overview.dart` (`snowplow_tracker: ^X.Y.Z` line)
   - `README.md` (the `snowplow_tracker: ^X.Y.Z` install snippet)
   - `example/pubspec.lock` (snowplow_tracker entry only; the script
     sed-bumps this directly so the workflow doesn't need a Flutter install)
4. Then it asks Claude to draft the new `CHANGELOG.md` entry from the
   commits on the branch (using the previous entry as a style example) and
   prepends it.
5. Commits everything as `Prepare for X.Y.Z release` and pushes to the
   release branch.
6. Asks Claude to draft the PR body — flat bullets for 1–2 changes,
   `**New features:** / **Improvements:** / **Bug fixes:**` groups for
   3+, with `thanks to @user` attribution for external contributors only.
7. Opens (or updates) a PR titled `Release/X.Y.Z` against `main`.

Review the PR, edit the CHANGELOG entry or PR body in place if needed, then
merge. Pushing the `X.Y.Z` tag triggers `publish.yml`, which cross-validates
the version in pubspec.yaml, `ios/snowplow_tracker/Sources/snowplow_tracker/TrackerVersion.swift`, and
`android/.../TrackerVersion.kt` against the tag before publishing to pub.dev
and creating the GitHub release.

## Re-running on the same branch

If you push a small fix to the release branch after the workflow ran, re-run
the workflow. It detects that `HEAD` is already a `Prepare for X.Y.Z release`
commit and skips the bump and changelog step — it only refreshes the PR body.

If you need the bump or CHANGELOG re-done from scratch, drop the prepare
commit locally (`git reset --hard HEAD~1 && git push --force-with-lease`) and
re-run the workflow.

## Dry-run mode

`dry_run: true` runs everything up to (but not including) the push and the PR
write. The full `git diff` and the generated PR body are printed to the
workflow log. Use this the first time you exercise the workflow on a real
release branch.

## Inputs that will make the workflow fail loudly

- A `release_branch` that doesn't match `release/X.Y.Z`.
- A `release_branch` that doesn't exist on origin.
- A previous release tag that can't be found on `main` (the workflow needs
  one to compute the commit list).
- The bump script's belt-and-braces grep finds the old version still in one
  of the bumped files — typically meaning a file format changed and the sed
  pattern needs updating.

## Requirements

- `ANTHROPIC_API_KEY` secret must be set on the repository.
- `GITHUB_TOKEN` (provided automatically) needs `contents: write` and
  `pull-requests: write`, which the workflow declares.
