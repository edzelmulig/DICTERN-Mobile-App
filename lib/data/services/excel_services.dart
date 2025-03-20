import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class ExcelService {
  Future<List<Map<String, dynamic>>?> pickAndParseExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result == null) return null; // No file selected

    File file = File(result.files.single.path!);
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    List<Map<String, dynamic>> students = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;
      if (sheet.rows.isEmpty) return null; // Empty file

      // Extract headers from the first row
      List<String> headers = sheet.rows.first.map((cell) => cell?.value?.toString() ?? "").toList();

      // Check if required headers exist
      List<String> requiredHeaders = [
        "School",
        "ID_No",
        "Student_Name",
        "Grade_Year",
        "Emergency_Contact_Person",
        "Emergency_Contact_No",
        "Code",
        "Gdrive_Link"
      ];

      if (!_validateHeaders(headers, requiredHeaders)) {
        return null; // Return null to indicate incorrect format
      }

      // Parse data (start from row 1, skipping headers)
      for (var i = 1; i < sheet.rows.length; i++) {
        var row = sheet.rows[i];
        Map<String, dynamic> student = {};

        for (int j = 0; j < headers.length; j++) {
          student[headers[j]] = row[j]?.value?.toString() ?? "";
        }

        students.add(student);
      }
    }

    return students;
  }

  bool _validateHeaders(List<String> headers, List<String> requiredHeaders) {
    for (String header in requiredHeaders) {
      if (!headers.contains(header)) {
        return false; // Template is incorrect
      }
    }
    return true;
  }
}
