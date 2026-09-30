# 2026-09-30 — hiddenapibypass upgrade (Android 16 fix)

Goal: backport upstream's Android-16 crash fix (`4de0caac` bumps
`org.lsposed.hiddenapibypass:hiddenapibypass` from 2.0 → 6.1).

## Why this isn't a simple cherry-pick

Upstream commit `50a97b19` (2021) added the hiddenapibypass dependency
alongside a new `ReflectionUtils.java` that calls
`HiddenApiBypass.addHiddenApiExemptions("")`. Later, our local fork
migrated to `com.github.ChickenHook:RestrictionBypass:2.2` instead
(upstream `2c0b9ff0` in Dec 2023). Upstream later reverted that
migration — but our fork stayed on ChickenHook.

So the fork diverged: we have ChickenHook in gradle AND a `ReflectionUtils.java`
that calls `Unseal.unseal()` instead of `HiddenApiBypass.addHiddenApiExemptions()`.

The Android-16 crash (`4de0caac`) is specifically about
`HiddenApiBypass.addHiddenApiExemptions()` crashing on QPR1. Whether
ChickenHook 2.2 also crashes on Android 16 is **unverified**, but
ChickenHook 2.4.2 (latest) only promises Android 14 support — likely same
risk.

## Decision

After asking manu via ntfy (no answer within window, per skill's
~20-25min reversible-call default), picked option 2:

**Replace ChickenHook 2.2 with LSPosed hiddenapibypass 6.1**, matching
upstream. One library, not two, and aligned with upstream.

## Changes

| File | Change |
|---|---|
| `termux-shared/build.gradle` | `com.github.ChickenHook:RestrictionBypass:2.2` → `org.lsposed.hiddenapibypass:hiddenapibypass:6.1` |
| `termux-shared/src/main/java/com/termux/shared/reflection/ReflectionUtils.java` | import + call site swap; Javadoc reformatted to single-line style |

Diff vs upstream `termux-app/master`: only whitespace/Javadoc style
differences (4-space → single-line `/** */`). Semantic content identical.

## Build

`./gradlew assembleDebug` → BUILD SUCCESSFUL (198 tasks, 173 executed).

APK: `app/build/outputs/apk/debug/termux-app_apt-android-7-debug_arm64-v8a.apk`
(9.5MB).

Verified LSPosed classes are in the dex (`classes30.dex`, 134 references)
and ChickenHook is gone.

## Not pushed yet

Branch `merge/hiddenapibypass-2026-09` is ready. Awaiting manu's go-ahead
to merge to main and push (and to install on Android 16 device for
runtime verification).

## Open question

ChickenHook 2.4.2 is the latest ChickenHook release — if manu prefers
"stay on ChickenHook, just bump it" instead of switching libraries, the
fix is:

```diff
- implementation "com.github.ChickenHook:RestrictionBypass:2.2"
+ implementation "com.github.ChickenHook:RestrictionBypass:2.4.2"
```

But that doesn't fix the Android 16 crash — it just gets the latest
ChickenHook (which still doesn't promise Android 16 support). To actually
fix the crash on Android 16, the LSPosed swap above is what's needed.