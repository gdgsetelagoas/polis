import 'package:flutter/material.dart';
import 'package:res_publica/injector.dart';
import 'package:res_publica/ui/home/home_screen.dart';
import 'package:res_publica/ui/widgets/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

Injector injector;

void main() async {
  timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  injector = Injector();
  await injector.resPulica();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Res Publica - Beta',
      theme: ThemeData(
          primarySwatch: AppColors.newColor(Color(0xFFFFE135)),
          textTheme: Theme.of(context).textTheme.copyWith()),
      home: HomeScreen(),
    );
  }
}
