# Releasing SystemX

Everything in the code is done. These steps need your accounts, your phone
or your money. Texts and answers to paste are in
[`store-listing.md`](store-listing.md) and
[`play-console-answers.md`](play-console-answers.md).

## 1. First build and test on your phone

```bash
cd systemx
flutter pub get
flutter test                                   # 114 tests
cd android && ./gradlew :app:testDebugUnitTest && cd ..   # Kotlin tests
flutter run                                    # on your phone, debug
```

The Android code was written without an Android SDK available, so the first
Gradle build is where any compile error would show up. If it fails, send me
the error output.

Then go through the checklist at the end of this file on your phone.

## 2. Create the upload key (once, keep it forever)

```bash
keytool -genkey -v -keystore systemx-upload.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
```

Keep `systemx-upload.jks` and its passwords in two safe places, never in the
code folder or on GitHub. Then create `systemx/android/key.properties`
(git-ignored):

```
storeFile=C:/path/to/systemx-upload.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

## 3. Build the release bundle

```bash
cd systemx
flutter build appbundle --release
# -> build/app/outputs/bundle/release/app-release.aab
flutter build apk --release --split-per-abi   # optional: APKs for testers outside Play
```

Before each upload, raise `version:` in `pubspec.yaml` (for example
`1.0.1+2`; the number after `+` must always go up).

Check the release build before uploading (PowerShell, from `systemx`):

```powershell
flutter build apk --release
& "$env:LOCALAPPDATA\Android\Sdk\build-tools\36.0.0\aapt.exe" dump permissions build\app\outputs\flutter-apk\app-release.apk
```

The list must **not** contain `android.permission.INTERNET` (the privacy
policy and Data safety answers depend on it). Use whichever build-tools
version folder you have. Then install that APK on your phone
(`flutter install --release`) and open each tab once: release builds
shrink code, and this is where a missing keep rule would show up.

## 4. Publish the privacy policy (free, GitHub Pages)

1. Merge this branch into `main` on GitHub.
2. Repository › Settings › Pages › Build and deployment › Source:
   **Deploy from a branch**, Branch: **main**, folder: **/docs** › Save.
3. After a minute, open
   https://mr-kabiron.github.io/SystemX/privacy.html and check it loads.

## 5. Play Console

1. Create the developer account ($25 once, identity verification can take
   days). Choose a public contact email for the listing.
2. Create app › name "SystemX: Device Info & Test", default language
   English (United States), App, Free.
3. App content: fill every form from `play-console-answers.md`, including
   the foreground service declaration and its 30-second video.
4. Main store listing: texts and graphics from `store-listing.md`; add the
   Bengali (bn-BD) translation.
5. Testing › Closed testing › Create track › upload `app-release.aab`
   (accept Play App Signing). Add 12+ testers by email (a Google Group is
   easiest) and share the opt-in link.
6. Testers must keep the app installed for **14 days in a row**. Ask them
   to run a checkup and report anything odd.
7. After 14 days: Apply for production access (Dashboard), then
   Production › Create release › Staged rollout **20%**, watch Android
   vitals for a few days, then raise to **100%**.

## 6. Optional

- Set `AppLinks.feedbackEmail` in `systemx/lib/core/links.dart` to your
  public email to show "Send feedback" in Settings.
- The carrier codes in `systemx/lib/features/device/carriers.dart` were
  checked against public lists in October 2026. Dial a few on your own SIMs;
  if an operator changes one, it's a one-line edit there.

## Phone test checklist

**Stage 1, shell**: onboarding, theme switch (system, light, dark, pure
black, wallpaper colors), the four tabs, language switch to Bangla.

**Stage 2, device info**
- Compare Device, System, Processor, Memory, Storage, Battery and Display
  values with Settings › About phone.
- Network: tap "Network name", deny, then allow Location; the Wi-Fi name
  appears. SIM: allow Phone; SIM slots appear. Deny twice to see the
  "Open settings" sheet.
- Search ("vulkan", "patch"), long-press to copy, share the spec sheet.
- Sensors: tap one and move the phone; the live reading changes.
- Security check: each tappable row opens the right settings screen.

**Stage 3, live**
- Plug in a charger: battery current turns positive and watts appear on
  Home, Battery detail and Monitor.
- Download something: network speed rises.
- CPU detail: per-core clocks move; tap Pause and charts freeze.
- Thermal: status and headroom (Android 11+); CPU temperature only if your
  phone allows it.

**Stage 4, tests**
- Run a full checkup; try passing, failing and skipping a few.
- Open the PDF from Save PDF and Share report on a computer.
- Earpiece tone should come from the top speaker; volume buttons must not
  change the volume during their test.
- GPS near a window; fingerprint with your enrolled finger.

**Stage 5, background**
- Turn on Live status for a day; check the notification, the number in the
  status bar, and the battery cost in Android's battery settings.
- Turn on the charge alarm at 80% and charge from below 80%.
- Add both widgets and the Quick Settings tile; long-press the app icon for
  shortcuts.
- Next day: Monitor › History shows 24 h charts; Charging sessions lists the
  charge. Reboot the phone and check live status comes back.

**Stage 6, polish**
- Switch to Bangla; turn on TalkBack and move through Home and a test;
  set the largest font size and open every tab.
- Wi-Fi meter (Network detail): walk away from the router.

**Stage 7, Play**: in-app review and updates only work for builds installed
from Play (the closed test track).

**Stage 8, new tools**
- Device: on a Samsung, the name reads "Galaxy …"; Sales region shows the
  CSC; IMEI row dials *#06#; Copy (top bar) pastes the whole sheet.
- Apps: allow Usage access; sizes and cache appear; tapping an app opens
  its App info page.
- Battery health: with Live status on, charge from below 50% to above 70%;
  a measured capacity appears. After a day, both drain rates appear.
- CPU stress test: run 1 minute; the phone gets warm, the result appears,
  and it stops by itself when you press Home.
- Refresh rate: matches your display setting (e.g. 120 Hz in Smooth mode).
- Touch response: draw for a few seconds; a rate appears.
- Used phone check: type a wrong model, see "Problems found"; create the
  PDF and open it.
- Live status notification: collapsed row and expanded 3 × 2 grid in both
  light and dark mode; the status bar shows the value over its unit.
- A tablet or an unfolded foldable shows the side rail.
