import 'package:flutter/material.dart';

class InputDropdown extends StatelessWidget {
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;

  InputDropdown({
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  });

  @override 
  Widget build(BuildContext context) {
    return InkWell(
      child:InputDecorator(
        decoration: InputDecoration(labelText: labelText),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize:MainAxisSize.min,
          children: <Widget>[ Text(valueText)],)
      ),
      onTap:onPressed,
    ); 
    
  }
}
