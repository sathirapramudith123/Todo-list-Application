import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Color selectedColor;

  ColorPicker({required this.onColorSelected, required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.yellow, Colors.green, Colors.lightBlue];
    return Row(
      children:
          colors.map((color) {
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                margin: EdgeInsets.all(8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border:
                      selectedColor == color
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                ),
              ),
            );
          }).toList(),
    );
  }
}
