import 'package:dio/dio.dart';
import '../service/loginService.dart';
import 'loginDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewModel/loginVM_cubit.dart';

//stateless yapıp bloc tarafından yönetelim
class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final String baseUri = 'https://reqres.in/api';
  @override
  Widget build(BuildContext context) {
    //sayfanın stateindeki elemanı provider atamak
    return BlocProvider(
      create: (context) => LoginVMCubit(
          formKey, emailController, passController,
          service: LoginService(Dio(BaseOptions(baseUrl: baseUri)))),
      child: BlocConsumer<LoginVMCubit, LoginVMState>(
        //listener state dinleme işlemi
        listener: (context, state) {
          if (state is LoginVMComplete) {
            state.navigateRoute(context);
          }
        },
        //state göre ekranda işlem yapacağım.
        builder: (context, state) {
          return buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold buildScaffold(BuildContext context, LoginVMState state) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Form(
        key: formKey,
        //kişi dokunduğu an validasyon kontrolü
        autovalidateMode: autovalidateMode(state),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextFormFieldEmail(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            buildTextFormFieldPassword(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            buildElevatedButtonLogin(context)
          ],
        ),
      ),
    );
  }

  Widget buildElevatedButtonLogin(BuildContext context) {
    //Widget içi blocComnsumer Kullanımı
    //sadece bunu dinlemesinin istediğim durumlar için
    //sadece bu widget için BlocConsumer sadece bu widget için yönetimi
    return BlocConsumer<LoginVMCubit, LoginVMState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoginVMComplete) {
          return Card(child: Icon(Icons.check));
        }
        return ElevatedButton(
            onPressed: context.watch<LoginVMCubit>().isLoading
                ? null
                : () {
                    context.read<LoginVMCubit>().postUserModel();
                  },
            child: Text("Login"));
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: Visibility(
        visible: context.watch<LoginVMCubit>().isLoading,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      ),
      centerTitle: true,
      title: Text("Cubit Login"),
    );
  }

  AutovalidateMode autovalidateMode(LoginVMState state) => state
          is LoginValidateState
      ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
      : AutovalidateMode.disabled;

  TextFormField buildTextFormFieldEmail() {
    return TextFormField(
      controller:
          emailController, //context.read<LoginVMCubit>().emailController,
      validator: (value) => value!.length > 6 ? null : '6 dan kücük olamaz',
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
    );
  }

  TextFormField buildTextFormFieldPassword() {
    return TextFormField(
      controller: passController,
      validator: (value) => value!.length > 5 ? null : '5 ten kücük olamaz',
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: 'Parola'),
    );
  }
}

extension LoginCompleteExt on LoginVMComplete {
  void navigateRoute(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginDetailScreen(model: model)));
  }
}
