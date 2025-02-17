import 'package:flutter/material.dart';

import 'dialog_card.dart';
import 'note_button.dart';
import 'note_form_field.dart';

class NewTagDialog extends StatefulWidget {
  const NewTagDialog({
    super.key,
    this.tag,
  });
  final String? tag;

  @override
  State<NewTagDialog> createState() => _NewTagDialogState();
}

class _NewTagDialogState extends State<NewTagDialog> {
  late final TextEditingController tagController;

  @override
  void initState() {
    super.initState();

    tagController = TextEditingController(text: widget.tag);

  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min, //Kích thước vừa với nội dung bên trong
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add tag',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 24),
          NoteFormField(
            controller: tagController, // Điều khiển băn bản nhập vào
            hintText: 'Add tag (< 16 characters)', //Gợi ý nhập liệu
            validator: (value) { // Hàm kiểm tra giá trị nhập vào
              if (value!.trim().isEmpty) {
                return 'No tags added';
              } else if (value.trim().length > 16) {
                return 'Tags should not be more than 16 characters';
              }
              return null;
            },
            autofocus: true, // Tự động focus khi mở form
          ),
          const SizedBox(height: 24),
          NoteButton(
            child: const Text('Add'),
            onPressed: () {
              if (tagController.toString().isEmpty || tagController.toString().trim() == "")
                  Navigator.pop(context, null);
              else
                Navigator.pop(context, tagController.text.trim());
            },
          ),
        ],
      ),
    );
  }
}