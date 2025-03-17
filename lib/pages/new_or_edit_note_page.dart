import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/core/tags.dart';
import 'package:note_app/widgets/note_icon_button.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';
import '../core/dialogs.dart';
import '../widgets/display_tags.dart';

class NewOrEditNotePage extends StatefulWidget {
  const NewOrEditNotePage({
    super.key,
    required this.isNewNote,
    this.id,
  });

  final bool isNewNote;
  final String? id;

  @override
  State<NewOrEditNotePage> createState() => _NewOrEditNotePageState();
}

class _NewOrEditNotePageState extends State<NewOrEditNotePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late final FocusNode focusNode;
  late bool readOnly;

  // Chỉ trỏ đến "notes"
  final databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    "https://note-app-70fe2-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("Note_App");

  late String now;
  String? dateCreated;
  List<String>? lsTags;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    if (widget.isNewNote) {
      focusNode.requestFocus();
      readOnly = false;
      dateCreated = now;
    } else {
      readOnly = true;
      _loadNoteData();
    }
  }

  // Tải dữ liệu từ Firebase
  void _loadNoteData() async {
    DatabaseEvent event = await databaseReference
        .child("${user!.uid}/notes/${widget.id}")
        .once();  //sự kiện chứa dữ liệu từ Firebase khi có thay đổi trong cơ sở dữ liệu
    DataSnapshot snapshot = event.snapshot; //đối tượng chứa dữ liệu lấy được từ cơ sở dữ liệu.

    if (snapshot.value != null) {
      Map<String, dynamic> noteData =
      Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        titleController.text = noteData["title"] ?? "";
        contentController.text = noteData["content"] ?? "";
        dateCreated = noteData["date_created"] ?? now;
        lsTags = noteData["tags"] != null
            ? (noteData["tags"] as String).split(", ")
            : [];
      });
    }
  }

  // Lưu hoặc cập nhật ghi chú
  void _saveNote() async {
    String title = titleController.text.trim();
    String content = contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    Map<String, dynamic> noteData = {
      "title": title,
      "content": content,
      "last_modified": now,
      "date_created": dateCreated,
      "tags": (lsTags == null || lsTags!.isEmpty) ? null : lsTags!.join(", "),
    };

    if (widget.isNewNote) {
      DatabaseReference newNoteRef =
      databaseReference.child("${user!.uid}/notes").push();
      await newNoteRef.set(noteData);
    } else {
      await databaseReference
          .child("${user!.uid}/notes/${widget.id}")
          .update(noteData);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    focusNode.dispose();
    titleController.dispose();
    contentController.dispose();
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
            onPressed: () => Navigator.maybePop(context),
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
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: "Title here",
              hintStyle: TextStyle(color: gray300),
              border: InputBorder.none,
            ),
            canRequestFocus: !readOnly,
          ),
          if (widget.isNewNote) ...[
            _buildRow("Last Modified", now),
            _buildRow("Created", dateCreated ?? now),
          ],
          _buildTagsSection(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(color: gray700, thickness: 2),
          ),
          TextField(
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            controller: contentController,
            style: TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: "Note here...",
              hintStyle: TextStyle(color: gray300),
              border: InputBorder.none,
            ),
            focusNode: focusNode,
            readOnly: readOnly,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(label,
              style: TextStyle(fontWeight: FontWeight.bold, color: gray500)),
        ),
        Expanded(
          flex: 5,
          child: Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, color: gray900)),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Text("Tags",
                  style: TextStyle(fontWeight: FontWeight.bold, color: gray500)),
              SizedBox(width: 5),
              NoteIconButton(
                icon: FontAwesomeIcons.circlePlus,
                onPressed: () async {
                  final String? tagAdd =
                  await showNewTagDialog(context: context);
                  setState(() {
                    if (tagAdd != null && tagAdd.trim().isNotEmpty) {
                      lsTags ??= [];
                      lsTags!.add(tagAdd);
                    }
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: (lsTags == null || lsTags!.isEmpty)
              ? Text("No tags added",
              style: TextStyle(fontWeight: FontWeight.bold, color: gray900))
              : DisplayTag(ls_tags: lsTags!),
        ),
      ],
    );
  }
}
