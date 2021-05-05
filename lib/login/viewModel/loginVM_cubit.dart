import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../model/loginReqModel.dart';
import '../model/loginResModel.dart';
import '../service/ILoginService.dart';

class LoginVMCubit extends Cubit<LoginVMState> {
  final TextEditingController emailController;
  final TextEditingController passController;
  final GlobalKey<FormState> formKey;
  final ILoginService service;

  bool isLoginFail=false;
  bool isLoading=false;

  LoginVMCubit(this.formKey, this.emailController, this.passController, {required this.service}) : super(LoginVMInitial());

  //kaydetmek için servise istek
  Future<void> postUserModel() async{
    if (formKey.currentState !=null && formKey.currentState!.validate()) {
      print('Validate Hazırlığı');
      changeLoading();
      final data= await service.postUserLogin(LoginReqModel(email:emailController.text.trim(),password:passController.text.trim()));
      changeLoading();
      if (data is LoginResModel) {
        emit(LoginVMComplete(data));
      }
    }else{
      print("Validate değil");
      isLoginFail=true;
      emit(LoginValidateState(isLoginFail));
    }
  }
  void changeLoading(){
    isLoading= !isLoading;
    emit(LoginLoadingState(isLoading));
  }
}
abstract class LoginVMState{}
class LoginVMInitial extends LoginVMState{}
class LoginVMComplete extends LoginVMState{
  final LoginResModel model;

  LoginVMComplete(this.model);
}
class LoginValidateState extends LoginVMState{
  final bool isValidate;
  LoginValidateState(this.isValidate);
}
class LoginLoadingState extends LoginVMState{
  final bool isLoading;

  LoginLoadingState(this.isLoading);

}