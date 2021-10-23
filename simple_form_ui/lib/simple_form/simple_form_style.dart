import 'package:flutter/material.dart';

class SFStyle {
  final EdgeInsets fieldPadding;
  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;

  const SFStyle({
    this.fieldPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 24,
    ),
    this.titleTextStyle = const TextStyle(fontSize: 22),
    this.subTitleTextStyle = const TextStyle(fontSize: 20),
  });
}
