import 'package:flutter/material.dart';
import 'package:ilk_projem/arayuz/intro.dart';

import 'info.dart';

class MyButtons extends StatelessWidget {
  Color color;
  MyButtons(color);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color(0xFF9C0000),
      onPressed: () {
          
      },
      child: Text(
        "Destek Ol!",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
