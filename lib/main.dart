import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'screens/WelcomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
      },
    );
  }
}
