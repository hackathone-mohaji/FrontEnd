import 'package:flutter/material.dart';
import 'package:camfit/presentation/screens/HomePage.dart'; 
import 'package:camfit/presentation/screens/OotdPage.dart'; 
import 'package:camfit/presentation/screens/ProfilePage.dart'; 
import 'package:camfit/presentation/screens/LoginPage.dart'; 
import 'package:camfit/presentation/screens/SignupPage.dart'; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CamFit',
      initialRoute: '/',
      routes: {
        '/': (context) =>  LoginPage(),
        '/main': (context) => const HomePage(),
        '/ootd': (context) => const OotdPage(),
        '/profile': (context) => const ProfilePage(),
        '/signup': (context) =>  SignupPage(),
      },
    );
  }
}