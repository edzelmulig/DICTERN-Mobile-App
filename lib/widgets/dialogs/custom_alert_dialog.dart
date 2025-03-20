import 'package:dicternclock/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

// ALERT DIALOG CUSTOM CLASS
class CustomAlertDialog extends StatelessWidget {
  final String message;
  final Color backGroundColor;
  final VoidCallback onPressed;
  final String filePath;
  final String buttonLabel;

  const CustomAlertDialog({
    super.key,
    required this.message,
    required this.backGroundColor,
    required this.onPressed,
    required this.filePath,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: backGroundColor,
      elevation: 10.0,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Image.asset(
              filePath, // Replace with your actual GIF path
              height: 100,
              width: 100,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF002091),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        CustomButton(
          buttonLabel: buttonLabel,
          onPressed: onPressed,
          buttonHeight: 55,
          buttonColor: const Color(0xFF002091),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontColor: Colors.white,
          borderRadius: 10, gradientColors: const [Color(0xFF00a2ff),
          Color(0xFF013dd6),],
        ),
      ],
    );
  }
}
