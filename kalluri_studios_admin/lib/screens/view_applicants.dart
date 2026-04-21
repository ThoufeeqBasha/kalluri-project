import 'package:flutter/material.dart';
import '../models/applicant.dart';
import '../services/api_service.dart';

class ViewApplicantsScreen extends StatefulWidget {
  const ViewApplicantsScreen({super.key});

  @override
  State<ViewApplicantsScreen> createState() =>
      _ViewApplicantsScreenState();
}

class _ViewApplicantsScreenState
    extends State<ViewApplicantsScreen> {

  String search = "";
  String selectedDomain = "All";
  String selectedStatus = "All"; // 🔥 NEW

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),

      appBar: AppBar(
        title: const Text("Applicants"),
        backgroundColor: const Color(0xFF161B22),
      ),

      body: FutureBuilder<List<Applicant>>(
        future: ApiService.getApplicants(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          final all = snapshot.data!;

          // 🔥 FILTER LOGIC
          final applicants = all.where((a) {

            final matchesSearch =
                a.name.toLowerCase().contains(search) ||
                a.phone.contains(search) ||
                a.email.toLowerCase().contains(search);

            final matchesDomain =
                selectedDomain == "All" ||
                a.domain == selectedDomain;

            final matchesStatus =
                selectedStatus == "All" ||
                a.status == selectedStatus;

            return matchesSearch &&
                matchesDomain &&
                matchesStatus;

          }).toList();

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [

                // 🔍 SEARCH
                TextField(
                  onChanged: (value) {
                    setState(() {
                      search = value.toLowerCase();
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search name / phone / email",
                    hintStyle:
                        const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.blue),
                    filled: true,
                    fillColor: const Color(0xFF161B22),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🎯 DOMAIN FILTER
                DropdownButtonFormField<String>(
                  value: selectedDomain,
                  dropdownColor:
                      const Color(0xFF161B22),
                  style: const TextStyle(color: Colors.white),
                  items: [
                    "All",
                    "Acting",
                    "Writing",
                    "Direction",
                    "Music",
                    "Cinematography",
                    "Editor"
                  ].map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(d),
                      )).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDomain = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // 🔥 STATUS FILTER
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  dropdownColor:
                      const Color(0xFF161B22),
                  style: const TextStyle(color: Colors.white),
                  items: [
                    "All",
                    "pending",
                    "approved",
                    "rejected"
                  ].map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.toUpperCase()),
                      )).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // 📋 LIST
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: applicants.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 150),
                              Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.people_outline,
                                        color: Colors.grey,
                                        size: 60),
                                    SizedBox(height: 10),
                                    Text(
                                      "No Applicants Found",
                                      style: TextStyle(
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Try changing filters",
                                      style: TextStyle(
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: applicants.length,
                            itemBuilder: (_, index) {
                              final a = applicants[index];

                              return Container(
                                margin:
                                    const EdgeInsets.only(
                                        bottom: 15),
                                padding:
                                    const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF161B22),
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue
                                          .withOpacity(0.15),
                                      blurRadius: 15,
                                    )
                                  ],
                                ),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [

                                    // NAME + STATUS + ACTIONS
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [

                                            Text(
                                              a.name,
                                              style:
                                                  const TextStyle(
                                                color:
                                                    Colors.white,
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),

                                            const SizedBox(height: 5),

                                            // STATUS BADGE
                                            Container(
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                          horizontal:
                                                              10,
                                                          vertical:
                                                              4),
                                              decoration:
                                                  BoxDecoration(
                                                color: a.status ==
                                                        "approved"
                                                    ? Colors.green
                                                    : a.status ==
                                                            "rejected"
                                                        ? Colors.red
                                                        : Colors.orange,
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                            8),
                                              ),
                                              child: Text(
                                                a.status
                                                    .toUpperCase(),
                                                style:
                                                    const TextStyle(
                                                  color:
                                                      Colors.white,
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [

                                            IconButton(
                                              icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () =>
                                                  editPopup(a),
                                            ),

                                            IconButton(
                                              icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () =>
                                                  deleteConfirm(
                                                      a.id),
                                            ),

                                            if (a.status !=
                                                "approved")
                                              IconButton(
                                                icon: const Icon(
                                                    Icons
                                                        .check_circle,
                                                    color:
                                                        Colors.green),
                                                onPressed: () async {
                                                  await ApiService
                                                      .updateStatus(
                                                          a.id,
                                                          "approved");
                                                  refresh();
                                                },
                                              ),

                                            if (a.status !=
                                                "rejected")
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.cancel,
                                                    color: Colors.red),
                                                onPressed: () async {
                                                  await ApiService
                                                      .updateStatus(
                                                          a.id,
                                                          "rejected");
                                                  refresh();
                                                },
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Text("📞 ${a.phone}",
                                        style: const TextStyle(
                                            color: Colors.grey)),

                                    Text("📧 ${a.email}",
                                        style: const TextStyle(
                                            color: Colors.grey)),

                                    const SizedBox(height: 5),

                                    Text(
                                      a.domain,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // DELETE
  void deleteConfirm(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Delete?",
            style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure?",
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text("Yes",
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.deleteApplicant(id);
      refresh();
    }
  }

  // EDIT POPUP
  void editPopup(Applicant a) {

    final nameController =
        TextEditingController(text: a.name);
    final phoneController =
        TextEditingController(text: a.phone);
    final emailController =
        TextEditingController(text: a.email);

    String domain = a.domain;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Edit Applicant",
            style: TextStyle(color: Colors.white)),

        content: SingleChildScrollView(
          child: Column(
            children: [

              _input(nameController, "Name", Icons.person),
              const SizedBox(height: 10),

              _input(phoneController, "Phone", Icons.phone),
              const SizedBox(height: 10),

              _input(emailController, "Email", Icons.email),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: domain,
                dropdownColor:
                    const Color(0xFF161B22),
                style:
                    const TextStyle(color: Colors.white),
                items: [
                  "Acting",
                  "Writing",
                  "Direction",
                  "Music",
                  "Cinematography",
                  "Editor"
                ].map((d) => DropdownMenuItem(
                      value: d,
                      child: Text(d),
                    )).toList(),
                onChanged: (value) {
                  domain = value!;
                },
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.updateApplicant(
                Applicant(
                  id: a.id,
                  name: nameController.text,
                  phone: phoneController.text,
                  email: emailController.text,
                  domain: domain,
                  status: a.status,
                ),
              );

              Navigator.pop(context);
              refresh();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController controller,
      String hint, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF0D1117),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}       