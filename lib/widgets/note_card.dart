import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/pages/new_or_edit_note_page.dart';
import '../core/constants.dart';
import '../core/dialogs.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.isInGrid,
    required this.note,
    required this.isDateCreated,
  });

  final Note note;
  final bool isInGrid;
  final bool isDateCreated;

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://note-app-70fe2-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("Note_App/${user!.uid}/notes");
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewOrEditNotePage(
                      isNewNote: false,
                      id: note.id,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: primary, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: primary.withOpacity(0.5), offset: Offset(4, 4)),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: gray900),
            ),
            SizedBox(
              height: 4,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    note.tags.toString().split(", ").length,
                    (index) => Container(
                          child: Text(
                            (note.tags != null && note.tags!.isNotEmpty)
                                ? note.tags.toString()
                                : "No tags added",
                            style: TextStyle(fontSize: 12, color: gray700),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: gray100),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          margin: EdgeInsets.only(right: 4),
                        )),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            if (isInGrid)
              Expanded(
                  child: Text(
                note.content.toString(),
                style: TextStyle(color: gray700),
              ))
            else
              Text(
                note.content.toString(),
                style: TextStyle(color: gray700),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            Row(
              children: [
                Text(
                  (isDateCreated)
                      ? note.dateCreated.toString()
                      : note.lastModified.toString(),
                  style: TextStyle(
                      fontSize: 9, fontWeight: FontWeight.w600, color: gray500),
                ),
                Spacer(),
                GestureDetector(
                  child: FaIcon(
                    FontAwesomeIcons.trash,
                    color: gray500,
                    size: 16,
                  ),
                  onLongPress: () async {
                    final bool shouldDelete = await showConfirmationDialog(
                            context: context,
                            title: "Bạn có muốn xoá ghi chú không?") ??
                        false;
                    if (shouldDelete) {
                      databaseReference.child(note.id).remove();
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
