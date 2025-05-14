import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressedCallback; // 用來傳遞不同的回調

  const ElevatedButtonWidget({super.key, required this.buttonName, required this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressedCallback,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEA916E),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFEA916E)
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 14
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(buttonName)
    );
  }

}