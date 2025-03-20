import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dicternclock/data/services/shared_preference.dart';
import 'package:dicternclock/presentation/screens/dashboard_screen.dart';
import 'package:dicternclock/widgets/loading_indicator/custom_loading_indicator.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN IN AUTHENTICATION
  Future<void> signIn({
    required BuildContext context,
    required String username,
    required String password,
    required bool isChecked,
  }) async {
    try {
      // SHOW LOADING INDICATOR
      if (context.mounted) showLoadingIndicator(context);

      // SIGN IN WITH EMAIL & PASSWORD
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: username.trim(),
        password: password.trim(),
      );

      // CHECK IF USER EXISTS
      String userId = userCredential.user!.uid;

      // Fetch userType from the root document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception("User data not found in Firestore.");
      }

      // ✅ Ensure user document exists and contains `user_role`
      if (!userDoc.exists || !userDoc.data().toString().contains('role')) {
        throw FirebaseAuthException(code: 'not-admin', message: 'Access denied. Admin only.');
      }

      // Retrieve user role
      String role = userDoc.get('role');

      if (role != 'admin') {
        throw FirebaseAuthException(code: 'not-admin', message: 'Access denied. Admin only.');
      }

      // SAVE CREDENTIALS IF "Remember Me" IS CHECKED
      if (isChecked) {
        await PreferenceService.saveCredentials(username.trim(), password.trim());
      }

      // ✅ Check if context is still mounted before navigating
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = (e.code == 'user-not-found')
          ? 'Account not found. Please check your email.'
          : (e.code == 'wrong-password')
          ? 'Incorrect password. Try again.'
          : (e.code == 'not-admin')
          ? 'Access denied. Admin only.'
          : 'Error: ${e.message}';

      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');

      // DISPLAY ERROR MESSAGE
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        Navigator.of(context).pop(); // Dismiss loading
      }
    } catch (e) {
      debugPrint('Error signing in: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        if (Navigator.of(context).canPop()) Navigator.of(context).pop(); // Dismiss loading
      }
    }
  }
}
