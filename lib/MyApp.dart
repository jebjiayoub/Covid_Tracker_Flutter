import 'package:flutter/material.dart';
import 'package:covidtracker/screens/Login.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID-19',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Login(),
    );
  }
}
