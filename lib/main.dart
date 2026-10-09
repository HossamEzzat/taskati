import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'my_tasks_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("myTasks");
  await Hive.openBox("doneTasks");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyTasksScreen(),
    );
  }
}
