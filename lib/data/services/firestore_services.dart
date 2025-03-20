import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadStudentData(List<Map<String, dynamic>> students) async {
    WriteBatch batch = _db.batch();
    CollectionReference studentsRef = _db.collection("students");

    for (var student in students) {
      DocumentReference docRef = studentsRef.doc(student['ID_No']);
      batch.set(docRef, student);
    }

    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    try {
      QuerySnapshot snapshot = await _db.collection("students").get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getStudentById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection("students").doc(id).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print("Error fetching student: $e");
      return null;
    }
  }
}
