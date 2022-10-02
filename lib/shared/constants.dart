import 'package:flutter/material.dart';

class Constants{
  final primaryColor = const Color(0xff5D3FD3);
}

void nextScreen(context, page){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplacement(context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}