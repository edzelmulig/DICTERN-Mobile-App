import 'package:dicternclock/presentation/screens/import_intern_screen.dart';
import 'package:dicternclock/presentation/screens/qr_code_scanner_screen.dart';
import 'package:dicternclock/presentation/screens/view_records_screen.dart';
import 'package:dicternclock/utils/modal_util.dart';
import 'package:dicternclock/utils/navigation_util.dart';
import 'package:dicternclock/utils/screen_util.dart';
import 'package:dicternclock/widgets/buttons/custom_button.dart';
import 'package:dicternclock/widgets/image/custom_image_display.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtil.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFF91B0EF),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),

                  // Maintenance Graphics
                  CustomImageDisplay(
                    imageSource: "lib/assets/images/under_maintenance.png",
                    imageHeight: screen.height * 0.30,
                    imageWidth: screen.width * 0.40,
                  ),

                  const SizedBox(height: 10),

                  // Maintenance Text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Some features are currently unavailable as we roll out updates.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3C3C40),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Buttons Container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF9CB0D8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        // Import Intern Data
                        _DashboardButton(
                          imageSource: "lib/assets/images/excel_logo.png",
                          text: "Import Intern Data",
                          onPressed: () {
                            navigateWithSlideFromRight(
                              context,
                              const ImportInternScreen(),
                              1.0,
                              0.0,
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        // View Records
                        _DashboardButton(
                          imageSource: "lib/assets/images/folder.png",
                          text: "View Records",
                          onPressed: () {
                            navigateWithSlideFromRight(
                              context,
                              const ViewRecordsScreen(),
                              1.0,
                              0.0,
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        // QR Code Scanner
                        _DashboardButton(
                          imageSource:
                              "lib/assets/images/qr_code_scanner_icon.png",
                          text: "QR Code Scanner",
                          onPressed: () {
                            navigateWithSlideFromRight(
                              context,
                              QRCodeScannerScreen(),
                              1.0,
                              0.0,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Logout Button
                  _LogoutButton(
                    onPressed: () {
                      showLogoutModal(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final String imageSource;
  final String text;
  final VoidCallback onPressed;

  const _DashboardButton({
    required this.imageSource,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtil.of(context);

    return SizedBox(
      width: double.infinity, // Makes button take full width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent,
          // Required for gradient effect
          shadowColor: Colors.transparent,
          // Removes default shadow
          foregroundColor: Colors.white, // Text color
        ).copyWith(
          elevation: WidgetStateProperty.all(0), // Remove default elevation
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              return Colors
                  .transparent; // Keeps button transparent for gradient
            },
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4D6DFF),
                Color(0xFF002F90),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Icon/Image
                CustomImageDisplay(
                  imageSource: imageSource,
                  imageHeight: screen.height * 0.06,
                  imageWidth: screen.width * 0.12,
                ),
                const SizedBox(width: 20),

                // Button Label
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: screen.width * 0.045,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LogoutButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      buttonLabel: "Log Out",
      onPressed: onPressed,
      buttonHeight: 55.0,
      fontWeight: FontWeight.bold,
      fontSize: 15,
      fontColor: Colors.white,
      borderRadius: 10,
      gradientColors: const [
        Color(0xFFe91b4f),
        Color(0xFFe91b4f),
      ],
    );
  }
}
