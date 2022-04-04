import 'package:flutter/material.dart';
//import 'package:polypal/models/global.dart';
import 'package:polypal/pages/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LaunchScreen(),
          '/second': (context) => const AppScreen(),
        });
  }
}
