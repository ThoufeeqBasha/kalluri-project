import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/applicant.dart';

class ApiService {

  // 🔥 CHANGE THIS IF NEEDED
  static const String baseUrl = "http://127.0.0.1:8080/kalluri-api";

  // =========================
  // 📥 GET APPLICANTS
  // =========================
  static Future<List<Applicant>> getApplicants() async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_applicants.php"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<Applicant>.from(
        data.map((e) => Applicant.fromJson(e)),
      );
    } else {
      throw Exception("Failed to load applicants");
    }
  }

  // =========================
  // ➕ ADD APPLICANT
  // =========================
  static Future<void> addApplicant(Applicant applicant) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_applicant.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(applicant.toJson()), // includes status
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add applicant");
    }
  }

  // =========================
  // ✏️ UPDATE APPLICANT
  // =========================
  static Future<void> updateApplicant(Applicant applicant) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update_applicant.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(applicant.toJson()), // includes status
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update applicant");
    }
  }

  // =========================
  // 🗑 DELETE APPLICANT
  // =========================
  static Future<void> deleteApplicant(int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_applicant.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete applicant");
    }
  }

  // =========================
  // ✅ UPDATE STATUS (🔥 NEW)
  // =========================
  static Future<void> updateStatus(int id, String status) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update_status.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "status": status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update status");
    }
  }
}