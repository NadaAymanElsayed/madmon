# Madmon

Madmon is a task management mobile application built with Flutter. It enables admins to assign tasks to technicians and allows each technician to view only their own assigned tasks.

## ✨ About This Project

This is my first real freelance project as a Flutter developer.  
Through this project, I gained hands-on experience with:

- Firebase integration (Authentication & Firestore)
- State management using Cubit (from flutter_bloc)
- Role-based navigation and UI
- Form validation and custom dialogs
- Building production-ready UIs

The app was designed to be simple, lightweight, and easy for both admins and technicians to use.

## 🔧 Features

- Login & Sign up with role-based access (admin / technician)
- Admin can:
  - Add new tasks
  - Edit existing tasks
  - View all tasks (completed & incomplete)
- Technician can:
  - View only their assigned tasks
  - See available (incomplete) tasks only
- Tasks stored in Firebase Firestore

## 🚀 Getting Started

Clone the project and run it using:

```bash
flutter pub get
flutter run
📱 Screens
Login Screen

Sign Up Screen

Admin Home Screen (with task tabs)

Technician Home Screen (filtered by technician name)

📂 Project Structure
lib/view/ – Screens and UI components

lib/cubit/ – Cubit classes and states

lib/model/ – Data models

lib/utils/ – Helper methods (dialogs, constants, etc.)

📦 Packages Used
firebase_core

firebase_auth

cloud_firestore

flutter_bloc

equatable

🤝 Contributions
As this is a freelance project for a specific client, contributions are currently not open.
However, feedback is always welcome!

Built with ❤️ using Flutter.
