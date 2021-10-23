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
  // String _platformVersion = 'Unknown';
  late FormGroup form;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    form = FormGroup({
      "tag": FormControl<TagItems>(
        value: TagItems.empty(),
      ),
      "duration": FormControl<Duration>(
        value: Duration.zero,
      ),
    });
  }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     platformVersion =
  //         await SimpleFormUi.platformVersion ?? 'Unknown platform version';
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Plugin example app'),
        // ),
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
                onTapSelectTags: (context, selectedTags) {
                  return Navigator.of(context).push<TagItems?>(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: TagSelect(
                          selectedTags: selectedTags,
                          tagOptions: [
                            TagItem(
                              id: "1",
                              name: "ABC",
                              color: Colors.green,
                            ),
                            TagItem(
                              id: "2",
                              name: "abc",
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
