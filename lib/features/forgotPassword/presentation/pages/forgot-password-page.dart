import 'dart:ui';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/features/forgotPassword/presentation/bloc/forgot-password-bloc.dart';
import 'package:haulerapp/features/forgotPassword/presentation/bloc/forgot-password-state.dart';
import 'package:haulerapp/features/share/loading-dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-events.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../home.dart';

class  ForgotPasswordWidget extends StatefulWidget {
  static const routeName = ' ForgotPasswordWidget';

  ForgotPasswordWidgetState createState() =>  ForgotPasswordWidgetState();
}

class  ForgotPasswordWidgetState extends State< ForgotPasswordWidget> {
  ForgotPasswordBloc _bloc;
  TextEditingController emailController = TextEditingController();
  bool _userNameValidate = false;
  UserModel user = new UserModel(email: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _clicked = false;


  @override
  void initState() {
    _bloc =  ForgotPasswordBloc(BaseForgotPasswordState());
    print(translator.currentLanguage);
    super.initState();
  }
// validate Email
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return  translator.translate('emailError');
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
      appBar: AppBar(
      title: Text(translator.translate('forgotPass'),style: TextStyle(fontFamily: FONT_FAMILY)),
      centerTitle: true,
    ),
    backgroundColor: Colors.white,
    body:SingleChildScrollView(
    child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 100,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/cemex.jpg')),
              ),
            ),
            BlocConsumer(
                cubit: _bloc,
                builder: (context, state) {
                  if (state is  ForgotPasswordFailedState) {
                    if (_clicked) {
                      _clicked = false;
                      Navigator.pop(context);
                    }
                  }

                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                        children: <Widget>[
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15.0),
                      child:Center(child: Text(translator.translate('forgotPassTitle'),
                        style: TextStyle(color: Colors.black38, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,fontSize: 20),),
                      )
                    ),

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
                          if (state is  ForgotPasswordFailedState)  Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5, bottom: 5),
                              child:Align(child: Text(state.error.message,
                                style: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),),
                            alignment: Alignment.centerRight,
                          )),
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
                                  setState(() {
                                    _clicked = true;
                                  });
                             //     _bloc.add(LoginEvent(userModel: this.user));
                                  loadingAlertDialog(context);
                                }

                              },
                              child: Text(
                                translator.translate('save'),
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
                    Navigator.pushReplacementNamed(context, HomeWidget.routeName);
                  }


                }),

            SizedBox(
              height: 15,
            ),
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