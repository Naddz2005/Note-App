import 'package:flutter/material.dart';

import '../core/constants.dart';

class DisplayTag extends StatelessWidget {
  final List<String> ls_tags;
  const DisplayTag({super.key, required this.ls_tags});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: ls_tags.length,
          itemBuilder: (context, index) {
            return _buildTag(ls_tags[index]);
          }),
    );
  }
}

Widget _buildTag(String tag) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: gray100,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    margin: const EdgeInsets.only(right: 4),
    child: Text(
      tag,
      style: TextStyle(color: gray900, fontWeight: FontWeight.bold),
    ),
  );
}

