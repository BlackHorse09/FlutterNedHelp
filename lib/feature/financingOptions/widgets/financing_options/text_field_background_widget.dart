import 'package:flutter/material.dart';

class TextFieldBackgroundWidget extends StatelessWidget {
  final Widget child;
  const TextFieldBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8)
              ),
              color: Color(0xfff3f3f3)),
      child: child,        
    );
  }
}
