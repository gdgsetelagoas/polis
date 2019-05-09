import 'package:flutter/material.dart';
import 'package:res_publica/injector.dart';
import 'package:res_publica/ui/home/home_screen.dart';

Injector injector;

void main() {
  injector = Injector()..resPulica();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
