// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CenterIfNotesEmpty extends StatelessWidget {
  final IconData icon;
  final String message;
  const CenterIfNotesEmpty({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 150,
            color: const Color.fromARGB(255, 219, 185, 63).withOpacity(0.7),
          ),
          const SizedBox(height: 20),
          Text(message),
        ],
      ),
    );
  }
}
