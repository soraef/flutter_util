import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SimpleForm extends StatelessWidget {
  final FormGroup form;
  final List<Widget> children;
  const SimpleForm({
    Key? key,
    required this.form,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
      form: () => form,
      builder: (_, __, ___) {
        return Column(
          children: children,
        );
      },
    );
  }
}
