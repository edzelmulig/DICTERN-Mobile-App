import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

// FUNCTION THAT WILL DISPLAY LOADING INDICATOR
void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent users from dismissing the dialog
    builder: (context) => Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white.withOpacity(0),
        ),
        width: 120,
        height: 120,
        child: const LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          colors: [Color(0xFFE0E8F7)],
        ),
      ),
    ),
  );
}