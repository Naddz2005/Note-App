import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart';
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.isInGrid,
  });

  final bool isInGrid;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            "This is going to ba title",
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
                  3,
                      (index) =>
                      Container(
                        child: Text(
                          "First chip",
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
                  "Some content",
                  style: TextStyle(color: gray700),
                ))
          else
            Text(
              "Some content",
              style: TextStyle(color: gray700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          Row(
            children: [
              Text(
                "21 Jan, 2024",
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: gray500),
              ),
              Spacer(),
              FaIcon(
                FontAwesomeIcons.trash,
                color: gray500,
                size: 16,
              )
            ],
          )
        ],
      ),
    );
  }
}
