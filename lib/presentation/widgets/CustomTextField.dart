import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle:
                const TextStyle(fontSize: 14, color: Colors.black87),
            border:
                OutlineInputBorder(borderRadius:
                BorderRadius.circular(10.0)),
            focusedBorder:
                OutlineInputBorder(borderRadius:
                BorderRadius.circular(10.0), borderSide:
                BorderSide(color:
                Colors.black26)),
          ),
        ),
      ),
    );
  }
}
