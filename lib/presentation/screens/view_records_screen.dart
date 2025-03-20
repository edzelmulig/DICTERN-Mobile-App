import 'package:dicternclock/data/services/firestore_services.dart';
import 'package:dicternclock/utils/screen_util.dart';
import 'package:dicternclock/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ViewRecordsScreen extends StatefulWidget {
  const ViewRecordsScreen({super.key});

  @override
  State<ViewRecordsScreen> createState() => _ViewRecordsScreenState();
}

class _ViewRecordsScreenState extends State<ViewRecordsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    List<Map<String, dynamic>> students =
        await _firestoreService.getAllStudents();
    setState(() {
      _students = students;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtil.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: const CustomAppBar(title: "STUDENT RECORDS"),
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 6, // Show shimmer for 6 items
                itemBuilder: (context, index) => const ShimmerLoadingCard(),
              )
            : _students.isEmpty
                ? const Center(child: Text("No students found"))
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      return Container(
                        margin: EdgeInsets.zero,
                        child: StudentCard(student: student),
                      );
                    },
                  ),
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    String imageUrl = student["Gdrive_Link"] ?? "";

    if (imageUrl.contains("drive.google.com")) {
      final match = RegExp(r"/d/([^/]+)/").firstMatch(imageUrl);
      if (match != null) {
        imageUrl = "https://drive.google.com/uc?export=view&id=${match.group(1)}";
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white60,
          foregroundColor: const Color(0xFF2650CB),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Image.asset(
                      "lib/assets/images/image_place_holder.png",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "lib/assets/images/image_place_holder.png",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student["Student_Name"] ?? "Unknown",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${student["Grade_Year"] ?? "N/A"} - ${student["School"] ?? "Unknown"}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Shimmer effect card
class ShimmerLoadingCard extends StatelessWidget {
  const ShimmerLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Card(
        color: Colors.white60,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        width: 100, // Same width as name text
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 14,
                        width: 150, // Same width as grade-year and school
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
