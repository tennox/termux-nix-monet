# Merge Upstream Changes — Round 2

## Status: In Progress

## Upstream Status (2026-09-30)

| Repo | URL | HEAD | Behind |
|------|-----|------|--------|
| termux-app | github.com/termux/termux-app | `8629e632` (2026-09-27) | 69 commits since merge-base `57e4ef45` |
| upstream-monet | github.com/Termux-Monet/termux-monet | `8f192567` (2024-09-14) | nothing new (project abandoned) |
| nix-on-droid (community) | github.com/nix-community/nix-on-droid | `df611d53` (2026-08-22) | 2 commits not in tennox fork pin (`f346dd4`, 2026-03-09) |
| nix-on-droid-app | github.com/nix-community/nix-on-droid-app | `e87b6091` (2025-06-16) | nothing new |

## Merge Strategy

### Tier 1 — Cherry-pick, low conflict (this task)
Small, isolated correctness/security/render fixes. No Monet overlap.

- `3b66f879` Security: RunCommandService — don't send results before `allow-external-app` check
- `b4a2c32c` NPE in `TermuxOpenReceiver$ContentProvider.getType()`
- `0a60d2df` Revert `drawTextRun` on Android 5 (runtime crash)
- `401bbe54` Don't add `BigTextStyle` when big text null
- `74ab5126` Scroll position lost on session switch / activity restart / keyboard toggle
- `30ebb2de` Inverted typo in PgUp/PgDn termcap
- `1021b581` Cast cursor dims to float
- `5532cc4f` `int` instead of `short` for space indexing
- `47c473f9` Clear LineWrap flag on line clear
- `8b72226d` Pass `Base64.DEFAULT` on clipboard decode
- `45844885` Disable terminal margin adjustment in multi/floating window (prevents flicker)
- `084d709f` Wrong jstring passed to `ReleaseStringUTFChars`
- `7d87ed76` Language-switch key on external keyboards

### Tier 2 — Defer (own taskdir)
- `4de0caac` / `d2cd6ac2` hiddenapibypass → 6.1 (Android 16 fix) — needs version bump
- `3b270134` + `fd2ab4fc` + `3ed351b5` Sixel/Bitmap/iTerm merge — ⚠️ conflicts with local `WorkingTerminalBitmap.java`
- `d8d6b02a` OCS 52 clipboard buffer 100KB — bigger change, needs testing

### Tier 3 — Skip (low value)
- 7 GitHub Actions / workflow bumps
- Gradle/AGP dependency bumps (`53f75a8d`)
- SECURITY.md / sponsor logos

## Out of Scope (other repos)
- **nix-on-droid**: bootstrap zip rebuild needed — separate task. Two new commits (proot-termux bump, db.sqlite path fix) are on nix-community master but not yet on tennox/nix-on-droid `main`. Requires PR/fork sync first.
- **upstream-monet / nix-on-droid-app**: nothing to merge.

## Conflict Watch
- `terminal-emulator/src/main/java/com/termux/terminal/TerminalBitmap.java` and `WorkingTerminalBitmap.java` — Tier-2 merge blocker
- `TerminalBuffer.java` has local `getSixelBitmap`/`sixelChar`/`sixelStart` — Tier-2 merge blocker

## Local-only commits not yet pushed to origin
- `a2b898f6` Fix app initialization crashes after restore attempt
- `6235221f` Add background-pause to suspend session jobs and let device sleep

## Build Verification
After each cherry-pick: `./gradlew assembleDebug` (skip instrumentation; check compile only).

## Progress Notes

### Round 1 — Tier-1 cherry-picks (DONE 2026-09-30)

Worked on branch `merge/upstream-2026-09` (off main). 13 commits cherry-picked,
plus 1 no-op empty commit for an already-applied fix. Build verified clean
(`./gradlew assembleDebug` → BUILD SUCCESSFUL).

| Commit | Outcome | Notes |
|---|---|---|
| `47c473f9` clear LineWrap | no-op commit | Fix already in fork via `e808ca4f`; HEAD wins |
| `7d87ed76` lang-switch key | clean | |
| `0a60d2df` drawTextRun Android-5 guard | conflict on `Build` import | Local had `Rect/RectF` instead of `Build`; kept both, applied guard |
| `1021b581` cursor dims float | conflict on cursorHeight formula | Local has italic-aware `fontLineSpacing` refactor; applied float cast (`4.`→`4.f`) but kept local formula |
| `5532cc4f` `short`→`int` mSpaceUsed | conflict on import layout | Applied type widening; removed redundant casts |
| `30ebb2de` PgUp/PgDn typo | conflict on full block | Applied upstream swap |
| `8b72226d` Base64.DEFAULT | clean | |
| `45844885` multi-window margin fix | conflict on insertion point | Inserted upstream block |
| `401bbe54` BigTextStyle null guard | clean | |
| `3b66f879` RunCommandService allow-external security | conflict (moves result-config block) | Moved block to after allow-external check; careful manual resolution |
| `74ab5126` scroll position on session switch | clean | |
| `b4a2c32c` NPE in TermuxOpenReceiver.getType | clean | |
| `084d709f` wrong jstring to ReleaseStringUTFChars | clean | |

### Pre-existing test compile failure

`./gradlew :terminal-emulator:testDebugUnitTest` fails on TerminalTestCase
because local TerminalEmulator constructor takes `(TerminalOutput, boolean,
int, int, Integer, TerminalSessionClient)` (6-arg, with boldWithBright from
cherry-pick a0e1962b in 2023) while the test passes `(TerminalOutput, int,
int, int, null)` (5-arg, old shape). NOT introduced by this round; would
need to either update the test or drop the boldWithBright parameter. Out of
scope for this taskdir.

### Local-only commits not yet pushed to origin

- `a2b898f6` Fix app initialization crashes after restore attempt
- `6235221f` Add background-pause to suspend session jobs and let device sleep

Both will be part of any push of merge/upstream-2026-09 → main → origin.