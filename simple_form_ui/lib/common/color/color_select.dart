import 'package:flutter/material.dart';

import 'color_circle.dart';

class ColorSelectState {
  final List<Color> colors;
  final Color selectedColor;

  ColorSelectState(
    this.colors,
    this.selectedColor,
  );
}

class ColorSelectController extends ValueNotifier<ColorSelectState> {
  ColorSelectController(List<Color> colors, Color selectedColor)
      : super(ColorSelectState(colors, selectedColor));

  factory ColorSelectController.init(Color? color) {
    List<Color> colors = const [
      Color(0xFFEA5532),
      Color(0xFFF6AD3C),
      Color(0xFFFFF33F),
      Color(0xFFAACF52),
      Color(0xFF00A95F),
      Color(0xFF00ADA9),
      Color(0xFF00AFEC),
      Color(0xFF187FC4),
      Color(0xFF4D4398),
      Color(0xFFA64A97),
      Color(0xFFE85298),
      Color(0xFFE9546B),
    ];

    if (color != null && colors.contains(color)) {
      return ColorSelectController(colors, color);
    }
    return ColorSelectController(colors, const Color(0xFFEA5532));
  }

  void select(Color color) {
    if (value.colors.contains(color)) {
      value = ColorSelectState(value.colors, color);
      return;
    }

    throw Error();
  }
}

class ColorSelectWidget extends StatelessWidget {
  final ColorSelectController controller;

  const ColorSelectWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (BuildContext context, ColorSelectState value, Widget? child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final color in value.colors)
                ColorCircle(
                  isSelected: color == value.selectedColor,
                  color: color,
                  onChanged: (value) {
                    if (value) {
                      controller.select(color);
                    }
                  },
                )
            ],
          ),
        );
      },
    );
  }
}
