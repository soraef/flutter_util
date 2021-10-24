import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  final bool isSelected;
  final Color color;
  final ValueChanged<bool> onChanged;

  const ColorCircle({
    Key? key,
    required this.isSelected,
    required this.color,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget circle;
    if (isSelected) {
      circle = Container(
        margin: const EdgeInsets.all(2),
        width: 27,
        height: 27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: color),
        ),
        child: buildCircle(27, isSelected),
      );
    } else {
      circle = Padding(
        padding: const EdgeInsets.all(2.0),
        child: buildCircle(23, isSelected),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: circle,
    );
  }

  Widget buildCircle(double size, bool isSelected) {
    final circle = ClipOval(
      child: Material(
        child: InkWell(
          onTap: () {
            onChanged(!isSelected);
          },
          splashColor: color,
          child: Container(
            margin: const EdgeInsets.all(2),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );

    return circle;
  }
}
