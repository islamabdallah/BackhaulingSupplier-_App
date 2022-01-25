import 'dart:ui';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/features/login/presentation/pages/login-page.dart';
import 'package:haulerapp/features/request/data/models/dropDown-data.dart';
import 'package:haulerapp/features/share/custom-dialog.dart';
import 'package:haulerapp/features/share/loading-dialog.dart';
import 'package:haulerapp/features/signup/data/models/registerData.dart';
import 'package:haulerapp/features/signup/presentation/bloc/signup-bloc.dart';
import 'package:haulerapp/features/signup/presentation/bloc/signup-events.dart';
import 'package:haulerapp/features/signup/presentation/bloc/signup-state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-events.dart';
import 'package:haulerapp/features/login/presentation/bloc/login-state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../home.dart';

class SignUpWidget extends StatefulWidget {
  static const routeName = ' SignUpWidget';

  SignUpWidgetState createState() =>  SignUpWidgetState();
}

class  SignUpWidgetState extends State< SignUpWidget> {
  SignUpBloc _bloc = SignUpBloc(BaseSignUpState());

  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyPhoneController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController companyIndustryController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactPhoneController = TextEditingController();
  TextEditingController otherIndustryController = TextEditingController();

  RegisterModel registerData = new RegisterModel(email: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _clicked = false;

  DropDownDataModel selectedIndustry;
  List<DropDownDataModel> industries = [];

  @override
  void initState() {
    _bloc.add(GetIndustryEvent());
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
  String validatePassword(String value) {
    if (value.isEmpty || value.length < 6)
      return  translator.translate('passwordError');
    else
      return null;
  }
  String validateMobile(String value,{bool isOptional = false}) {
  if(isOptional && (value==null || value.isEmpty)){
  return null;
  }
  if (!isOptional || value.isNotEmpty) {
    return RegExp(r'^01(0|1|2|5){1}[0-9]{8}$').hasMatch(value) ? null :  translator.translate('required') ;
  }
  return null;
  }

  showAlertDialog(title,msg,type) {
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AdvanceCustomAlert(title,msg,type);
      },
    );
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
    body:SingleChildScrollView(
    child: Column(
          children: <Widget>[
//            ClipPath(
//                child: Container(
//                  width: MediaQuery.of(context).size.width,
//                  height: 110,
//                  color: Colors.blue,
//                  child: Center(
//                    child: Container(
//                        height: 100,
//                        padding: EdgeInsets.only(top:50.0),
//                        child: Text(translator.translate('signUp'),style: TextStyle(fontFamily: FONT_FAMILY, color: Colors.white ,
//                            fontWeight: FontWeight.w400, fontSize: 25)),
//                    ),
//                  ),
//                ),
//                clipper: CustomClipPath(),
//              ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Center(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Container(
                    width: 180,
                    height: 90,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child:  Image.asset('assets/images/cemex.jpg')),
                  Text(translator.translate('signUp'),style: TextStyle(fontFamily: FONT_FAMILY, color: Colors.grey ,
                            fontWeight: FontWeight.w400, fontSize: 16))
                ])

              ),
            ),
            BlocConsumer(
                cubit: _bloc,
                builder: (context, state) {
                  return Container(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Stack(
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                    children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:15.0,right: 15.0,top:10,bottom: 0),
                                                   //   padding: EdgeInsets.symmetric(horizontal: 15),
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                           labelText: translator.translate('name'),
                                                            //hintText: translator.translate('companyName'),
                                                            contentPadding: EdgeInsets.only(top: 1.0,bottom: 0.0),
//                                                            prefixIcon: const Icon( Icons.label, ),
                                                            icon: const Icon( Icons.label, color: Colors.orange ),
//                                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,)
                                                        ),
                                                        style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.grey),
                                                        keyboardType: TextInputType.text,
                                                        controller: companyNameController,
                                                        validator: (value) => value.isEmpty || value.trim().isEmpty ? translator.translate('required') : null,
                                                        onChanged: (String val) {
                                                          this.registerData?.compnayName = companyNameController.text.toString();
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                           labelText: translator.translate('phone'),
//                                                            hintText: translator.translate('companyPhone'),
//                                                            border: OutlineInputBorder(),
//                                                            prefixIcon: const Icon( Icons.call, ),
                                                            icon: const Icon( Icons.call, color: Colors.orange ),
                                                            contentPadding: EdgeInsets.only(top: 1.0,bottom: 0.0),

//                                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)
                                                        ),
                                                        style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,
                                                            color: Colors.grey),
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                        ],
                                                        controller: companyPhoneController,
                                                        validator: (value) => validateMobile(value,isOptional: true),
                                                        onChanged: (String val) {
                                                          this.registerData?.compnayPhone = companyPhoneController.text.toString();
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                      labelText: translator.translate('address'),
//                                                            hintText: translator.translate('companyAddress'),
//                                                            border: OutlineInputBorder(),
                                                            contentPadding: EdgeInsets.only(top: 1.0,bottom: 0.0),
//                                                            prefixIcon: const Icon( Icons.home, ),
                                                        icon: const Icon( Icons.home,color: Colors.orange  ),
//                                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)
                                                        ),
                                                        style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,
                                                            color: Colors.grey),
                                                        keyboardType: TextInputType.text,
                                                        controller: companyAddressController,
                                                        onChanged: (String val) {
                                                          this.registerData?.compnayAddress = companyAddressController.text.toString();
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
                                                      child:DropdownButtonFormField<DropDownDataModel>(
                                                        decoration: InputDecoration(
                                                            labelText: translator.translate('companyIndustry'),
//                                                            border: OutlineInputBorder(),
                                                            contentPadding: EdgeInsets.only(top: 1.0,bottom: 0.0),
//                                                            prefixIcon: const Icon( Icons.whatshot, ),
                                                        icon: const Icon( Icons.whatshot,color: Colors.orange  ),
//                                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)
                                                        ),
                                                          style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,
                                                              color: Colors.grey),
                                                        validator: (value) => value == null ? translator.translate('required') : null,
                                                        value: selectedIndustry,
                                                        isExpanded: true,
                                                        onChanged: (DropDownDataModel value) {
                                                          this.registerData?.industryId = value.id;
                                                          if (value.nameEn != 'Other') this.registerData?.newIndustry = '';
                                                          setState(() {
                                                            selectedIndustry = value;
                                                          });

                                                        },

                                                        items: industries.map((DropDownDataModel industry) {
                                                          return  DropdownMenuItem<DropDownDataModel>(
                                                            value: industry,
                                                            child: Row(
                                                              children: <Widget>[
                                                                Text(
                                                                  (translator.currentLanguage == 'en')?  industry.nameEn : industry.nameAr,
                                                                  style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ) ,
                                                    ),
                                                    if(selectedIndustry?.nameEn == 'Other')
                                                      Padding(
                                                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                                        child:  TextFormField(
                                                          decoration: InputDecoration(
                                                            labelText: translator.translate('other'),
//                                                              hintText: translator.translate('other'),
//                                                              border: OutlineInputBorder(),
//                                                              prefixIcon: const Icon( Icons.edit, ),
                                                          icon: const Icon( Icons.edit, color: Colors.orange ),
                                                              contentPadding: EdgeInsets.only(top: 1.0,bottom: 0.0),
//                                                              labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)
                                                          ),
                                                          style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,
                                                              color: Colors.grey),
                                                          keyboardType: TextInputType.text,
                                                          controller: otherIndustryController,
                                                          validator: (value) => value.isEmpty || value.trim().isEmpty  ? translator.translate('required') : null,
                                                          onChanged: (String val) {
                                                            this.registerData?.newIndustry = otherIndustryController.text.toString();
                                                          },
                                                        ),

                                                      ),
                                                  ]),
                                                decoration: BoxDecoration(
                                                    border: Border.all(width: 2.0,color: Colors.grey),
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.circular(10.0)
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                                margin:  EdgeInsets.symmetric(vertical: 15.0,horizontal: 0.0),
                                              ),
                                              Container(

                                                margin: EdgeInsets.only(top: 0,left: 0,right: 0),
                                                width: 150,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius: (translator.currentLanguage == 'en' ) ?
                                                    BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                                                        : BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                                    border: Border.all(color: Colors.orange, width: 3),
                                                    color: Colors.orange
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(width: 10,),
                                                      Text(translator.translate('companyData'),style: TextStyle(fontFamily: FONT_FAMILY,
                                                          fontWeight: FontWeight.w700,color: Colors.white)),
                                                    ]
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Container(
                                      child: Stack(
                                      children: <Widget>[
                                      Container(
                                      child: Column(
                                      children: <Widget>[
                                        Padding(
                                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: translator.translate('name'),
//                                              hintText: translator.translate('contactName'),
//                                                      prefixIcon: const Icon( Icons.person, ),
                                                icon: const Icon( Icons.person, color: Colors.orange ),
//                                                        labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                              ),
                                              style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, ),
                                              keyboardType: TextInputType.text,
                                              controller: contactNameController,
                                              validator: (value) => value.isEmpty || value.trim().isEmpty  ? translator.translate('required') : null,
                                              onChanged: (String val) {
                                                this.registerData?.contactName = contactNameController.text.toString();
                                              },
                                            ),
//                                            Row(children: [
//                                              Expanded(
//                                                  flex: 1,
//                                                  child:
//                                                  TextFormField(
//                                                    decoration: InputDecoration(
//                                                        labelText: translator.translate('name'),
////                                              hintText: translator.translate('contactName'),
////                                                      prefixIcon: const Icon( Icons.person, ),
//                                                      icon: const Icon( Icons.person, color: Colors.orange ),
////                                                        labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
//                                                    ),
//                                                    style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, ),
//                                                    keyboardType: TextInputType.text,
//                                                    controller: contactNameController,
//                                                    validator: (value) => value == null ? translator.translate('required') : null,
//                                                    onChanged: (String val) {
//                                                      this.registerData?.contactName = contactNameController.text.toString();
//                                                    },
//                                                  )
//                                              ),
////                                              SizedBox(width:20.0),
////                                              Expanded(
////                                                flex: 1,
////                                                child:  TextFormField(
////                                                  decoration: InputDecoration(
////                                                      labelText: translator.translate('phone'),
//////                                            hintText: translator.translate('contactPhone'),
//////                                                      prefixIcon: const Icon( Icons.call, ),
////
////                                                    icon: const Icon( Icons.call, color: Colors.orange ),
//////                                                      labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
////                                                  ),
////                                                  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, ),
////                                                  keyboardType: TextInputType.number,
////                                                  inputFormatters: <TextInputFormatter>[
////                                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
////                                                  ],
////                                                  controller: contactPhoneController,
////                                                  validator: (value) => validateMobile(value,isOptional: false),
////                                                  onChanged: (String val) {
////                                                    this.registerData?.contactPhone = contactPhoneController.text.toString();
////                                                  },
////                                                ),
////                                              ),
//                                            ],)
                                        ),
                  Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
                  child:TextFormField(
                    decoration: InputDecoration(
                      labelText: translator.translate('phone'),
//                                            hintText: translator.translate('contactPhone'),
//                                                      prefixIcon: const Icon( Icons.call, ),

                      icon: const Icon( Icons.call, color: Colors.orange ),
//                                                      labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                    ),
                    style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    controller: contactPhoneController,
                    validator: (value) => validateMobile(value,isOptional: false),
                    onChanged: (String val) {
                      this.registerData?.contactPhone = contactPhoneController.text.toString();
                    },
                  ),
                  ),
                                        Padding(
                                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                labelText: translator.translate('email'),
//                                      hintText: translator.translate('contactEmail'),
//                                                prefixIcon: const Icon( Icons.email, ),

                                             icon: const Icon( Icons.email,color: Colors.orange  ),
//                                                labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                            ),
                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, ),
                                            keyboardType: TextInputType.emailAddress,
                                            controller: contactEmailController,
                                            validator: validateEmail,
                                            onChanged: (String val) {
                                              this.registerData?.email = contactEmailController.text.toString();
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 15,),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                labelText: translator.translate('password'),
//                                      hintText: translator.translate('passwordHint'),
//                                                prefixIcon: const Icon( Icons.lock_outline, ),

                                            icon: const Icon( Icons.lock_outline,color: Colors.orange  ),
//                                                labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                            ),
                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, ),
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            controller: passwordController,
                                            validator: validatePassword,
                                            onChanged: (String val) {
                                              this.registerData?.password = passwordController.text.toString();
                                            },
                                          ),
                                        ),
                                      ]),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 2.0,color: Colors.grey),
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 20.0),
                                        margin:  EdgeInsets.symmetric(vertical: 15.0,horizontal: 0.0),
                                      ),
                                        Container(
                                          margin: EdgeInsets.only(top: 0,left: 0,right: 0),
                                          width: 150,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: (translator.currentLanguage == 'en' ) ?
                                              BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                                                  : BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                              border: Border.all(color: Colors.orange, width: 3),
                                              color: Colors.orange
                                          ),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 10,),
                                                Text(translator.translate('contactData'),style: TextStyle(fontFamily: FONT_FAMILY,
                                                    fontWeight: FontWeight.w700,color: Colors.white)),
                                              ]
                                          ),
                                        ),                                      ])),

                             SizedBox(
                                height: 10,
                             ),


                  ]),
                          ),

                          if (state is  SignUpFailedState)  Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5, bottom: 5),
                              child:Align(child: Text(state.error.message,
                                style: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),),
                            alignment: Alignment.centerRight,
                          )),
                          Container(
                            margin: EdgeInsets.only(top: 40),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 30.0,
                            decoration: BoxDecoration(  color: Colors.blue, borderRadius: BorderRadius.circular(5),),
                            child: FlatButton(
                              onPressed: () {
//                                _bloc.add(SignUpEvent(registerModel: this.registerData));

                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                if (_formKey.currentState.validate()) {

                                  _bloc.add(SignUpEvent(registerModel: this.registerData));
                                //  loadingAlertDialog(context);
                                }
                              },
                              child: Text(
                                translator.translate('save'),
                                style: TextStyle(color: Colors.white,  fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ]),
                  ),);
                },
                listener: (context, state) {
                  if (state is GetIndustrySuccessState) {
                    print(state.industryData);
                    setState(() {
                      industries = state.industryData;
                      final other = DropDownDataModel.fromJson({"id": 0, "nameEN": "Other", "nameAR": "أخرى", "active": true});
                      industries.add(other);
                    });
                  }
                  if (state is SignUpSuccessState) {
                    Navigator.pop(context);
                    var successData = state.successData;
                    var msg = (translator.currentLanguage == 'en' ) ? successData.msgEN : successData.msgAR;
                    showAlertDialog('success', msg, true);
                    _formKey.currentState.reset();
                  }
                  if (state is SignUpLoadingState ) loadingAlertDialog(context);
                  if (state is GetIndustrySuccessState) Navigator.of(context).pop();

                  if (state is SignUpFailedState){
                    Navigator.of(context).pop();
                    var msg = state.error.message;
                    showAlertDialog('error', msg, false);
                  }
                }),

            SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 3, bottom: 3),
                child:Align(
                  child:FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginWidget.routeName);
                    },
                    child: Text(translator.translate('haveAccount'),
                      style: TextStyle(  fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                )),
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
