# Merge Upstream Changes

## Status: Completed

## Upstream Repos Summary

| Repo | URL | Latest Commit | Behind |
|------|-----|---------------|--------|
| **termux-app** | https://github.com/termux/termux-app | `3f0dec35` | 20+ commits |
| **upstream-monet** | https://github.com/Termux-Monet/termux-monet | `8f192567` | ✅ Merged |
| **nix-on-droid** | https://github.com/nix-community/nix-on-droid | `67b10533` | Separate project |

## Pending Changes

### ✅ Already Merged (via cherry-picks)
- AutoFill improvements (username/password split)
- Shift-PgUp/PgDn scroll by pages
- SGR sequence fix
- Scrolling with horizontal margins fix

### ✅ Merged (from termux-app)

#### HIGH Priority
- `5f578d56` - Update bootstrap packages - used **prerelease-25.11** (2026.02.12 not available on server)
- `ef4775b6` - Increase read buffer size from **4KB to 64KB**
- `3f0dec35` - Remove deprecated `extractNativeLibs` attribute (already not present)

#### MEDIUM Priority
- `1937595c` - Revert `desugar_jdk_libs` back to 1.1.5
- `a1457d12` - Fix Maven libraries publication

#### LOW Priority (deps/CI updates)
- Various Gradle, AGP, GitHub Actions updates

### ✅ Restored Monet Features (TermuxActivity.java)
- Imports: PackageManager, Configuration, Build, Environment, Settings, SubMenu, WindowInsets, WindowInsetsController, ActivityCompat, ContextCompat, WindowInsetsCompat
- Constants: CONTEXT_SUBMENU_FONT_AND_COLOR_ID/SET_BACKGROUND/REMOVE_BACKGROUND + fixed AUTOFILL collision
- onCreate: WindowInsetsCompat insets, WindowInsetsController fullscreen, API-aware startForegroundService, storage permission checks
- New methods: verifyRWPermission(), verifyAndroid11ManageFiles(), onConfigurationChanged()
- onBackPressed: opens drawer instead of finishing
- finishActivityIfNotFinishing: finishAndRemoveTask() support
- Context menu: Styling submenu (Font & Color / Set Background / Remove Background)
- showFontAndColorDialog() renamed from showStylingDialog()
- Page-aware accessor methods for extra keys views
- Broadcast receiver: RECEIVER_NOT_EXPORTED guard (API 28+)
- reloadActivityStyling: reloads mExtraKeysView2

## Key Objectives
1. Merge HIGH priority commits from termux-app ✅
2. Restore Monet features lost in upstream merge ✅
3. Test build compiles ✅ (BUILD SUCCESSFUL)
4. Test app runs on device (pending)
