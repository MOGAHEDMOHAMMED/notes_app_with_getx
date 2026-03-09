// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final ThemeData theme;
  final bool isPassword;
  final bool isObscured;
  final bool isEmail;
  final VoidCallback? onIconPressed;
  const BuildTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.theme,
    this.isObscured = false,
    this.isPassword = false,
    this.onIconPressed,
    this.isEmail = false,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? isObscured : false,
      textAlign: TextAlign.center,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : (isPassword
                ? TextInputType.visiblePassword
                : TextInputType.name),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: isPassword
            ? IconButton(icon: Icon(icon), onPressed: onIconPressed)
            : Icon(icon),
      ),
    );
  }
}
