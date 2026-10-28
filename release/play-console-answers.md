# Play Console answers

Prepared answers for the forms under Play Console › Policy and programs ›
App content. They match the code as built: no internet permission, no
SDKs that collect data, all data on the device.

## Privacy policy
`https://mr-kabiron.github.io/SystemX/privacy.html`
(Publish it first: see README step 4.)

## Ads
Does your app contain ads? **No.**

## App access
All functionality is available without special access. **No login required.**

## Content rating (IARC questionnaire)
- Category: **Utility, Productivity, Communication or Other**
- Violence, sexuality, language, controlled substances, gambling: **No** to all
- Does the app let users interact or exchange content? **No**
- Does the app share the user's location with others? **No**
- Does the app allow purchases of digital goods? **No**
Expected result: Everyone / PEGI 3.

## Target audience and content
- Target age groups: **18 and over** (you may add 13–17). Do not select
  under 13; the app is not designed for children.
- Could the store listing unintentionally appeal to children? **No.**

## News app
**No.**

## Health apps
**No** (it reports device health, not personal health).

## Financial features
**None.**

## Government app
**No.**

## Data safety
- Does your app collect or share any of the required user data types? **No.**
  - Reason: SystemX has no INTERNET permission and no third-party SDKs that
    collect data. Everything it reads stays on the device ("collected" in
    Play's sense means sent off the device).
- Is all user data encrypted in transit? Not applicable (nothing is
  transmitted). If the form insists, answer **Yes**.
- Do you provide a way for users to request that their data is deleted?
  **Yes**: Settings › Clear all history, or uninstall.
- Note for review: Google Play's in-app review and update libraries run
  inside the Play Store app; Google's own data handling is covered by
  Google and is not declared by apps.

Result shown on the listing: **"No data collected · No data shared"**.

## Foreground service declaration (Android 14+ specialUse)
Play Console › App content › Foreground service permissions.

- Type: **Special use**
- Subtype (already in the manifest): "Optional live device status
  (battery, temperature, charging power, network speed, memory) that the
  user turns on in Settings and can stop from the notification."
- Description for the form:
  "SystemX offers an optional ongoing notification that shows live battery
  level, temperature, charging power, network speed and memory use, with a
  number in the status bar. It is off by default. The user turns it on in
  Settings › Alerts and live status, and can stop it from the notification
  or in Settings. While it runs, the same process records the battery
  history and sends the battery alerts the user turned on; charging power
  and network speed are rates measured between readings a few seconds
  apart, which a periodic job can't provide. With the screen off it reads
  only once a minute. It restarts after a reboot only if the user left it
  on. None of the other foreground service types fit: this is not media,
  location, data sync, health or a connected device."
- User impact if deferred: "The live readings in the notification would
  stop updating, which is the feature the user asked for."
- Video: record 30 s on your phone: open Settings › Alerts and live status,
  turn on Live status notification, pull down the shade to show it updating,
  then tap Stop live status. Upload to YouTube as unlisted and paste the
  link.

## Permissions declarations
None of the restricted permissions are used (no SMS, call log, all-files
access, QUERY_ALL_PACKAGES, background location, accessibility or
exact alarms), so no extra declaration forms appear.

Two things a reviewer may ask about:
- **Usage access (PACKAGE_USAGE_STATS)**: a special access the user turns
  on in Android Settings from the Apps or Screen time screen. It is used to
  read each app's storage and cache size (StorageStatsManager) and, for
  Screen time, usage events (UsageStatsManager): time on screen per app,
  opens, unlocks and daily screen-on time. Nothing is stored or sent; the
  app has no internet permission. Off unless the user enables it.
- **Seeing installed apps**: the Apps screen lists apps with a launcher
  icon, through a `<queries>` launcher intent; a home-screen `<queries>`
  entry lets Screen time leave launchers out of its list. Screen time
  names the apps that appear in Android's usage records. QUERY_ALL_PACKAGES
  is not requested.

If Play asks why the app needs Usage access, answer:
"Screen time is a core feature: it shows the user's daily screen-on time and
how long each app was used, with an on-device battery estimate per app. The
same access shows each app's storage and cache size. It is optional,
explained in the app before the user opens the system setting, and the data
never leaves the device (the app has no internet permission)."

## Note for reviewers: CPU stress test
The CPU stress test only runs while its screen is open, at background
thread priority, for at most 3 minutes, and stops at 45 °C battery,
severe thermal status or low battery. It doesn't run in the background.

## Release notes (first release)
en-US: "First release: every spec, battery health measured on each charge,
screen time with time and estimated battery per app, a 32-test checkup, a
used phone check with PDF report, CPU stress, refresh rate and touch tests,
alerts, widgets and a live status notification. English and Bangla."

bn-BD: "প্রথম সংস্করণ: প্রতিটি স্পেসিফিকেশন, প্রতিটি চার্জে পরিমাপকৃত
ব্যাটারির স্বাস্থ্য, অ্যাপভিত্তিক সময় ও আনুমানিক ব্যাটারি খরচসহ স্ক্রিন টাইম,
৩২টি পরীক্ষার পূর্ণাঙ্গ চেকআপ, PDF প্রতিবেদনসহ ব্যবহৃত ফোন যাচাই, সিপিইউ
চাপ পরীক্ষা, রিফ্রেশ রেট ও স্পর্শ পরীক্ষা, সতর্কবার্তা, উইজেট এবং তাৎক্ষণিক
অবস্থার বিজ্ঞপ্তি। ইংরেজি ও বাংলা।"
