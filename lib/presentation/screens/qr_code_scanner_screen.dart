import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import 'package:dicternclock/widgets/app_bar/custom_app_bar.dart';
import 'dart:async';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  String selectedAction = "TIME IN";
  bool isScanning = false;
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  String? studentName, studentId, studentYear, studentSchool, scannedTime;
  double scanLinePosition = 0;

  @override
  void initState() {
    super.initState();
    _startScanLineAnimation();
  }

  void _startScanLineAnimation() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        scanLinePosition += 5;
        if (scanLinePosition > 240) {
          scanLinePosition = 5;
        }
      });
    });
  }
  void _onScan(String? scannedId) async {
    if (isScanning || scannedId == null || scannedId.isEmpty) return;
    print("Scanned ID: $scannedId"); // Debugging Log

    setState(() => isScanning = true);

    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);
    String currentTime = DateFormat('hh:mm a').format(now);
    DateTime parsedCurrentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    // Define allowed time ranges
    DateTime timeInStart = DateTime(now.year, now.month, now.day, 7, 0);
    DateTime timeInEnd = DateTime(now.year, now.month, now.day, 11, 59);
    DateTime breakStart = DateTime(now.year, now.month, now.day, 12, 0);
    DateTime breakEnd = DateTime(now.year, now.month, now.day, 12, 59);
    DateTime timeOutStart = DateTime(now.year, now.month, now.day, 13, 0);
    DateTime timeOutEnd = DateTime(now.year, now.month, now.day, 18, 0);

    // Validation for each action
    if (selectedAction == "TIME IN" &&
        (parsedCurrentTime.isBefore(timeInStart) || parsedCurrentTime.isAfter(timeInEnd))) {
      _showMessage("TIME IN allowed only between 7:00 AM - 11:59 AM!", const Color(0xFFe91b4f));
    } else if ((selectedAction == "BREAK OUT" || selectedAction == "BREAK IN") &&
        (parsedCurrentTime.isBefore(breakStart) || parsedCurrentTime.isAfter(breakEnd))) {
      _showMessage("BREAK OUT/IN allowed only between 12:00 PM - 12:59 PM!", const Color(0xFFe91b4f));
    } else if (selectedAction == "TIME OUT" &&
        (parsedCurrentTime.isBefore(timeOutStart) || parsedCurrentTime.isAfter(timeOutEnd))) {
      _showMessage("TIME OUT allowed only between 1:00 PM - 6:00 PM!", const Color(0xFFe91b4f));
    } else {
      DocumentReference studentRef =
      FirebaseFirestore.instance.collection('students').doc(scannedId);
      DocumentSnapshot studentSnapshot = await studentRef.get();

      if (studentSnapshot.exists) {
        Map<String, dynamic> studentData = studentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          studentId = scannedId;
          studentName = studentData['Student_Name'] ?? 'Unknown';
          studentYear = studentData['Grade_Year'] ?? 'N/A';
          studentSchool = studentData['School'] ?? 'N/A';
          scannedTime = currentTime;
        });

        await studentRef.collection("attendance").doc(currentDate).set({
          selectedAction.replaceAll(" ", "_").toLowerCase(): currentTime,
        }, SetOptions(merge: true));

        _showMessage("Attendance recorded: $selectedAction at $currentTime", Colors.green);
      } else {
        _showMessage("Student not found!", const Color(0xFFe91b4f));
      }
    }

    // **Reset scanner after 3 seconds**
    Future.delayed(const Duration(seconds: 3), () {
      _resetScanner();
    });
  }

  void _resetScanner() {
    setState(() => isScanning = false);
    _controller.stop(); // Stop the scanner
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.start(); // Restart after a slight delay
    });
  }

  void _showMessage(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: const CustomAppBar(title: "QR CODE SCANNER"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFADC3F3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              _buildActionButtons(),
              const SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 250,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 5),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: MobileScanner(
                            controller: _controller,
                            onDetect: (barcodeCapture) {
                              for (final barcode in barcodeCapture.barcodes) {
                                if (barcode.rawValue != null) {
                                  _onScan(barcode.rawValue!);
                                }
                              }
                            },
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 100),
                          top: scanLinePosition,
                          left: 5,
                          right: 5,
                          child: Container(
                            height: 3,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (studentName != null) _buildStudentInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton("TIME IN"),
            _buildActionButton("BREAK OUT"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton("BREAK IN"),
            _buildActionButton("TIME OUT"),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ElevatedButton(
          onPressed: () => setState(() => selectedAction = label),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor:
            selectedAction == label ? const Color(0xFF013dd6) : Colors.grey,
            minimumSize: const Size(double.infinity, 55.5),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$studentName",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text("Time Scanned: $scannedTime",
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFe91b4f))),
        ],
      ),
    );
  }
}
