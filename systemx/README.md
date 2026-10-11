# SystemX

Device info and phone diagnostics for Android. Live stats, every spec the phone
exposes, and a guided hardware checkup. Everything stays on the device: no
account, no server, no tracking.

Plan and designs: `../plan/systemx-plan.html`

## Stack

- Flutter 3.41 (Dart 3.11), Android only for now
- Riverpod (state), go_router (navigation), shared_preferences (settings)
- Kotlin platform layer for system data, called through Pigeon
  (`pigeons/device_api.dart`)
- English and Bangla (`lib/l10n/*.arb`)
- minSdk 26 (Android 8.0), target/compile SDK 36

## Project layout

```
lib/
  core/        theme, typography, settings, router, permissions, formatting
  platform/    Pigeon bindings to the Kotlin layer (device_api.g.dart)
  features/
    device/      15 spec categories, search, share, SIM balance check
    live/        live monitor, health score, tips, CPU/battery/network/thermal, Wi-Fi meter
    tests/       32 hardware tests, guided checkup, report and PDF
    background/  alerts and live status settings, history, charging sessions
    home/ monitor/ settings/ onboarding/ shell/ play/
  ui/          shared widgets (gauges, live chart, cards, tiles, sheets)
  l10n/        English and Bangla
android/app/src/main/kotlin/com/systemx/app/
  platform/    probes, hardware test host, Pigeon hosts, pure parsers (unit tested)
  background/  live status service, WorkManager sampling and alerts, widgets, tile
screenshots/   renders every screen and the Play Store graphics to PNG
```

The Dart side never talks to Android directly: every call goes through the
Pigeon contract in `pigeons/device_api.dart`, and tests replace it with fakes
(`test/fakes.dart`). Regenerate after editing the contract:
`dart run pigeon --input pigeons/device_api.dart`.

## Commands

```bash
flutter run                                  # run on a connected phone
flutter test                                 # unit + widget tests (fake phone data)
cd android && ./gradlew :app:testDebugUnitTest  # Kotlin parser tests
flutter test screenshots --update-goldens    # render screens and store graphics
flutter build apk --release --split-per-abi  # installable test APKs
flutter build appbundle --release            # .aab for Play Console
```

## Release

Step-by-step Play Store guide, listing texts and form answers:
`../release/README.md`. Privacy policy page: `../docs/privacy.html`.

## Release signing

Create `android/key.properties` (never commit it):

```
storeFile=C:/path/to/systemx-upload.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

Without it, release builds are signed with the debug key so they still install
for testing.

## Notes

- Spec labels added in Stage 2 are English only; the Bangla build falls back
  to English for them until the Stage 6 translation pass.
- Carrier balance codes live in `lib/features/device/carriers.dart`.

- `android/gradle.properties` sets `kotlin.incremental=false` because the
  project and the pub cache are on different drives on the dev machine.
- `dynamic_color` is pinned to 1.8.1; 1.9.0 needs AGP 9.
