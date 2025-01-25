import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/widgets/note_icon_button.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';

class NewOrEditNotePage extends StatefulWidget {
  const NewOrEditNotePage({super.key, required this.isNewNote});

  final bool isNewNote;

  @override
  State<NewOrEditNotePage> createState() => _NewOrEditNotePageState();
}

class _NewOrEditNotePageState extends State<NewOrEditNotePage> {
  late final FocusNode focusNode;
  late bool readOnly;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNode = FocusNode();

    if (widget.isNewNote) {
      focusNode.requestFocus();
      readOnly = false;
    } else {
      readOnly = true;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NoteIconButtonOutlined(
            icon: FontAwesomeIcons.chevronLeft,
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ),
        title: Text(widget.isNewNote ? "New Note" : "Edit Note"),
        actions: [
          NoteIconButtonOutlined(
            icon: readOnly ? FontAwesomeIcons.pen : FontAwesomeIcons.bookOpen,
            onPressed: () {
              setState(() {
                readOnly = !readOnly;
                if (readOnly) {
                  FocusScope.of(context).unfocus();
                } else {
                  focusNode.requestFocus();
                }
              });
            },
          ),
          NoteIconButtonOutlined(
            icon: FontAwesomeIcons.check,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                hintText: "Title here",
                hintStyle: TextStyle(color: gray300),
                border: InputBorder.none),
          ),
          if (widget.isNewNote) ...[
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      "Last Modified",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: gray500),
                    )),
                Expanded(
                  flex: 5,
                  child: Text(
                    "24 Jan 2025, 06:35 PM",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: gray900),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      "Created",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: gray500),
                    )),
                Expanded(
                    flex: 5,
                    child: Text(
                      "24 Jan 2025, 06:35 PM",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: gray900),
                    )),
              ],
            ),
          ],
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(
                      "Tags",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: gray500),
                    ),
                    NoteIconButton(
                      icon: FontAwesomeIcons.circlePlus,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Text(
                    "No tags added",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: gray900
                    ),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: gray700,
              thickness: 2,
            ),
          ),
          TextField(
            style: TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                hintText: "Note here...",
                hintStyle: TextStyle(color: gray300),
                border: InputBorder.none),
            focusNode: focusNode,
            readOnly: readOnly,
          )
        ],
      ),
    );
  }
}
