import 'package:flutter/material.dart';

class AdminDBFields{
  static const String dbf_username="username";
  static const String dbf_password="password";
}

class Admin {
  final String username;
  final String password;

  Admin({
    required this.username,
    required this.password,
  });

  Map<String, Object?> toJson() {
    return {
      AdminDBFields.dbf_username : username,
      AdminDBFields.dbf_password : password,
    };
  }
}