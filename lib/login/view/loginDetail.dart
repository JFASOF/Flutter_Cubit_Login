import '../model/loginResModel.dart';
import 'package:flutter/material.dart';

class LoginDetailScreen extends StatelessWidget {
  final LoginResModel model;
  const LoginDetailScreen({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      title: Text(model.token ?? ''),),
    );

  }
}