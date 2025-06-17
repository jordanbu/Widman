import 'package:flutter/material.dart';

class LoginController {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool login() {
    return userController.text.trim() == "admin" &&
        passwordController.text.trim() == "1234";
  }

  void dispose() {
    userController.dispose();
    passwordController.dispose();
  }
}
