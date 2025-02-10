import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/change_notifiers/notes_provider.dart';
import 'package:note_app/core/dialogs.dart';
import 'package:note_app/pages/new_or_edit_note_page.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';
import '../models/note.dart';
import '../widgets/no_notes.dart';
import '../widgets/note_fab.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../widgets/note_grid.dart';
import '../widgets/note_icon_button.dart';
import '../widgets/note_list.dart';
import '../widgets/search_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/sevices/auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> dropdownOptions = ["Data modified", "Date created"];
  late String dropdownValue = dropdownOptions.first;
  bool isDescending = true;
  bool isGrid = true;

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Chuyển hướng về trang login
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://note-app-70fe2-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("Note_App");
    return Scaffold(
      appBar: AppBar(
        title: Text("Note App"),
        actions: [
          NoteIconButtonOutlined(
            icon: FontAwesomeIcons.rightFromBracket,
            onPressed: () async {
              final bool shouldSignout = await showConfirmationDialog(
                      context: context,
                      title: "Ban co muon dang xuat khong?") ??
                  false;
              if (shouldSignout) _signOut(context);
            },
          )
        ],
      ),
      floatingActionButton: NoteFab(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewOrEditNotePage(isNewNote: true)));
      }),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SearchField(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      NoteIconButton(
                        icon: isDescending
                            ? FontAwesomeIcons.arrowDown
                            : FontAwesomeIcons.arrowUp,
                        onPressed: () {
                          setState(() {
                            isDescending = !isDescending;
                          });
                        },
                        size: 18,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      DropdownButton<String>(
                          value: dropdownValue,
                          icon: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: FaIcon(
                              FontAwesomeIcons.arrowDownWideShort,
                              size: 18,
                              color: gray700,
                            ),
                          ),
                          underline: SizedBox.shrink(),
                          isDense: true,
                          borderRadius: BorderRadius.circular(16),
                          items: dropdownOptions
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Text(e),
                                        if (e == dropdownValue) ...[
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(Icons.check),
                                        ]
                                      ],
                                    ),
                                  ))
                              .toList(),
                          selectedItemBuilder: (context) =>
                              dropdownOptions.map((e) => Text(e)).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          }),
                      Spacer(),
                      NoteIconButton(
                        icon: isGrid
                            ? FontAwesomeIcons.table
                            : FontAwesomeIcons.bars,
                        onPressed: () {
                          setState(() {
                            isGrid = !isGrid;
                          });
                        },
                        size: 18,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isGrid ? Note_Grid() : NotesList(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
