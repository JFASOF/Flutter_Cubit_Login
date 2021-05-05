import 'dart:io';

import 'package:dio/dio.dart';
import '../model/loginReqModel.dart';
import '../model/loginResModel.dart';
import 'ILoginService.dart';

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<LoginResModel?> postUserLogin(LoginReqModel model) async {
    final response = await dio.post(loginPath, data: model);

    if (response.statusCode == HttpStatus.ok) {
      return LoginResModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}