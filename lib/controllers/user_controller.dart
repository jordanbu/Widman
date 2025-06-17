import 'package:flutter/material.dart';

class UserController{
  final TextEditingController controller = TextEditingController();

  String get value => controller.text.trim();

  void dispose(){
    controller.dispose();
  }
}