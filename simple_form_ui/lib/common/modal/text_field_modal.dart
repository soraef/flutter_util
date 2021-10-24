import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<String?> showTextFieldModal(
  BuildContext context,
) async {
  return await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration.collapsed(
              hintText: "tag name",
              hintStyle: TextStyle(
                fontSize: 18,
              ),
            ),
            onSubmitted: (abc) {
              Navigator.of(context).pop(abc);
            },
          ),
        ),
      );
    },
  );
}
