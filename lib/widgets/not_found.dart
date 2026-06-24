import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          Image.asset(
            'assets/images/error.png',
            height: 250,
            color: Colors.white38,
          ),
          const SizedBox(height: 20),
          const Text(
            'No items found, try adding some!',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 22,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}
