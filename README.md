# Discipleship Memorizer

A Flutter application that equips followers of Jesus to grow through Scripture memorization, evangelism challenges, prayer focus, Bible reading plans, and journaling. The experience is designed for both mobile and web platforms.

## Features

- Choose from curated Scripture memory lists or build personal collections.
- Guided memorization workflow that encourages speaking verses aloud and progressively hiding words with every press.
- Daily reminders via local notifications and automatic refresh prompts to keep verses sharp.
- Adjustable memorization pace with a 1–7 day slider for each verse.
- Encouraging celebration when a verse is memorized.
- Supplementary discipleship tools including:
  - Daily evangelism challenges
  - Prayer topics and checklists
  - Bible reading plans
  - Notes and journaling with quick entry

## Getting Started

1. Install the Flutter SDK and platform dependencies for mobile and web builds.
2. Fetch packages:

   ```sh
   flutter pub get
   ```

3. Run the application on mobile or web:

   ```sh
   flutter run
   ```

   For web:

   ```sh
   flutter run -d chrome
   ```

4. Ensure notification permissions are granted on the target platform so daily reminders can be scheduled.

## Project Structure

- `lib/main.dart`: Application entry point with navigation.
- `lib/models`: Core data models for verses and discipleship content.
- `lib/providers`: State management for memorization and discipleship sections using Provider.
- `lib/screens`: UI screens for each section of the app.
- `lib/widgets`: Reusable components such as verse cards and celebration dialog.
- `lib/services/notification_service.dart`: Wrapper around `flutter_local_notifications` for reminders and encouragements.

## Assets

Add text files or JSON in `assets/verses/` to import additional verse lists. Update `pubspec.yaml` if adding new assets or fonts.

## Testing

Run Flutter's test suite once widget and unit tests are authored:

```sh
flutter test
```

---

This project intentionally avoids backend dependencies. Persisted state lives on the device via `SharedPreferences` while notifications use platform channels provided by Flutter.
