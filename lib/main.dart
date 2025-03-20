import 'package:dicternclock/core/theme/app_theme.dart';
import 'package:dicternclock/firebase_options.dart';
import 'package:dicternclock/presentation/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Main function of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase Initialized Successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(const MyApp());
}

// Handles the navigation to landing page.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: customThemePrimary,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFF2650CB),
              selectionColor: Color(0xFF2650CB),
              selectionHandleColor: Color(0xFF2650CB),
            )),
        home: const LoginScreen());
  }
}