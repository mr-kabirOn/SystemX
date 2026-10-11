#  SystemX — Android System Monitor

A real-time Android system monitoring application that provides a comprehensive view of a device's hardware and software performance metrics — CPU usage, RAM, battery, storage, and more — presented through clean Material Design cards and interactive charts.

---

##  Overview

SystemX gives users a live, at-a-glance dashboard of their Android device's internals. It reads hardware and OS-level data using the OSHI (Open Hardware/Software Information) library, visualises trends with MPAndroidChart, and keeps the UI responsive through Kotlin Coroutines running background collection tasks.

---

##  Features

- **Real-Time CPU Monitoring** — Tracks CPU usage percentage and displays it as a live line chart.
- **RAM / Memory Stats** — Shows total, used, and free memory with usage history.
- **Battery Information** — Reports battery level, charging state, health, and temperature.
- **Storage Overview** — Displays internal storage capacity, used space, and free space.
- **System Information Panel** — Summarises device model, Android version, kernel info, and uptime.
- **Interactive Charts** — All time-series metrics rendered with MPAndroidChart for smooth, zoomable graphs.
- **Tabbed Navigation** — ViewPager2-powered screens let users swipe between metric categories.
- **Card-Based UI** — Each metric group is presented in a clean Material3 card layout.
- **Background Data Collection** — Kotlin Coroutines handle continuous metric polling without blocking the UI thread.
- **Jetpack Compose Support** — UI is partially built with Compose, enabling declarative, reactive screen components alongside traditional XML views.

---

##  Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Kotlin |
| UI Toolkit | Jetpack Compose + XML Layouts |
| Design System | Material Design 3 (Material3) |
| Hardware Data | OSHI (oshi-core 6.4.4) |
| Charts | MPAndroidChart v3.1.0 |
| Async / Background | Kotlin Coroutines |
| Navigation | ViewPager2 |
| Layouts | ConstraintLayout, CardView |
| Build System | Gradle (Kotlin DSL) |
| Min SDK | Android 7.0 (API 24) |
| Target SDK | Android 15 (API 35) |
| Compile SDK | API 35 |

---

##  Project Structure

```
SystemX/
└── app/
    └── src/main/
        ├── java/com/example/systemx/
        │   ├── MainActivity.kt       # Main entry point, navigation host
        │   └── ui/theme/             # Compose theme definitions
        ├── res/
        │   ├── drawable/             # Card backgrounds, chart backgrounds, gradients
        │   ├── values/               # Colors, strings, themes
        │   └── xml/                  # Backup & data extraction rules
        └── AndroidManifest.xml
```

---

##  Getting Started

### Prerequisites
- Android Studio (Hedgehog or later recommended)
- Android device or emulator running **Android 7.0 (API 24) or higher**
- JDK 11

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/SystemX.git
   ```
2. Open the project in **Android Studio** (`File → Open` → select the `SystemX` folder).
3. Let Gradle sync and download dependencies automatically.
4. Connect a physical device or start an emulator.
5. Click **Run ▶** to build and install the app.

> **Note:** Some hardware metrics (e.g., detailed CPU frequency data) may read as unavailable on emulators. A physical device gives full readings.

---

##  Key Dependencies

| Dependency | Purpose |
|-----------|---------|
| `oshi-core:6.4.4` | Cross-platform hardware/OS info (CPU, memory, disks, sensors) |
| `MPAndroidChart:v3.1.0` | High-performance chart library (line, bar, pie charts) |
| `kotlinx-coroutines-android:1.7.3` | Background metric polling without blocking the UI |
| `androidx.compose.bom:2024.04.01` | Jetpack Compose UI framework |
| `material3` | Material Design 3 components |
| `viewpager2:1.0.0` | Swipeable tab-based screen navigation |
| `cardview:1.0.0` | Metric display cards |
| `constraintlayout:2.1.4` | Flexible XML layout engine |

---

##  Future Enhancements

- Network speed monitoring (upload / download throughput)
- CPU temperature and frequency per-core breakdown
- Historical data persistence across sessions (Room database)
- Configurable refresh rate and alert thresholds
- Home screen widget for quick stats at a glance
- Dark / Light theme toggle

---

##  License

This project is intended for educational and personal use. Feel free to fork and adapt it for your own Android system monitoring needs.
