# Cube Timer

Cube Timer is a simple, intuitive iOS application built with SwiftUI designed for speedcubers and puzzle enthusiasts. It allows you to easily track and review your solve times on your Apple device.

## Features

- **Big Tap Timer**: Start and stop the timer seamlessly with a large, accessible tap area.
- **Solve Statistics**: Automatically calculates and displays your **Best Time**, Overall Average, and Last 10 Solves Average.
- **Progress Chart**: Visualize your improvement over time with a dynamic line chart (built with Swift Charts).
- **Dark/Light Theme Toggle**: Switch between system, light, and dark modes directly within the app.
- **History Tracking**: Keeps a history of your past solves, displaying the last 10 solves on the main screen.
- **Solve Management**: View your entire solve history in a separate list, with the ability to delete individual solves or reset all data.
- **Persistent Storage**: All your solves, statistics, and theme preferences are saved automatically.
- **New App Icon**: Features a modern, vibrant 3D Rubik's cube design.

## Requirements

- iOS 15.0 or later (depending on Xcode settings)
- Xcode 14 or later to compile and install

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/vleung1/cubeTimer.git
   ```
2. **Open the project:**
   Open the `cubeTimer.xcodeproj` file in Xcode.
   ```bash
   cd cubeTimer
   open cubeTimer.xcodeproj
   ```
3. **Build and Run:**
   - Select your target device (e.g., your iPhone or a Simulator) from the run destination menu in the toolbar.
   - Press the **Run** button (`Cmd + R`) to compile and install the app on your selected device.

## Usage

- Tap the big **START** button to begin timing your solve. The button will turn red and say **STOP**.
- Tap the **STOP** button to end the timer and record your solve.
- Your statistics (**Best Time**, Overall Avg, and Last 10 Avg) will automatically update.
- Use the **Theme Toggle** (sun/moon icon) in the top left to switch between light, dark, and system color schemes.
- Tap **Solves** in the top right corner to view or manage your full solve history.
- Tap **Reset Timer** if you want to clear the current timer without saving the solve.
- View your **Progress Chart** on the main screen to see your solve times trending over time.

## License

This project is for personal use and learning. Make sure to check back for updates and new features!
