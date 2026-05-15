import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import 'setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final User? user = FirebaseAuth.instance.currentUser;

  final databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    "https://note-app-70fe2-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("Note_App");

  String username = "";
  String email = "";
  String registerDate = "";
  int totalNotes = 0;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {

    DatabaseEvent event =
    await databaseReference.child(user!.uid).once();

    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {

      Map data =
      snapshot.value as Map;

      Map notes =
          data["notes"] ?? {};

      setState(() {

        username = data["user_name"] ?? "Unknown";

        email = data["email"] ?? "No Email";

        registerDate =
            data["register_date"] ?? "";

        totalNotes = notes.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: black),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Container(
              width: 120,
              height: 120,

              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(60),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(4, 4),
                    blurRadius: 8,
                  ),
                ],
              ),

              child: Center(
                child: Text(
                  username.isNotEmpty
                      ? username[0].toUpperCase()
                      : "?",

                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              username,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: gray700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Joined: $registerDate",
              style: const TextStyle(
                color: gray500,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: primary,
                  width: 2,
                ),
              ),

              child: Column(
                children: [

                  const Text(
                    "Total Notes",
                    style: TextStyle(
                      fontSize: 18,
                      color: gray700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    totalNotes.toString(),

                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            buildButton(
              icon: Icons.settings,
              title: "Settings",

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {

    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color:
            isLogout
                ? Colors.red
                : primary,

            width: 2,
          ),
        ),

        child: Row(
          children: [

            Icon(
              icon,
              color:
              isLogout
                  ? Colors.red
                  : primary,
            ),

            const SizedBox(width: 15),

            Text(
              title,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,

                color:
                isLogout
                    ? Colors.red
                    : black,
              ),
            ),

            const Spacer(),

            const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ],
        ),
      ),
    );
  }
}