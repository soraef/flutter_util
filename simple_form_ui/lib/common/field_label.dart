import 'package:flutter/material.dart';
import 'package:simple_form_ui/simple_form/simple_form_style.dart';

class FieldLabel extends StatelessWidget {
  final Widget label;
  final Widget child;
  final SFStyle style;
  const FieldLabel({
    Key? key,
    required this.label,
    required this.child,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: style.fieldPadding,
      child: Row(
        children: [
          Container(
            child: label,
            padding: EdgeInsets.zero,
          ),
          const Spacer(),
          child,
        ],
      ),
    );
  }
}
