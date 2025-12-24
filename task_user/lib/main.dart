import 'package:flutter/material.dart';
import 'screens/user_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User App',
      debugShowCheckedModeBanner: false,

      // 🌞 Light Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // 🌙 Dark Theme (Bonus)
      darkTheme: ThemeData.dark(),

      // System theme follow করবে
      themeMode: ThemeMode.system,

      // 🏠 Home Screen
      home: const UserListScreen(),
    );
  }
}
