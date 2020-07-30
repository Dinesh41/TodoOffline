import 'package:flutter/material.dart';

Widget CustomInputs(
    {TextEditingController controller,
    String inputTag,
    int inputMaxLines,
    double inputHeight,
    String label,
    String hint}) {
  return Container(
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            inputTag,
            style: TextStyle(
              color: Color.fromRGBO(154, 154, 154, 1),
            ),
          ),
        ),
        Container(
          height: inputHeight,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            maxLines: inputMaxLines,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
                labelText: label,
                hintText: hint),
          ),
        ),
      ],
    ),
  );
}
