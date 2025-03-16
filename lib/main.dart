import 'package:flutter/material.dart';
import 'package:camfit/presentation/screens/HomePage.dart'; 
import 'package:camfit/presentation/screens/OotdPage.dart'; 
import 'package:camfit/presentation/screens/ProfilePage.dart'; 
import 'package:camfit/presentation/screens/LoginPage.dart'; 
import 'package:camfit/presentation/screens/SignupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearAccessTokenOnStartup(); // 앱 시작 시 엑세스 토큰 삭제
  runApp(MyApp());
}

Future<void> clearAccessTokenOnStartup() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken'); // 저장된 엑세스 토큰 삭제
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