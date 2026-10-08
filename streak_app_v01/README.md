# 🔥 Streak App v0.1

A simple local-first Flutter streak app built around one flame.

## Included

- One flame representing overall progress
- Maximum 2 habits
- Daily completion flow
- One-sentence daily summary
- Streak counter
- Level milestones at 1 / 7 / 14 / 30 days
- Missed-day reset
- Local persistence with SharedPreferences
- Basic custom flame artwork
- Three screens: Home, Edit Habits, Complete Today

## Run

From this folder:

```bash
flutter pub get
flutter run
```

If the project is missing generated platform folders on your machine, run this once from the project folder:

```bash
flutter create .
```

Then:

```bash
flutter pub get
flutter run
```

## Android APK

```bash
flutter build apk --release
```

The APK will be at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Intentionally not included yet

- Home-screen widget
- Flame splitting after day 30
- Notifications
- Cloud sync
- Login/accounts
- Statistics/history UI
- Animations
- Windows version
