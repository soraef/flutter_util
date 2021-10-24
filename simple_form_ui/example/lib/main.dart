import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:simple_form_ui/fields/simple_form_header.dart';
import 'package:simple_form_ui/fields/tag_field.dart';
import 'package:simple_form_ui/fields/title_text.dart';
import 'package:simple_form_ui/simple_form/simple_form.dart';
import 'package:simple_form_ui/simple_form/simple_form_style.dart';
import 'package:simple_form_ui/simple_form_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FormGroup form;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    form = FormGroup({
      "tag": FormControl<Set<String>>(
        value: {"a", "b"},
      ),
      "duration": FormControl<Duration>(
        value: Duration.zero,
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SimpleForm(
            form: form,
            children: [
              SFHeader(
                onClose: () {},
                onSave: () {
                  print(form.value);
                },
              ),
              const Divider(),
              SFTitleText(
                formControlName: "duration",
                title: "",
                style: const SFStyle(),
                valueToString: (d) => d.toString(),
              ),
              const Divider(),
              SFTagField(
                label: Text("タグ"),
                formControlName: "tag",
                tagsOption: [
                  "a",
                  "b",
                  "c",
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
