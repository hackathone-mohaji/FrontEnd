import 'package:camfit/data/repositories/AuthRepository.dart';
import 'package:flutter/material.dart';
import 'package:camfit/presentation/screens/HomePage.dart';
import 'package:camfit/presentation/screens/OotdPage.dart';
import 'package:camfit/presentation/screens/ProfilePage.dart';
import 'package:camfit/presentation/screens/LoginPage.dart';
import 'package:camfit/presentation/screens/SignupPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String?>(
        future: AuthRepository().getAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return const HomePage();
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        '/main': (context) => const HomePage(),
        '/ootd': (context) => const OotdPage(),
        '/profile': (context) => const ProfilePage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
