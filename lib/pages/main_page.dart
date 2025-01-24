import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/note_fab.dart';

import '../core/constants.dart';
import '../widgets/note_grid.dart';
import '../widgets/note_list.dart';
import '../widgets/search_field.dart';
import'package:firebase_auth/firebase_auth.dart';
import'package:note_app/auth.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Note App"),
    actions: [
    IconButton(
    onPressed: () => _signOut(context),
    icon: FaIcon(FontAwesomeIcons.rightFromBracket),
    style: IconButton.styleFrom(
    foregroundColor: white,
    backgroundColor: primary,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: black),
    ),
    ),
    )
    ],),

    floatingActionButton: NoteFab(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SearchField(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isDescending = !isDescending;
                      });
                    },
                    icon: FaIcon(isDescending
                        ? FontAwesomeIcons.arrowDown
                        : FontAwesomeIcons.arrowUp),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints: BoxConstraints(),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    iconSize: 18,
                    color: gray700,
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
                          .map((e) =>
                          DropdownMenuItem(
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
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isGrid = !isGrid;
                      });
                    },
                    icon: FaIcon(isGrid
                        ? FontAwesomeIcons.table
                        : FontAwesomeIcons.bars),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints: BoxConstraints(),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    iconSize: 18,
                    color: gray700,
                  )
                ],
              ),
            ),
            Expanded(
              child: isGrid ? Note_Grid() : NotesList(),
            )
          ],
        ),
      ),
    );
  }
}
