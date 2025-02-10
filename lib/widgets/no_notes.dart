import 'package:flutter/material.dart';

class NoNotes extends StatelessWidget {
  const NoNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
            "Ban khong co ghi chu nao!\nBat dau bang cach nhan nut duoi!",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Fredoka'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}