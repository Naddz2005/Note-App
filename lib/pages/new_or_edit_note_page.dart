import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';

class NewOrEditNotePage extends StatefulWidget {
  const NewOrEditNotePage({super.key});

  @override
  State<NewOrEditNotePage> createState() => _NewOrEditNotePageState();
}

class _NewOrEditNotePageState extends State<NewOrEditNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NoteIconButtonOutlined(
          icon: FontAwesomeIcons.chevronLeft,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("New Note"),
        actions: [
          NoteIconButtonOutlined(
            icon: FontAwesomeIcons.pen,
            onPressed: () {},
          ),
          NoteIconButtonOutlined(
            icon: FontAwesomeIcons.check,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
