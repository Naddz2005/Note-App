import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/widgets/no_notes.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';

class NotesList extends StatelessWidget {
  final bool isDateCreated;
  final bool isDescending;
  final String searchQuery; // Nhận từ khóa tìm kiếm

  const NotesList(
      {super.key, required this.isDateCreated, required this.isDescending, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User is not logged in");
    }

    late var databaseReference = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://note-app-70fe2-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("Note_App/${user.uid}/notes");

    return StreamBuilder(
      stream: databaseReference.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return NoNotes();
        }

        var rawData = snapshot.data!.snapshot.value;

        // Kiểm tra nếu dữ liệu không phải là Map thì trả về NoNotes()
        if (rawData is! Map<dynamic, dynamic>) {
          return NoNotes();
        }

        Map<dynamic, dynamic> data = rawData;
        List<Note> notes = [];

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            notes.add(Note(
              id: key,
              title: value['title'] ?? 'Không có tiêu đề',
              content: value['content'] ?? '',
              dateCreated: value['date_created'] ?? '',
              lastModified: value['last_modified'] ?? '',
              tags: value['tags'] ?? '',
            ));
          }
        });

        // Lọc theo từ khóa tìm kiếm
        notes = notes
            .where((note) =>
            note.title!.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        // Chuyển đổi string sang datetime( chuyển đô thủ công do DateTime không hỗ trợ định dạng "dd MMM yyy, hh:mm a")
        DateTime parseDate(String dateString) {
          return DateFormat("dd MMM yyyy, hh:mm a").parse(dateString);
        }

        // Sắp xếp
        notes.sort((a, b) {
          DateTime dateA = parseDate(isDateCreated ? a.dateCreated : a.lastModified);
          DateTime dateB = parseDate(isDateCreated ? b.dateCreated : b.lastModified);

          return isDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
        });

        return ListView.separated(
          clipBehavior: Clip.none,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteCard(
              isDateCreated: isDateCreated,
              note: notes[index],
              isInGrid: false,
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 8),
        );
      },
    );
  }
}
