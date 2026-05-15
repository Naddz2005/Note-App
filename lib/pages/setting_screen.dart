import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../change_notifiers/settings_provider.dart';
import '../core/constants.dart';

class SettingsScreen extends StatelessWidget {

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final settingsProvider =
    Provider.of<SettingsProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            buildSwitchTile(
              title: "Dark Mode",
              subtitle: "Enable dark theme",

              value:
              settingsProvider.isDarkMode,

              onChanged: (value) {

                settingsProvider
                    .toggleDarkMode(value);
              },

              icon: Icons.dark_mode,
            ),

            const SizedBox(height: 20),

            buildSwitchTile(
              title: "Grid View",
              subtitle: "Display notes in grid",

              value:
              settingsProvider.isGridView,

              onChanged: (value) {

                settingsProvider
                    .toggleGridView(value);
              },

              icon: Icons.grid_view,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: white,

        borderRadius:
        BorderRadius.circular(20),

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
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  subtitle,

                  style: const TextStyle(
                    color: gray700,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeColor: primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}