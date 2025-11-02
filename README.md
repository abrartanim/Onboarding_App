# Smart Travel Alarm

A Flutter application that helps you set travel alarms and stay on schedule for your journeys. With a beautiful and intuitive interface, this app ensures you never miss an important event on your trip.

## Features

-   **Stunning Onboarding:** A visually appealing onboarding experience with background videos to welcome users.
-   **Location-Based Alarms:** Set alarms based on your current location to get timely reminders.
-   **Custom Alarms:** Easily set alarms with a date and time picker.
-   **Push Notifications:** Receive notifications for your upcoming alarms.
-   **Modern UI:** A sleek and modern user interface with a beautiful gradient background.

## Screenshots

| Onboarding Screen                               | Location Permission Screen                                | Home Screen                               |
| ----------------------------------------------- | --------------------------------------------------------- | ----------------------------------------- |
| ![Onboarding Screen](screenshots/Onboarding%20Screen.png) | ![Location Permission Screen](screenshots/Location%20Permission%20Screen.png) | ![Home Screen](screenshots/Home%20Screen.png) |

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
-   An editor like Android Studio or VS Code with the Flutter plugin.

### Installation

1.  Clone the repo
    ```sh
    git clone https://github.com/your_username_/softvence_project.git
    ```
2.  Install packages
    ```sh
    flutter pub get
    ```
3.  Run the app
    ```sh
    flutter run
    ```

## Dependencies

This project uses the following main dependencies:

-   `flutter_local_notifications`: For scheduling and displaying notifications.
-   `google_fonts`: For custom fonts.
-   `intl`: For date and time formatting.
-   `location`: For accessing device location.
-   `smooth_page_indicator`: For the page indicator in the onboarding screen.
-   `video_player`: For playing the background videos in the onboarding screen.