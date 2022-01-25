import 'dart:ui';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/features/forgotPassword/presentation/pages/forgot-password-page.dart';
import 'package:haulerapp/features/request/presentation/pages/request-page.dart';
import 'package:haulerapp/features/share/loading-dialog.dart';
import 'package:haulerapp/features/signup/presentation/pages/signup-page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
//import 'package:haulerapp/features/home/presentation/pages/request-list.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-bloc.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-events.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-state.dart';
import 'package:haulerapp/core/ui/widgets/loader_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../home.dart';

class LoginWidget extends StatefulWidget {
  static const routeName = 'LoginWidget';

  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  LoginBloc _bloc;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _userNameValidate = false;
  bool _passwordValidate = false;
  UserModel user = new UserModel(email: '', password: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _clicked = false;


  @override
  void initState() {
    _bloc = LoginBloc(BaseLoginState());
    print(translator.currentLanguage);

    super.initState();
  }
// validate Email
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    print(regex.hasMatch(value));
    if (!regex.hasMatch(value))
      return  translator.translate('emailError');
    else
      return null;
  }
//   validate Password
  String validatePassword(String value) {
    if (value.isEmpty)
      return  translator.translate('passwordError');
    else
      return null;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }


  @override
  Widget  build(BuildContext context) {
    // TODO: implement  build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            ClipPath(
//                child: Container(
//                  width: MediaQuery.of(context).size.width,
//                  height: 200,
//                  color: Colors.blue,
//                  child: Center(
//          child: Container(
//          width: 200,
//          height: 100,
//          /*decoration: BoxDecoration(
//                        color: Colors.red,
//                        borderRadius: BorderRadius.circular(50.0)),*/
//          child: Image.asset('assets/images/cemex.jpg')),
//    ),
//                ),
//                clipper: CustomClipPath(),
//              ),

            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/cemex.jpg')),
              ),
            ),
            BlocConsumer(
                cubit: _bloc,
                builder: (context, state) {
//                  if (state is LoginFailedState) {
//                    if (_clicked) {
//                      _clicked = false;
//                      Navigator.pop(context);
//                    }
//
//                  }

                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child:
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: translator.translate('email'),
                                  hintText: translator.translate('emailHint'),
                                  labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                              ),
                              style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.blue),
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              validator: validateEmail,
                              onChanged: (String val) {
                                this.user?.email = emailController.text.toString();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: translator.translate('password'),
                                  hintText: translator.translate('passwordHint'),
                                  labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                              ),
                              style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.blue),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              controller: passwordController,
                              validator: validatePassword,
                              onChanged: (String val) {
                                this.user?.password = passwordController.text.toString();
                              },
                            ),
                          ),
                          if (state is LoginFailedState)  Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5, bottom: 5),
                              child:Align(child: Text(state.error.message,
                                style: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),),
                            alignment: Alignment.centerRight,
                          )),
//                          Padding(
//                          padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 5, bottom: 5),
//                              child:Align(
//                                child:FlatButton(
//                                  onPressed: () {
//                              //TODO FORGOT PASSWORD SCREEN GOES HERE
//
//                                    Navigator.pushNamed(context, ForgotPasswordWidget.routeName);
//
//                                  },
//                            child: Text(translator.translate('forgotPassword'),
//                              style: TextStyle(color: Colors.blue, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),
//                            ),
//                          ),
//                            alignment: (translator.currentLanguage == 'en' )? Alignment.centerLeft : Alignment.centerRight,
//                          )),
                          Container(
                            margin: EdgeInsets.only(top: 45),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 30.0,
                            decoration: BoxDecoration( color: Colors.blue, borderRadius: BorderRadius.circular(5),),
                            child: FlatButton(
                              onPressed: () {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                if (_formKey.currentState.validate()) {

                                  _bloc.add(LoginEvent(userModel: this.user));
                                }

                              },
                              child: Text(
                                translator.translate('login'),
                                style: TextStyle(color: Colors.white,  fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ]),
                  );
                },
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(HomeWidget.routeName, (Route<dynamic> route) => false);
                  }
                  if (state is LoginFailedState)  Navigator.pop(context);
                  if (state is LoginLoadingState) loadingAlertDialog(context);
                }),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 3, bottom: 3),
                child:Align(
                  child:FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpWidget.routeName);
                    },
                    child: Text(translator.translate('newUser'),
                      style: TextStyle(  fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                )),

            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                  child: Text( translator.translate('english'), style: TextStyle(
                      color:(translator.currentLanguage == 'en')? Colors.grey: Colors.blue,
                      fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),),
                  color: Colors.transparent,
                  textColor: Colors.black,
                  onPressed: () {
                    translator.setNewLanguage(
                      context,
                      newLanguage: 'en',
                      remember: true,
                      restart: true,
                    );
                  },
                ),
                  SizedBox(
                    width: 20,
                    child:Text('|', style: TextStyle(
                        color:(translator.currentLanguage != 'en')? Colors.grey: Colors.blue,
                        fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),),
                  ),
                  FlatButton(
                    child: Text( translator.translate('arabic'), style: TextStyle(fontSize: 20.0),),
                    color: Colors.transparent,
                    textColor: Colors.black,
                    onPressed: () {
                      translator.setNewLanguage(
                        context,
                        newLanguage: 'ar',
                        remember: true,
                        restart: true,
                      );
                    },
                  )
                ],
              ),

            )
          ],
        ),
      ),
    );
  }
}
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height
        - 40, size.width/2, size.height-20);
    path.quadraticBezierTo(3/4*size.width, size.height,
        size.width, size.height-30);
    path.lineTo(size.width, 0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}