# WatchAtlas (Flutter) documentation

This is the full documentation set for the Flutter app in `../`. The README at
[`../README.md`](../README.md) is the product-facing overview; these pages
answer where things live, how they are configured, and how they are verified.

## Start here

| Need | Page |
| --- | --- |
| Product story, feature inventory, non-goals | [product.md](./product.md) |
| Stack, entry points, module map, data flow | [architecture.md](./architecture.md) |
| Prerequisites, commands, conventions, troubleshooting | [development.md](./development.md) |
| Secrets, config files, stored keys and settings | [configuration.md](./configuration.md) |
| Test suites, exact commands, coverage gaps | [testing.md](./testing.md) |
| Build targets, artifacts, CI and release outputs | [deployment.md](./deployment.md) |
| Release history pointer | [changelog.md](./changelog.md) |
| Brand palette and theme files | [visual-identity.md](./visual-identity.md) |

## Canonical sources of truth

When docs and code disagree, the code wins. These are the files to check first:

| Question | Source |
| --- | --- |
| Dependencies, version, Dart constraint, assets | [`../pubspec.yaml`](../pubspec.yaml) |
| Routes and auth redirects | [`../lib/router/app_router.dart`](../lib/router/app_router.dart) |
| Secret names and required values | [`../lib/core/config/secrets.dart`](../lib/core/config/secrets.dart), [`../secrets.json.example`](../secrets.json.example) |
| Local cache tables | [`../lib/core/services/cache_service.dart`](../lib/core/services/cache_service.dart) |
| Remote schema and grants | [`../supabase/`](../supabase/) |
| Release history | [`../CHANGELOG.md`](../CHANGELOG.md) |
| Build/test commands | [`../dev/commands.md`](../dev/commands.md), [`../.github/workflows/ci.yml`](../.github/workflows/ci.yml) |

Other existing project notes kept alongside these docs: [`../AUDIT.md`](../AUDIT.md)
(dated quality audit for `0.10.0+1`) and [`../dev/v1.0.0-plan.md`](../dev/v1.0.0-plan.md)
(planning notes, not a released changelog).

## Sources

- `../README.md`, `../pubspec.yaml`, `../CHANGELOG.md`, `../AUDIT.md`
- `../lib/router/app_router.dart`, `../lib/core/config/secrets.dart`
