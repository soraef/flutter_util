import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:simple_form_ui/simple_form/simple_form_style.dart';

class SFTitleText<T> extends StatelessWidget {
  final String title;
  final SFStyle style;
  final String formControlName;
  final String Function(T) valueToString;

  const SFTitleText({
    Key? key,
    required this.formControlName,
    required this.title,
    required this.style,
    required this.valueToString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(
      builder: (BuildContext context, FormGroup formGroup, Widget? child) {
        final control = formGroup.control(formControlName) as FormControl<T>;
        final String title =
            control.value != null ? valueToString(control.value!) : "";

        return Container(
          padding: style.fieldPadding,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: style.titleTextStyle,
          ),
        );
      },
    );
  }
}
