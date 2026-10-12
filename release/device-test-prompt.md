# Prompt: full on-device test of SystemX

Paste everything below the line into Claude Code, started in the
`systemx` folder on the computer your phone is plugged into.

---

You are testing the SystemX Android app (Flutter + Kotlin, in this folder) on a
real phone connected over USB. Your job is to check every screen and feature
works on the phone, find bugs, and write a clear report. Work carefully and
step by step; the phone is my personal phone.

## Ground rules (important)

- **Never** do any of these: factory reset, wipe data, uninstall any app other
  than SystemX, change developer/system settings you didn't turn on yourself,
  place a call, send an SMS, or press the call button on a USSD code. Dialer
  tests only check the code appears in the dialer; then press back.
- Turn off anything you turn on (Live status, alarms, high refresh, keep
  screen on) when you finish with it.
- The CPU stress test: run the **1-minute** option once. Stop it if the
  battery is above 42 °C before starting (`adb shell dumpsys battery`,
  temperature is in tenths of a °C).
- Some tests need my hands, eyes or ears (speaker, earpiece, microphone,
  camera, fingerprint, volume buttons, flashlight, vibration, plugging in a
  charger). For those, tell me exactly what to do, wait for my answer, and
  record what I say. Group these requests so I'm not interrupted constantly.
- Don't commit or push anything until you've shown me the report and I've
  said which fixes to make. When I approve fixes: one small commit each, on
  the current branch, `flutter analyze` and `flutter test` passing before
  every commit.

## Tools to use

- `adb devices` to confirm the phone; use `-s <serial>` if more than one.
- Install and run: `flutter pub get`, `flutter test`, then `flutter run`
  (debug) for most testing; a release build at the end.
- Look at the screen: `adb exec-out screencap -p > test-run/shots/<name>.png`, then
  view the PNG. Save every screenshot under `test-run/shots/` with a
  descriptive name.
- Find and tap things: `adb shell uiautomator dump /sdcard/ui.xml` and
  `adb pull /sdcard/ui.xml`, read the bounds, then `adb shell input tap X Y`.
  Swipe with `adb shell input swipe x1 y1 x2 y2 300`. Back:
  `adb shell input keyevent 4`. Home: `keyevent 3`.
- Open screens directly with deep links:
  `adb shell am start -a android.intent.action.VIEW -d "systemx://open/<path>"`
  (paths: `home`, `device`, `tests`, `monitor`, `checkup`, `live/battery`,
  `live/cpu`; check `lib/core/router.dart` for the rest).
- Logs: `adb logcat -c` before each section, then
  `adb logcat -d | findstr /i "flutter systemx AndroidRuntime FATAL"`
  (PowerShell) after it. Any exception or crash is a bug.
- Ground truth to compare values with: `adb shell getprop`,
  `adb shell dumpsys battery`, `adb shell cat /proc/meminfo`,
  `adb shell df /data`, `adb shell dumpsys display | findstr mode`,
  `adb shell dumpsys sensorservice`, `adb shell dumpsys telephony.registry`,
  `adb shell settings get global device_name`.

## What to test, in order

For each item: do it, take a screenshot, compare with ground truth where
there is one, check logcat, and mark it **Pass / Fail / Needs me / Not
possible** with a one-line reason.

### 0. Build
1. `flutter analyze` (must be clean) and `flutter test` (all pass).
2. `cd android && .\gradlew :app:testDebugUnitTest` (Kotlin tests).
3. `flutter run` on the phone. Any build error: stop and report it.

### 1. First launch and shell
- Onboarding pages, permissions sheet, "Skip".
- Default theme is light. Settings: switch light, dark, pure black, system,
  wallpaper colors; check the bottom bar is neon cyan in dark themes.
- Language switch to Bangla and back: no English left on main screens, no
  boxes instead of letters, nothing cut off.
- The four tabs keep their scroll position when switching.
- Largest font size (`adb shell settings put system font_scale 1.3`, restore
  to the original value afterwards): open every tab, look for overflow
  stripes or clipped text.

### 2. Device tab: every category
Open all 15 categories and compare with ground truth:
- Device: model name (on Samsung must be "Galaxy …", not SM-…), manufacturer,
  codename, device name, manufacturer UI (One UI version), launched with,
  sales code (`getprop ro.csc.sales_code`), sales country and region,
  Android ID, IMEI row opens the dialer with *#06# (then back), Knox.
- System: Android version, patch date, build number, kernel.
- Processor, Graphics, Memory (vs /proc/meminfo), Storage (vs df),
  Battery (vs dumpsys battery: level, temperature, voltage, health; cycle
  count real or "estimated" row or no row, never a fake 0), Display
  (resolution, refresh rates vs dumpsys display), Network (Wi-Fi name after
  allowing Location), SIM (after allowing Phone; carrier codes show for each
  SIM; tapping one opens the dialer with the code, do **not** call),
  Cameras, Sensors (total count vs dumpsys sensorservice; tap a sensor and
  move the phone, values change), Media, Features, Security (each tappable
  row opens the right settings screen; back).
- Search ("vulkan", "patch"), long-press copy, Share, and the Copy-all
  button (check the clipboard text).
- Installed apps: count looks right; allow Usage access; sizes and cache
  appear; sort chips; System apps filter; search; tapping an app opens its
  App info page; "Free up space" opens the storage manager.

### 3. Home and Monitor (live data)
- Home cards update every few seconds; values match ground truth.
- Live screens (CPU, battery, network, thermal): charts move, Pause works.
- Network speed rises while downloading something (ask me to play a video).
- Ask me to plug in a charger: current turns positive, watts appear.
- Monitor: History card, Charging sessions, Battery health entry.

### 4. Tests tab
- Run the full 32-test checkup. Automatic tests run by themselves; for the
  rest, ask me. Volume buttons must register and must not change the volume.
  Try one pass, one fail, one skip on purpose.
- Status badges: seal check for passed, X for failed, minus for skipped,
  "?" for not tested.
- Report: score, Save PDF and Share PDF; pull the saved PDF and check it
  opens and is in English.

### 5. Tools
- Used phone check: enter a wrong model → "Problems found" with
  "Seller says …"; enter the right model, storage and RAM → those rows
  match; verdict uses the checkup from step 4; "Show IMEI" opens the dialer
  (back); Create report (PDF) → share sheet; check the PDF.
- CPU stress test (1 minute): starts, chart moves, temperature shown,
  result appears; run it again and press Home after 10 s → it stops
  (check `adb shell top -n 1` shows SystemX no longer using CPU).
- Refresh rate test: result matches the display's mode (e.g. 120 Hz with
  Smooth motion on); leaving the screen returns the display to normal.
- Touch response test: ask me to draw; a rate appears.
- Wi-Fi meter (Network detail).

### 6. Battery health
- Screen opens; with no data it explains what's needed (no crash, no
  fake numbers). If I agree, leave Live status on and ask me to charge from
  below 50% to above 70% later; then check a capacity appears.

### 7. Background features
- Settings › Alerts and live status: turn on Live status. Check the
  notification: collapsed row (battery, temperature, download, RAM) and
  expanded 3 × 2 grid with labels; light and dark mode; the status bar icon
  shows a value over its unit (e.g. "0" over "KB/s"). Try each status bar
  option (battery %, temperature, network speed). Stop from the
  notification. Screenshot each.
- Charge alarm at 80% (ask me to charge if useful), battery low/hot toggles
  save and survive an app restart.
- Widgets (ask me to add both), Quick Settings tile, app shortcuts
  (long-press icon), deep links.
- Reboot test only if I agree: Live status comes back after reboot.

### 8. Privacy and settings
- Privacy policy opens inside the app (English and Bangla), no 404.
- Privacy screen shows the real permission statuses.
- Clear all history works.

### 9. Release build
1. `flutter build apk --release`.
2. Check permissions:
   `& "$env:LOCALAPPDATA\Android\Sdk\build-tools\<version>\aapt.exe" dump permissions build\app\outputs\flutter-apk\app-release.apk`
   — must **not** list `android.permission.INTERNET`.
3. `flutter install --release`, open every tab and each tool once: release
   builds shrink code, so look for anything that works in debug but not
   here. Check logcat.
4. Reinstall the debug build afterwards if I want to keep testing.

### 10. Performance and safety
- `adb shell dumpsys gfxinfo com.systemx.app` after scrolling each tab:
  note janky frame percentage.
- `adb shell dumpsys meminfo com.systemx.app`: note total memory.
- With Live status on for 15 minutes, `adb shell dumpsys batterystats
  com.systemx.app` (rough cost).
- Confirm nothing keeps running when the app is closed and Live status is off.

## Report

Write `test-run/REPORT.md` with:
1. Phone model, Android version, build tested (git commit hash).
2. A table of every item above: Pass / Fail / Needs me / Not possible, with
   the screenshot file name.
3. Each bug: steps to reproduce, expected vs actual, screenshot, logcat
   excerpt, the likely file and line in this repo, and a proposed fix.
4. Values that didn't match ground truth, side by side.
5. Visual problems: overflow, cut-off text, wrong colors, untranslated text.
6. Ranked list: what must be fixed before Play Store release vs nice to have.

Then stop and show me the summary. Don't fix anything until I say which bugs
to fix.
