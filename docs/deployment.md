# Deployment

## Build commands

From [`../dev/commands.md`](../dev/commands.md) and the README:

```bash
flutter build apk --release --dart-define-from-file=secrets.json
flutter build web --release --dart-define-from-file=secrets.json
flutter build windows --release --dart-define-from-file=secrets.json
iscc windows/installer/watch_atlas.iss
```

The Windows build + package script is invoked as
`.\windows\installer\build_installer.ps1` (per its header). It builds the
release, checks `build\windows\x64\runner\Release\watch_atlas.exe`, then calls
`iscc` when Inno Setup 6+ is on `PATH`.

## Artifacts and targets

| Target | Build output declared in repo | CI handling |
| --- | --- | --- |
| Android | `build/app/outputs/flutter-apk/app-release.apk` | `build-android` job uploads artifact `android-release-apk` |
| Web | `build/web` | `build-web` job uploads a Pages artifact via `actions/upload-pages-artifact@v3` |
| Windows | `build/windows/runner/Release` (CI upload path); installer output `build/installer/` | `build-windows` job uploads artifact `windows-release` |
| macOS / Linux / iOS | Platform runner folders exist (`macos/`, `linux/`, `ios/`) | No CI job or build command in `dev/commands.md` |

Release copies are checked in under `dev/release/` (for example `v0.9.0`,
`v0.11.0`, `v0.12.0` APKs and Windows installers) and in the adjacent
`../watch_atlas--dev/release/` folder. `dev/` is gitignored in
[`../.gitignore`](../.gitignore).

CI in [`../.github/workflows/ci.yml`](../.github/workflows/ci.yml) runs on
pushes to `main`/`develop` and pull requests to `main`. Its release builds use
placeholder `--dart-define` values, so CI artifacts are not production-credential
builds.

## Configuration required before release

- Supabase project with `supabase/schema.sql`, `migration.sql`,
  `grants_core.sql`, `grants.sql` and `recommendation_tables.sql` applied.
- Real credentials supplied via `secrets.json` / `--dart-define` at build time;
  never committed. See [configuration.md](./configuration.md).
- Android release signing reads `android/key.properties` and a keystore in
  `android/app/` (both gitignored) from `android/app/build.gradle.kts`; the
  release build enables R8 minification and resource shrinking.
- OAuth redirects: `http://localhost:5555` for desktop and the app's web origin
  for web, registered in Supabase (`dev/commands.md`). On Windows,
  `scripts/register_windows_scheme.ps1` registers `io.supabase.flutter://` and
  asks for `io.supabase.flutter://callback` in Supabase redirect URLs.
- Web deploy workflow recorded in `dev/commands.md`: copy `build/web/` into
  `docs/` on the `deploy-web` branch. CI only uploads a Pages artifact; no
  workflow performs that push.

## Known gaps

- No EAS, Fastlane, Codemagic or store-submission configuration exists in this
  app directory.
- No CI job deploys the web artifact, signs an iOS build, or publishes a store
  release.
- No deployment target is configured for the Expo sibling app here; see
  `../../watch-atlas-rn/docs/deployment.md`.

## Sources

- `../dev/commands.md`, `../README.md`, `../.github/workflows/ci.yml`,
  `../.gitignore`, `../windows/installer/build_installer.ps1`,
  `../scripts/register_windows_scheme.ps1`, `../android/app/build.gradle.kts`,
  `../dev/release/`
