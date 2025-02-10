import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key});

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
            content: noteData['content'] ?? '',
            dateCreated: noteData['date_created'] ?? '',
            lastModified: noteData['last_modified'] ?? '',
            tags: noteData['tags'] ?? '',
          );
        }).toList();

        return ListView.separated(
          clipBehavior: Clip.none,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteCard(
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
