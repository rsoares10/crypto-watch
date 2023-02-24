import 'package:flutter/material.dart';

import 'views/home.view.dart';

void main() async {
  runApp(MaterialApp(
    title: 'Crypto Watch',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
        hintStyle: TextStyle(color: Colors.amber),
      ),
    ),
    home: HomeView(),
  ));
}
