import 'package:flutter/material.dart';
import '../models/applicant.dart';
import '../services/api_service.dart';
import 'add_applicant.dart';
import 'view_applicants.dart';
import 'login.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),

      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Dashboard"),
      ),

      // 🔥 SIDEBAR
      drawer: Drawer(
        backgroundColor: const Color(0xFF161B22),
        child: ListView(
          children: [

            const DrawerHeader(
              child: Text(
                "Kalluri Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),

            _menu(Icons.dashboard, "Dashboard", () {
              Navigator.pop(context);
            }),

            _menu(Icons.person_add, "Add Applicant", () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddApplicantScreen(),
                ),
              );
              if (result == true) setState(() {});
            }),

            _menu(Icons.people, "View Applicants", () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ViewApplicantsScreen(),
                ),
              );
              if (result == true) setState(() {});
            }),

            const Divider(color: Colors.grey),

            _menu(Icons.logout, "Logout", () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            }),
          ],
        ),
      ),

      // 🔥 BODY
      body: FutureBuilder<List<Applicant>>(
        future: ApiService.getApplicants(),
        builder: (context, snapshot) {

          // 🔄 LOADING
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          final data = snapshot.data!;
          int total = data.length;

          Map<String, int> domain = {};
          for (var a in data) {
            domain[a.domain] = (domain[a.domain] ?? 0) + 1;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // 👋 TITLE
                const Text(
                  "Welcome Kalluri Admin 👋",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // 📊 TOTAL CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.15),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      const Icon(
                        Icons.people,
                        color: Colors.blue,
                        size: 40,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "$total",
                        style: const TextStyle(
                          fontSize: 38,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Total Applicants",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // 🔥 QUICK ACTION BUTTONS
                Row(
                  children: [

                    // ➕ ADD
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1F6FEB),
                              Color(0xFF00C6FF)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AddApplicantScreen(),
                              ),
                            );
                            if (result == true)
                              setState(() {});
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text("Add"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent,
                            shadowColor:
                                Colors.transparent,
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    // 📋 VIEW
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF161B22),
                          borderRadius:
                              BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.blue),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ViewApplicantsScreen(),
                              ),
                            );
                            if (result == true)
                              setState(() {});
                          },
                          icon: const Icon(Icons.people),
                          label: const Text("View"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent,
                            shadowColor:
                                Colors.transparent,
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // 📊 DOMAIN TITLE
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Applicants by Domain",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 📊 BARS
                ...domain.entries.map((e) {

                  double percent =
                      total == 0 ? 0 : e.value / total;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          "${e.key} (${e.value})",
                          style: const TextStyle(
                              color: Colors.white),
                        ),

                        const SizedBox(height: 5),

                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius:
                                BorderRadius.circular(5),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: percent,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF1F6FEB),
                                    Color(0xFF00C6FF),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _menu(
      IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text,
          style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}