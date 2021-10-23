import 'package:flutter/material.dart';
import 'package:simple_form_ui/simple_form/simple_form_style.dart';

class SFHeader extends StatelessWidget {
  final SFStyle style;
  final Function()? onClose;
  final Function()? onSave;
  const SFHeader({
    Key? key,
    this.onClose,
    this.onSave,
    this.style = const SFStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final left = style.fieldPadding.left - 12;
    final leftZeroOrMore = left > 0.0 ? left : 0.0;
    return Container(
      padding: style.fieldPadding.copyWith(left: leftZeroOrMore),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            visualDensity: VisualDensity.compact,
          ),
          const Spacer(),
          if (onSave != null)
            ElevatedButton(
              onPressed: onSave,
              child: const Text("保存"),
            ),
        ],
      ),
    );
  }
}
