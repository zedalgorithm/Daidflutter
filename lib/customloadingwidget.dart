

import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD71802)),
          ),
          const SizedBox(height: 16),
          Text(
            'Signing in...',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}