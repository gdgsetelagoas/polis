import 'package:flutter/material.dart';
import 'package:res_publica/injector.dart';
import 'package:res_publica/ui/home/home_screen.dart';
import 'package:res_publica/ui/widgets/app_colors.dart';

Injector injector;

void main() async {
  injector = Injector();
  await injector.resPulica();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Res Publica - Alpha',
      theme: ThemeData(
        primarySwatch: AppColors.newColor(Color(0xFFFFE135)),
      ),
      home: HomeScreen(),
    );
  }
}
