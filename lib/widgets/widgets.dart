import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff40B5AD), width: 2)
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff5D3FD3), width: 2)
  ),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2)
  ),
);