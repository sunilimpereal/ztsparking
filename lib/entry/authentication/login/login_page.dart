import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ztsparking/entry/authentication/login/bloc/login_bloc.dart';
import 'package:ztsparking/entry/authentication/login/data/repository/login_repository.dart';
import 'package:ztsparking/entry/authentication/login/widgets/button.dart';
import 'package:ztsparking/entry/authentication/login/widgets/text_field.dart';
import 'package:ztsparking/entry/entry_dash/dashboard_screen.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  bool loginFailFlag = false;
  ontap() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc? loginBloc = LoginProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background-login.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: logincard(loginBloc),
        ),
      ),
    );
  }

  Widget logincard(LoginBloc? loginBloc) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            16,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 100,
            width: 300,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
            )),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              ZTSTextField(
                width: MediaQuery.of(context).size.width * 0.75,
                controller: emailController,
                focusNode: emailFocus,
                icon: Icons.email,
                labelText: 'Email',
                onChanged: loginBloc!.changeEmail,
                onfocus: emailFocus.hasFocus,
                onTap: ontap,
                stream: loginBloc.email,
                heading: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              ZTSTextField(
                width: MediaQuery.of(context).size.width * 0.75,
                controller: passwordController,
                focusNode: passwordFocus,
                icon: Icons.email,
                labelText: 'Password',
                onChanged: loginBloc.changePassword,
                onfocus: passwordFocus.hasFocus,
                onTap: ontap,
                stream: loginBloc.password,
                obscureText: true,
                heading: 'Password',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZTSStreamButton(
                width: 230,
                formValidationStream: loginBloc.validateFormStream,
                submit: () async {
                  LoginRepository loginRepository = LoginRepository();
                  loginRepository
                      .login(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  )
                      .then((value) {
                    Future.delayed(const Duration(milliseconds: 100)).then((value1) {
                      if (value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashBoardWrapper(),
                          ),
                        );
                      }
                      setState(() {
                        loginFailFlag = !value;
                      });
                    });
                  });
                },
                text: 'Login',
                errrorText: 'Login Failed',
                errorFlag: loginFailFlag,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
