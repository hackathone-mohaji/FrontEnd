import 'package:flutter/material.dart';
import 'package:camfit/data/repositories/AuthRepository.dart';

class SignupController {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> signUp(String name, String email, String password, BuildContext context) async {
    final result = await _authRepository.signUp(name, email, password);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공!')),
      );
      Navigator.pop(context, 'signup_success'); // 회원가입 성공 메시지 전달
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${result['error']}')),
      );
    }
  }
}
