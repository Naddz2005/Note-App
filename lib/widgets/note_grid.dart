import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/widgets/no_notes.dart';

import '../models/note.dart';
import 'note_card.dart';

class NoteGrid extends StatelessWidget {
  final bool isDateCreated; // Hiển thị ngày tạo hay ngày sửa
  final bool isDescending; // Tăng dần hay giảm dần
  final String searchQuery; // Nhận từ khóa tìm kiếm

  const NoteGrid({
    super.key,
    required this.isDateCreated,
    required this.isDescending, required this.searchQuery,
  });

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

        if (rawData is! Map<dynamic, dynamic>) {
          return NoNotes();
        }

        Map<dynamic, dynamic> data = rawData;
        List<Note> notes = data.entries.map((entry) {
          final noteData = entry.value;

          if (noteData is! Map<dynamic, dynamic>) {
            return Note(
              id: entry.key,
              title: 'Lỗi dữ liệu',
              content: '',
              dateCreated: '',
              lastModified: '',
              tags: '',
            );
          }

          return Note(
            id: entry.key,
            title: noteData['title'] ?? 'Không có tiêu đề',
            content: noteData['content'] ?? 'Không có nội dung',
            dateCreated: noteData['date_created'] ?? 'Không có dữ liệu',
            lastModified: noteData['last_modified'] ?? 'Không có dữ liệu',
            tags: noteData['tags'] ?? 'Không có dữ liệu',
          );
        }).toList();

        // Lọc theo từ khóa tìm kiếm
        notes = notes
            .where((note) =>
            note.title!.toLowerCase().contains(searchQuery))
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

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: notes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              return NoteCard(
                note: notes[index],
                isInGrid: true,
                isDateCreated: isDateCreated,
              );
            },
          ),
        );
      },
    );
  }
}
