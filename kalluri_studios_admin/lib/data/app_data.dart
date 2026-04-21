import '../models/applicant.dart';

class AppData {

  // 🔥 STORE ALL APPLICANTS
  static List<Applicant> applicants = [];

  // =========================
  // ➕ ADD APPLICANT
  // =========================
  static void addApplicant(Applicant applicant) {
    applicants.add(applicant);
  }

  // =========================
  // ✏️ UPDATE APPLICANT
  // =========================
  static void updateApplicant(Applicant updatedApplicant) {
    int index = applicants.indexWhere(
      (a) => a.id == updatedApplicant.id,
    );

    if (index != -1) {
      applicants[index] = updatedApplicant;
    }
  }

  // =========================
  // 🗑 DELETE APPLICANT
  // =========================
  static void deleteApplicant(int id) {
    applicants.removeWhere((a) => a.id == id);
  }

  // =========================
  // 📊 TOTAL COUNT
  // =========================
  static int get totalApplicants {
    return applicants.length;
  }

  // =========================
  // 📊 DOMAIN COUNT (FOR CHART)
  // =========================
  static Map<String, int> getDomainStats() {
    Map<String, int> stats = {};

    for (var a in applicants) {
      stats[a.domain] = (stats[a.domain] ?? 0) + 1;
    }

    return stats;
  }
}