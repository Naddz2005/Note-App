import 'package:flutter/material.dart';

import 'note_card.dart';

class Note_Grid extends StatelessWidget {
  const Note_Grid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 15,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
        itemBuilder: (context, int index) {
          return NoteCard(
            isInGrid: true,
          );
        });
  }
}

