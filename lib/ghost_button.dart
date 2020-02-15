import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String response;
  Button(this.response);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: null,
      child: Text(response),
    );
  }
}
