import 'package:flutter/material.dart';

class NoNotes extends StatelessWidget {
  const NoNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/person.png',
              width: MediaQuery.sizeOf(context).width * 0.75,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "Bạn không có ghi chú nào!\nBắt đầu bằng cách nhấn nút cộng!",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}