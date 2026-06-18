import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/mainScrren.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('profileImage');
  await Hive.openBox('tasks');
  await Hive.openBox('doneTasks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskati',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Mainscrren(),
    );
  }
}
