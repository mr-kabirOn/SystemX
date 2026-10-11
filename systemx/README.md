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
  core/        theme tokens, typography, settings, router, formatting
  features/    one folder per screen (home, device, tests, monitor, settings, onboarding)
  ui/          shared widgets (gauges, cards, tiles, sheets) and icons
  l10n/        translations
android/       app id com.systemx.app, icon, splash, release config
screenshots/   renders every screen to PNG for design review
```

## Commands

```bash
flutter run                                  # run on a connected phone
flutter test                                 # unit + widget tests (fake phone data)
cd android && ./gradlew :app:testDebugUnitTest  # Kotlin parser tests
flutter test screenshots --update-goldens    # render screens to screenshots/out
flutter build apk --release --split-per-abi  # installable test APKs
flutter build appbundle --release            # .aab for Play Console
```

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
