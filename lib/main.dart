import 'package:flutter/material.dart';
import 'package:madmon/view/id.dart';
import 'package:madmon/view/login.dart';
import 'package:madmon/view/splachScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      theme: ThemeData(
        fontFamily: 'droid',
      ),
      home: Splachscreen(),
      routes: {
        '/role-selection': (context) => ID(),
        '/login': (context) => Login(),
      },
    );
  }
}