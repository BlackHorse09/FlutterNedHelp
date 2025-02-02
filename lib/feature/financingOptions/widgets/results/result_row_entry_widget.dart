import 'package:flutter/material.dart';

class ResultRowEntryWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool blueColorValue;
  const ResultRowEntryWidget(
      {super.key,
      required this.label,
      required this.value,
      this.blueColorValue = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 60,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(label,
                  style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w700)))),
      Expanded(
          flex: 40,
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(value,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: blueColorValue ? Colors.blue : Colors.black),
                  textAlign: TextAlign.end)))
    ]);
  }
}
