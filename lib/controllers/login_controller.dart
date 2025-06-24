import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController{
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool login(){
    return userController.text.trim()=='admin'&&
    passwordController.text.trim()=='1234';
  }

  void dispose(){
    userController.dispose();
    passwordController.dispose();
  }
}
