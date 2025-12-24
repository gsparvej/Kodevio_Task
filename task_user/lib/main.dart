import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ১. Provider ইমপোর্ট আছে কিনা দেখুন
import 'package:task_user/theme/theme_provider.dart';
import 'screens/user_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // ৩. ChangeNotifierProvider দিয়ে MaterialApp কে র‍্যাপ করেছেন কিনা দেখুন
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kodevio Users',
            theme: themeProvider.themeData, // ৪. থিম কানেক্ট করা আছে কিনা
            home: const UserListScreen(),
          );
        },
      ),
    );
  }
}