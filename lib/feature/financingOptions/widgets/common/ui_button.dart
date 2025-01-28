import 'package:flutter/material.dart';

class UiButton extends StatelessWidget {
  final String title;
  final bool background;
  const UiButton({super.key, required this.title, this.background = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: background ? Color(0xff0e7cf4) : Colors.white,
          border: background ? Border.all(color: Colors.transparent) : Border.all(color: Color(0xff0e7cf4)),
          borderRadius: BorderRadius.circular(30),
          ),
      child: Center(
          child: Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: background ? Colors.white : Color(0xff0e7cf4)))),
    );
  }
}
