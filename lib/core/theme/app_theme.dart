import 'package:flutter/material.dart';

const MaterialColor customThemePrimary = MaterialColor(_customThemePrimaryValue, <int, Color>{
  50: Color(0xFFE0E8F7), // Lightest shade (10% opacity)
  100: Color(0xFFB3C3EC), // Lighter shade
  200: Color(0xFF8099E0), // Light shade
  300: Color(0xFF4D6FD4), // Light-medium shade
  400: Color(0xFF2650CB), // Medium shade
  500: Color(_customThemePrimaryValue), // Primary color
  600: Color(0xFF002F90), // Slightly darker
  700: Color(0xFF00297A), // Darker
  800: Color(0xFF002366), // Even darker
  900: Color(0xFF001845), // Darkest shade
});
const int _customThemePrimaryValue = 0xFF0038A8; // Primary color: #0038A8

const MaterialColor customThemeAccent = MaterialColor(_customThemeAccentValue, <int, Color>{
  100: Color(0xFFD6E1FF), // Light accent shade
  200: Color(_customThemeAccentValue), // Accent color
  400: Color(0xFF8099FF), // Stronger accent
  700: Color(0xFF4D6DFF), // Boldest accent
});
const int _customThemeAccentValue = 0xFFB3C6FF; // Accent color
