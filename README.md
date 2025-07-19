# TANAW Mobile Application

## 📱 App Overview

TANAW is a mobile application designed to assist visually impaired individuals by providing real-time obstacle detection and navigation guidance. It serves as an interface for smart glasses, offering a seamless and accessible user experience.

**Target Users:**
- Visually impaired individuals
- Their guardians

## 💡 Key Features

- **Multi-page Navigation:** Intuitive navigation for both user and guardian modes.
- **User and Guardian Modes:** Tailored experiences for primary users and their guardians.
- **Voice Feedback (TTS):** Integrated text-to-speech for audible feedback.
- **Device Connection Status:** Real-time status of the smart glasses connection.
- **Real-time Obstacle Detection:** A UI placeholder for obstacle alerts from the hardware.
- **Profile Management:** Easy-to-use profile and settings management.
- **Accessibility Support:** Fully compatible with TalkBack and designed with large, high-contrast UI elements.

## ⚙️ Technology Stack

- **Frontend:** Flutter

*Note: Currently, the application is frontend-only. Backend services and hardware integration with IoT smart glasses are in progress. Full functionality depends on the physical connection of the glasses to the mobile app.*

## 🧭 Navigation Structure

The app follows a logical flow:
1.  **Splash Screen**
2.  **Login / Signup** (With distinct paths for User and Guardian)
3.  **Main Pages:** Home, Status, and Profile.
4.  **Settings & More:** Edit Profile, Guardian Guide, Notification Settings.

## 🖼️ Design Principles

- **Minimalist & User-Friendly:** Clean layouts to ensure ease of use.
- **Dual-Theme:** Light mode for the User and Dark mode for the Guardian.
- **Visual Consistency:** Follows TANAW’s brand identity for a cohesive experience.

## 🧪 How to Run the App

1.  **Clone the repository.**
2.  **Ensure you have Flutter installed.** If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
3.  **Install dependencies** by running `flutter pub get` in the project root.
4.  **Run the app** using `flutter run` with a connected device or emulator.

*Note: Running on a real device is preferred for testing accessibility features like TalkBack.*

## 🚧 Known Limitations

- **No Backend Integration:** The app does not yet connect to a backend or database.
- **Placeholder Data:** IoT hardware is not yet connected; placeholder data is used for demonstration.

## 👥 Developed by:

**BSIT - NETWORK TECHNOLOGY 3301**

- **ATIENZA, Dorothy Amor C.** – 22-02858@g.batstate-u.edu.ph
- **GUICO, Luis Daniel B.** – 22-05186@g.batstate-u.edu.ph
- **MONTIALTO, Jedd Iris B.** – 22-06742@g.batstate-u.edu.ph

