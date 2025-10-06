Flutter OTT App Prototype (Android)
A video streaming prototype built with Flutter for Android.

Overview
This is a functional prototype of an Over-The-Top (OTT) video streaming app, designed with a home screen featuring horizontally scrolling carousels of video thumbnails. Tapping a thumbnail navigates to a video player with vertical swipe gestures (Reels/Shorts-style) for seamless video browsing. The app uses mock data and sample videos for demonstration.
This prototype assesses Flutter proficiency in UI/UX, state management, navigation, and video handling.
Features

Home Page:

Vertically scrolling list of categories (e.g., Popular Series, New Releases, Action).
Horizontal carousels with tappable thumbnails (140x200 images).
Mock JSON data loaded from assets (6 categories, 10 items each).


Reels-Style Video Player:

Full-screen playback with auto-start.
Vertical PageView for swiping up/down to next/previous videos.
Clean controls (play/pause, mute) via better_player.
Title overlay and back button for better UX.


Theming:

Dark theme with red accents.
Custom fonts: Bebas Neue for headers, Open Sans for body text.


Data Handling:

Local JSON parsing for categories and video metadata (titles, thumbnails, URLs).
Placeholder images from Picsum; sample videos from Google's public bucket.




Installation

Prerequisites:

Flutter SDK (latest stable version) installed and configured for Android.
Android Studio or VS Code with Flutter extension.
An Android emulator or physical device (API 21+).


Clone the Repo:
git clone <your-repo-url>
cd flutter-ott-prototype


Install Dependencies:
flutter pub get


Add Assets (if not already):

Create assets/ folder and add mock_ott_data.json (provided in the repo).


Run the App:
flutter run


Select your Android device/emulator.



Usage

Browse Home Screen:

Scroll vertically through categories.
Swipe horizontally within carousels to view thumbnails.


Play Videos:

Tap any thumbnail to open the video player.
Swipe up/down to navigate between videos in the category (audio auto-pauses on previous).
Tap back button to return to home.


Testing Notes:

Videos auto-play on load.
Fast swipes test audio isolation—only the center video should have sound.

Dependencies
Update pubspec.yaml as follows (run flutter pub get after changes):
dependencies:
  flutter:
    sdk: flutter
  better_player_enhanced: ^0.0.5
  google_fonts: ^6.2.1
  visibility_detector: ^0.3.1

flutter:
  assets:
    - assets/mock_ott_data.json

Known Issues & Improvements

Audio Edge Cases: On very slow devices, add a 100ms delay in VisibilityDetector for smoother transitions.
Video Buffering: Sample videos are short; real app needs caching (e.g., cached_video_player).
iOS Support: Prototype is Android-only; add platform checks for cross-platform.
Enhancements: Add search, user auth, or real API integration (e.g., Firebase).
