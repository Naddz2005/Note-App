import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:note_app/change_notifiers/notes_provider.dart';
import 'package:note_app/change_notifiers/settings_provider.dart';

import 'package:note_app/core/constants.dart';
import 'package:note_app/core/dialogs.dart';

import 'package:note_app/pages/new_or_edit_note_page.dart';
import 'package:note_app/pages/profile_screen.dart';

import 'package:note_app/widgets/note_fab.dart';
import 'package:note_app/widgets/note_grid.dart';
import 'package:note_app/widgets/note_icon_button.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';
import 'package:note_app/widgets/note_list.dart';
import 'package:note_app/widgets/search_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> dropdownOptions = [
    "Date modified",
    "Date created"
  ];

  late String dropdownValue = dropdownOptions.first;

  bool isDescending = true;
  bool isDateCreated = false;

  final TextEditingController searchController =
  TextEditingController();

  String searchQuery = "";

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final settingsProvider =
    Provider.of<SettingsProvider>(context);

    return Scaffold(

      appBar: AppBar(

        title: const Text("Note App"),

        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 8),

            child: Row(
              children: [

                // PROFILE BUTTON
                GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                        const ProfileScreen(),
                      ),
                    );
                  },

                  child: Container(

                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      color: primary,

                      borderRadius:
                      BorderRadius.circular(14),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(3, 3),
                          blurRadius: 4,
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.person,
                      color: white,
                      size: 22,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // LOGOUT BUTTON
                NoteIconButtonOutlined(

                  icon:
                  FontAwesomeIcons.rightFromBracket,

                  onPressed: () async {

                    final bool shouldSignout =
                        await showConfirmationDialog(
                          context: context,
                          title:
                          "Bạn có muốn đăng xuất không?",
                        ) ??
                            false;

                    if (shouldSignout) {
                      _signOut(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: NoteFab(

        onPressed: () {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
              const NewOrEditNotePage(
                isNewNote: true,
              ),
            ),
          );
        },
      ),

      body: Consumer<NotesProvider>(

        builder:
            (context, notesProvider, child) {

          return Padding(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: Column(
              children: [

                SearchField(

                  onSearch: (query) {

                    setState(() {

                      searchQuery =
                          query.toLowerCase();
                    });
                  },
                ),

                Padding(

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),

                  child: Row(
                    children: [

                      // SORT BUTTON
                      NoteIconButton(

                        icon: isDescending
                            ? FontAwesomeIcons.arrowDown
                            : FontAwesomeIcons.arrowUp,

                        onPressed: () {

                          setState(() {

                            isDescending =
                            !isDescending;
                          });
                        },

                        size: 18,
                      ),

                      const SizedBox(width: 16),

                      // DROPDOWN
                      DropdownButton<String>(

                        value: dropdownValue,

                        icon: Padding(
                          padding:
                          const EdgeInsets.only(
                            left: 16,
                          ),

                          child: FaIcon(
                            FontAwesomeIcons
                                .arrowDownWideShort,

                            size: 18,
                            color: gray700,
                          ),
                        ),

                        underline:
                        const SizedBox.shrink(),

                        isDense: true,

                        borderRadius:
                        BorderRadius.circular(16),

                        items: dropdownOptions
                            .map(
                              (e) => DropdownMenuItem(

                            value: e,

                            child: Row(
                              children: [

                                Text(e),

                                if (e ==
                                    dropdownValue) ...[
                                  const SizedBox(
                                      width: 8),

                                  const Icon(
                                      Icons.check),
                                ]
                              ],
                            ),
                          ),
                        )
                            .toList(),

                        selectedItemBuilder:
                            (context) =>
                            dropdownOptions
                                .map((e) => Text(e))
                                .toList(),

                        onChanged: (newValue) {

                          setState(() {

                            dropdownValue =
                            newValue!;

                            isDateCreated =
                            !isDateCreated;
                          });
                        },
                      ),

                      const Spacer(),

                      // GRID / LIST BUTTON
                      NoteIconButton(

                        icon:
                        settingsProvider.isGridView
                            ? FontAwesomeIcons.table
                            : FontAwesomeIcons.bars,

                        onPressed: () {

                          settingsProvider
                              .toggleGridView(
                            !settingsProvider
                                .isGridView,
                          );
                        },

                        size: 18,
                      ),
                    ],
                  ),
                ),

                Expanded(

                  child:
                  settingsProvider.isGridView

                      ? NoteGrid(

                    isDateCreated:
                    isDateCreated,

                    isDescending:
                    isDescending,

                    searchQuery:
                    searchQuery,
                  )

                      : NotesList(

                    isDateCreated:
                    isDateCreated,

                    isDescending:
                    isDescending,

                    searchQuery:
                    searchQuery,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}