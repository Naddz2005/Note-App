import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/widgets/note_icon_button.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';

class NewOrEditNotePage extends StatefulWidget {
  const NewOrEditNotePage({super.key, required this.isNewNote, this.id});

  final bool isNewNote;
  final String? id;
  @override
  State<NewOrEditNotePage> createState() => _NewOrEditNotePageState();
}

class _NewOrEditNotePageState extends State<NewOrEditNotePage> {
  late final FocusNode focusNode;
  late bool readOnly;
  final databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://note-app-70fe2-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("Note_App"); // Truy cập database
  late String now;
  String? date_Created; //Ngay tao
  final List<String> tags = [];
  // Tạo các controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    focusNode = FocusNode();
    now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    if (widget.isNewNote) {
      focusNode.requestFocus();
      readOnly = false;
      date_Created = now;
    } else {
      readOnly = true;
      _loadNoteData(); // Nếu là sửa, load dữ liệu từ Firebase
    }
  }
  // Hàm tải dữ liệu từ Firebase nếu đang chỉnh sửa ghi chú
  void _loadNoteData() async {
    if (widget.id == null) return;

    DatabaseEvent event = await databaseReference.child(widget.id!).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<String, dynamic> noteData = Map<String, dynamic>.from(
          snapshot.value as Map);
      setState(() {
        titleController.text = noteData["title"] ?? "";
        contentController.text = noteData["content"] ?? "";
        date_Created = noteData["date_created"] ?? now; // Giữ nguyên ngày tạo
      });
    }
  }
  // Hàm lưu hoặc cập nhật ghi chú vào Firebase
  void _saveNote() async {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return; // Không lưu nếu rỗng

    Map<String, dynamic> noteData = {
      "title": title,
      "content": content,
      "last_modified": now,
      "date_created": date_Created, // Không thay đổi ngày tạo
      "tags": tags,
    };

    if (widget.isNewNote) {
      // Thêm mới
      DatabaseReference newNoteRef = databaseReference.push();
      await newNoteRef.set(noteData);
    } else {
      // Cập nhật
      if (widget.id != null) {
        await databaseReference.child(widget.id!).update(noteData);
      }
    }

    Navigator.pop(context); // Quay về màn hình trước
  }
  @override
  void dispose() {
    // TODO: implement dispose
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
          NoteIconButtonOutlined( // Nút chấp nhận save
            icon: FontAwesomeIcons.check,
            onPressed: () {
              _saveNote();
            },
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
                border: InputBorder.none),
            canRequestFocus: !readOnly,
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
                    now,
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
                      date_Created ?? now,
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
                      onPressed: () {

                      },
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Text(
                    tags.isEmpty ? "No tags added" : tags.join(", ") ,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: gray900),
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
            controller: contentController,
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
