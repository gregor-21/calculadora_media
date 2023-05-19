import 'package:flutter/material.dart';
import 'package:score_calculation/calculator.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  Future.delayed(Duration(seconds: 2), () {
    runApp(MediaCalculatorApp());
  });
}
