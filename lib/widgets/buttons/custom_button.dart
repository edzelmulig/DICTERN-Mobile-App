
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonLabel;
  final VoidCallback onPressed;
  final double buttonHeight;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final double borderRadius;
  final List<Color> gradientColors; // Accept gradient colors

  const CustomButton({
    required this.buttonLabel,
    required this.onPressed,
    required this.buttonHeight,
    required this.fontSize,
    required this.fontWeight,
    required this.fontColor,
    required this.borderRadius,
    required this.gradientColors,
    Color buttonColor =  const Color(0xFF00a2ff), // Default gradient colors
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // Ensure full coverage of gradient
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor:
          Colors.transparent, // Make background transparent for gradient
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              buttonLabel,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: fontColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
