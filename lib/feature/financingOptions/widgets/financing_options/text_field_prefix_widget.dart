import 'package:flutter/material.dart';

class TextFieldPrefixWidget extends StatelessWidget {
  const TextFieldPrefixWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Text("  \$", style: TextStyle(color: Colors.black)));
  }
}
