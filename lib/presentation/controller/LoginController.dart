import 'package:flutter/material.dart';
import 'package:camfit/data/repositories/AuthRepository.dart';

class LoginController {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> login(String email, String password, BuildContext context) async {
    final result = await _authRepository.login(email, password);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 성공!')),
      );
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: ${result['error']}')),
      );
    }
  }
}
