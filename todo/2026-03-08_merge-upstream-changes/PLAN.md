# Merge Plan

See [TASK.md](./TASK.md) for upstream details and full change list.

## Changes to Merge

| Priority | Commit | Description |
|----------|--------|-------------|
| HIGH | `5f578d56` | Update bootstrap to 2026.02.12 |
| HIGH | `ef4775b6` | Read buffer 4KB → 64KB |
| HIGH | `3f0dec35` | Remove extractNativeLibs |
| MEDIUM | `1937595c` | Revert desugar_jdk_libs |
| MEDIUM | `a1457d12` | Fix Maven publication |

## Execution

Merge commits in order, fixing any conflicts. Test build after each merge.
