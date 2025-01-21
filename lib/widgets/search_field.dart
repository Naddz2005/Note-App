import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/constants.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: "Search notes...",
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
          isDense: true,
          contentPadding: EdgeInsets.zero,
          prefixIconConstraints: BoxConstraints(
            minWidth: 42,
            minHeight: 42,
          ),
          fillColor: white,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: primary,
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.circular(12))),
    );
  }
}