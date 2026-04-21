class Applicant {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String domain;
  final String status; // 🔥 NEW

  Applicant({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.domain,
    required this.status, // 🔥
  });

  // 🔄 FROM JSON (API → APP)
  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      domain: json['domain'] ?? '',
      status: json['status'] ?? 'pending', // 🔥
    );
  }

  // 🔄 TO JSON (APP → API)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "email": email,
      "domain": domain,
      "status": status, // 🔥
    };
  }
}