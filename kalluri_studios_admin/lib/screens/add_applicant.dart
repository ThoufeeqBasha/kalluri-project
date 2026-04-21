import 'package:flutter/material.dart';
import '../models/applicant.dart';
import '../services/api_service.dart';

class AddApplicantScreen extends StatefulWidget {
  const AddApplicantScreen({super.key});

  @override
  State<AddApplicantScreen> createState() =>
      _AddApplicantScreenState();
}

class _AddApplicantScreenState
    extends State<AddApplicantScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String domain = "Acting";

  // 🔥 VALIDATION FUNCTION
  bool validate() {

    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name)) {
      showMsg("Name must contain only letters");
      return false;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      showMsg("Phone must be 10 digits");
      return false;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      showMsg("Enter valid email");
      return false;
    }

    return true;
  }

  // 🔥 SAVE
  Future<void> save() async {

    if (!validate()) return;

    await ApiService.addApplicant(
      Applicant(
        id: 0,
        name: nameController.text,
        phone: phoneController.text,
        domain: domain, email: emailController.text,
        status: "pending"
      ),
    );

    showMsg("Applicant added successfully");
    Navigator.pop(context, true);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),

      appBar: AppBar(
        title: const Text("Add Applicant"),
        backgroundColor: const Color(0xFF161B22),
      ),

      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(25),

          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 20,
              )
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Add Applicant",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // NAME
              _input(
                controller: nameController,
                hint: "Name",
                icon: Icons.person,
              ),

              const SizedBox(height: 15),

              // PHONE
              _input(
                controller: phoneController,
                hint: "Phone",
                icon: Icons.phone,
                type: TextInputType.number,
              ),

              const SizedBox(height: 15),

              // EMAIL
              _input(
                controller: emailController,
                hint: "Email",
                icon: Icons.email,
              ),

              const SizedBox(height: 15),

              // DOMAIN
              DropdownButtonFormField<String>(
                value: domain,
                dropdownColor: const Color(0xFF161B22),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.work, color: Colors.blue),
                  filled: true,
                  fillColor: const Color(0xFF0D1117),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  "Acting",
                  "Writing",
                  "Direction",
                  "Music",
                  "Cinematography",
                  "Editor"
                ].map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  domain = value!;
                },
              ),

              const SizedBox(height: 25),

              // BUTTON
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1F6FEB),
                      Color(0xFF00C6FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton.icon(
                  onPressed: save,
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 REUSABLE INPUT
  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF0D1117),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}