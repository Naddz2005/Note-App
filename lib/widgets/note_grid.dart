import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import 'note_card.dart';

class Note_Grid extends StatelessWidget {
  const Note_Grid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://note-app-70fe2-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("Note_App");
    return StreamBuilder(
      stream: databaseReference.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return Center(child: Text("Không có ghi chú nào"));
        }

        // Lấy dữ liệu từ Firebase
        Map<dynamic, dynamic> data =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        List<Note> notes = data.entries.map((entry) {
          final noteData = Map<String, dynamic>.from(entry.value);
          return Note(
            id: entry.key,
            title: noteData['title'] ?? 'Không có tiêu đề',
            content: noteData['content'] ?? 'Không có nội dung',
            dateCreated: noteData['date_created'] ?? 'Không có dữ liệu',
            lastModified: noteData['last_modified'] ?? 'Không có dữ liệu',
            tags: noteData['tags'] ?? 'Không có dữ liệu',
          );
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: notes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Mỗi hàng 2 thẻ
              crossAxisSpacing: 8, // Khoảng cách ngang giữa các thẻ
              mainAxisSpacing: 8, // Khoảng cách dọc giữa các thẻ
              childAspectRatio: 3 / 4, // Tỉ lệ chiều rộng và chiều cao
            ),
            itemBuilder: (context, index) {
              return NoteCard(
                note: notes[index],
                isInGrid: true,
              );
            },
          ),
        );
      },
    );
  }
}
