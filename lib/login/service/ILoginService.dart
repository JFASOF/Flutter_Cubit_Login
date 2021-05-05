import 'package:dio/dio.dart';
import '../model/loginReqModel.dart';
import '../model/loginResModel.dart';

abstract class ILoginService {
  final Dio dio;

  ILoginService(this.dio);

  final String loginPath = ILoginServicePath.LOGIN.rawValue;

  Future<LoginResModel?> postUserLogin(LoginReqModel model);
}

enum ILoginServicePath { LOGIN }

extension ILoginServicePathExtension on ILoginServicePath {
  String get rawValue {
    switch (this) {
      case ILoginServicePath.LOGIN:
        return '/login';
    }
  }
}