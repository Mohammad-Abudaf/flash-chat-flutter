import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Color colour;
  final Function function;
  RoundedButton({@required this.title, this.colour, @required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour ?? Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: function,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }}