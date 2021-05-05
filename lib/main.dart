import 'package:flutter/material.dart';

import 'login/view/loginScreen.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}