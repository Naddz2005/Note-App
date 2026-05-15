import 'package:flutter/material.dart';

import '../core/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool gridView = true;
  bool notification = true;

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
          'Settings',
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
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),

            const SizedBox(height: 16),

            _buildSwitchTile(
              icon: Icons.grid_view,
              title: 'Grid View',
              value: gridView,
              onChanged: (value) {
                setState(() {
                  gridView = value;
                });
              },
            ),

            const SizedBox(height: 16),

            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Notifications',
              value: notification,
              onChanged: (value) {
                setState(() {
                  notification = value;
                });
              },
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primary,
                  width: 2,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info,
                    color: primary,
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      'Note App v1.0\nMade with Flutter ❤️',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primary,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Switch(
            activeColor: primary,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}