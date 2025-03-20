import 'package:dicternclock/data/services/excel_services.dart';
import 'package:dicternclock/data/services/firestore_services.dart';
import 'package:dicternclock/utils/screen_util.dart';
import 'package:dicternclock/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ImportInternScreen extends StatefulWidget {
  const ImportInternScreen({super.key});

  @override
  State<ImportInternScreen> createState() => _ImportInternScreenState();
}

class _ImportInternScreenState extends State<ImportInternScreen> {
  bool _isUploading = false;
  bool _isFileSelected = false;
  List<Map<String, dynamic>> _students = [];
  final FirestoreService _firestoreService = FirestoreService();
  final ExcelService _excelService = ExcelService();

  void _selectFile() async {
    var students = await _excelService.pickAndParseExcel();

    if (students == null || students.isEmpty) {
      _showMessage(
        "Invalid or empty file! Please check the format.",
        const Color(0xFFe91b4f),
      );
      return;
    }

    setState(() {
      _students = students;
      _isFileSelected = true;
    });

    _showMessage("Your file is ready for import!", const Color(0xFF107c41));
  }

  void _uploadData() async {
    if (_students.isEmpty) {
      _showMessage("No data to upload!", const Color(0xFFe91b4f));
      return;
    }

    setState(() => _isUploading = true);

    await _firestoreService.uploadStudentData(_students);

    setState(() {
      _isUploading = false;
      _isFileSelected = false;
      _students.clear();
    });

    _showMessage(
      "Data import successful!",
      const Color(0xFF107c41),
    );
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
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        if (_) {
          return;
        }
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: const CustomAppBar(title: "IMPORT INTERN DATA"),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFC0C3C9),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SelectFileButton(
                          key: ValueKey(_isFileSelected),
                          // This forces the widget to rebuild when state changes
                          onPressed: _selectFile,
                          isFileSelected: _isFileSelected,
                        ),
                        const SizedBox(height: 12),
                        UploadButton(
                          onPressed: _isFileSelected ? _uploadData : null,
                          isUploading: _isUploading,
                        ),
                      ],
                    ),
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

class SelectFileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isFileSelected;

  const SelectFileButton(
      {super.key, required this.onPressed, required this.isFileSelected});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtil.of(context);
    return SizedBox(
      width: screen.width * 0.9,
      height: screen.height * 0.15,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isFileSelected
                ? Image(
                    image: const AssetImage("lib/assets/images/excel_logo.png"),
                    width: screen.width * 0.1,
                    height: screen.height * 0.1,
                  )
                : Image(
                    image:
                        const AssetImage("lib/assets/images/upload_icon.png"),
                    width: screen.width * 0.05,
                    height: screen.height * 0.05,
                  ),
            SizedBox(height: screen.height * 0.001),
            Text(
              isFileSelected ? "Excel File Loaded" : "Select Excel File",
              style: TextStyle(
                  fontSize: screen.width * 0.03, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screen.height * 0.01),
          ],
        ),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isUploading;

  const UploadButton(
      {super.key, required this.onPressed, required this.isUploading});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtil.of(context);
    return SizedBox(
      width: screen.width * 0.9,
      height: screen.height * 0.08,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null
              ? const Color(0xFF107c41)
              : const Color(0xFF1E1E1F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: isUploading
            ? SizedBox(
                width: screen.width * 0.07,
                height: screen.width * 0.07,
                child: const LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: [Colors.white],
                ),
              )
            : Text(
                "Import Data",
                style: TextStyle(
                    fontSize: screen.width * 0.035,
                    fontWeight: FontWeight.normal),
              ),
      ),
    );
  }
}
