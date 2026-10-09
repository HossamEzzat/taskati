# Taskati — Personal Task Manager

A simple and intuitive task management application built with Flutter. Taskati helps users organize
their daily tasks, track completed work, and stay productive through a clean and user-friendly
interface.

## ✨ Features

- **Create Tasks:** Add tasks with a title and description.
- **View Active Tasks:** Browse your current tasks in an organized list.
- **Complete Tasks:** Mark tasks as completed and move them to the completed tasks list.
- **Completed Tasks:** Review previously completed tasks.
- **Restore Tasks:** Move completed tasks back to the active tasks list.
- **Delete Tasks:** Remove tasks you no longer need.
- **Local Storage:** Store tasks locally using Hive.
- **Empty States:** Display helpful UI when task lists are empty.
- **Modern UI:** Clean layouts, consistent colors, and intuitive interactions.

## 🛠️ Built With

- [Flutter](https://flutter.dev/) — Cross-platform UI framework.
- [Dart](https://dart.dev/) — Programming language.
- [Hive](https://pub.dev/packages/hive) — Local key-value storage.
- [hive_flutter](https://pub.dev/packages/hive_flutter) — Flutter integration for Hive.
- [Lottie](https://pub.dev/packages/lottie) — Animation support for the empty tasks screen.

## 📱 Application Screens

Taskati includes the following screens:

- **My Tasks:** View, create, complete, and delete active tasks.
- **Add Task:** Create a task with a title and description.
- **Completed Tasks:** View completed tasks, restore them, or delete them.

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have:

- Flutter SDK installed.
- Dart SDK compatible with your Flutter version.
- Android Studio, VS Code, or another Flutter-compatible IDE.
- An emulator or a physical device.

### Installation

1. Clone the repository:

   ```bash
   git clone <YOUR_REPOSITORY_URL>
   ```

2. Navigate to the project directory:

   ```bash
   cd taskati
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## 📂 Project Structure

The application includes these main screens:

```text
lib/
├── main.dart
├── add_task_screen.dart
├── done_task_screen.dart
└── ...
```

The exact project structure may vary depending on your implementation.

## 💾 Data Storage

Taskati uses Hive for local task storage.

Tasks are stored in two boxes:

- `myTasks` — Active tasks.
- `doneTasks` — Completed tasks.

Each task contains the following fields:

| Field     | Description             |
|-----------|-------------------------|
| `title`   | Task title              |
| `desc`    | Task description        |
| `isCheck` | Completion status field |

Tasks are stored locally on the device. Cloud synchronization and cross-device backup are not
included in the currently described implementation.

## 🧪 Testing

Run the Flutter analyzer:

```bash
flutter analyze
```

Run the project tests:

```bash
flutter test
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Hive Package](https://pub.dev/packages/hive)
- [Lottie Package](https://pub.dev/packages/lottie)

## 🗺️ Roadmap

Potential future improvements:

- Task search and filtering.
- Task priorities and categories.
- Due dates and reminders.
- Dark mode.
- Task statistics and productivity insights.
- Cloud backup and synchronization.

## 🤝 Contributing

Contributions, suggestions, and bug reports are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Implement your changes.
4. Test your changes.
5. Submit a pull request.

## 📄 License

No license has been specified yet. Add a `LICENSE` file and update this section before distributing
the project as open source.

---

**Taskati — Organize your tasks. Focus on what matters.**

by Hossam