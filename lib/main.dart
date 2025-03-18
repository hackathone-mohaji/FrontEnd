import 'package:camfit/data/repositories/AuthRepository.dart';
import 'package:flutter/material.dart';
import 'package:camfit/presentation/screens/HomePage.dart';
import 'package:camfit/presentation/screens/OotdPage.dart';
import 'package:camfit/presentation/screens/ProfilePage.dart';
import 'package:camfit/presentation/screens/LoginPage.dart';
import 'package:camfit/presentation/screens/SignupPage.dart';
import 'package:photo_manager/photo_manager.dart'; // 권한 요청을 위한 패키지 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// ✅ 앱 실행 시 권한 요청
  Future<bool> _requestPermissions() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    return permission.hasAccess;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _requestPermissions(), // 권한 요청
      builder: (context, permissionSnapshot) {
        if (permissionSnapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!permissionSnapshot.hasData || !permissionSnapshot.data!) {
          // 권한이 거부된 경우
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      "갤러리 접근 권한이 필요합니다.",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final granted = await PhotoManager.requestPermissionExtend();
                        if (granted.hasAccess) {
                          // 권한을 다시 요청하고 성공하면 앱을 재시작
                          runApp(const MyApp());
                        }
                      },
                      child: const Text("권한 요청하기"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

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
      },
    );
  }
}
