// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit_note_outlined,
            size: 150,
            color: Colors.amberAccent.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          const Center(
            child: CircularProgressIndicator(backgroundColor: Colors.amber),
          ),
        ],
      ),
    );
  }
}
