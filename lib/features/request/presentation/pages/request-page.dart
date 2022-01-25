import 'dart:ui';
import 'package:haulerapp/core/flutter_datetime_picker.dart';
import 'package:haulerapp/core/ui/styles/global_styles.dart';
import 'package:haulerapp/features/request/data/models/location.dart';
import 'package:haulerapp/features/request/data/models/request.dart';
import 'package:haulerapp/features/request/data/models/dropDown-data.dart';
import 'package:haulerapp/features/request/presentation/bloc/request-bloc.dart';
import 'package:haulerapp/features/request/presentation/bloc/request-events.dart';
import 'package:haulerapp/features/request/presentation/bloc/request-state.dart';
import 'package:haulerapp/features/requestList/presentation/pages/request-list.dart';
import 'package:haulerapp/features/share/loading-dialog.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haulerapp/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../home.dart';

class RequestWidget extends StatefulWidget {
  static const routeName = 'RequestWidget';

  RequestWidgetState createState() => RequestWidgetState();
}

class RequestWidgetState extends State<RequestWidget> {
  RequestBloc _bloc = RequestBloc(BaseRequestState());

  LocationModel _selectedSource;
  LocationModel _selectedDestination;
  DropDownDataModel _selectedTruckType;
  DropDownDataModel _selectedPackage;
  DropDownDataModel _selectedUnit;

  TextEditingController accessoriesController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController truckNumberController = TextEditingController();

  TextEditingController commentController = TextEditingController();
  TextEditingController pickUpDateController = TextEditingController();
  TextEditingController deliverDateController = TextEditingController();

  List<LocationModel>  allLocations = [];
  List<LocationModel>  sources = [];
  List<LocationModel>  destinations = [];

  List<DropDownDataModel> unitTypes = [];
  List<DropDownDataModel> packages = [];
  List<DropDownDataModel> truckTypes = [];

  DateTime pickUpDate;
  DateTime deliverDate;

  RequestModel request = new RequestModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyTwo = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyThree = GlobalKey<FormState>();

  bool _clicked = false;
  List<Step> steps = [];
  int currentStep = 0;
  bool completeOne = false;
  bool completeTwo = false;
  bool completeThree = false;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  goTo(int step) {
    print(step);
    setState(() => currentStep = step);
  }

  next(context) {
//    currentStep + 1 != steps.length
//        ? goTo(currentStep + 1)
//        : setState(() => complete = true);
  print(steps.length);
  if(currentStep == 2) {
     if (!_formKeyThree.currentState.validate()) {
      goTo(2);
    } else {
      setState(() {
        _clicked = true;
      });
      this.request.numberOfTrucks = int.parse(truckNumberController.text);
      this.request.pickUpDate = pickUpDate;
      this.request.deliverDate = deliverDate;
      this.request.sourceId = _selectedSource.id;
      this.request.destinationId = _selectedDestination.id;
      this.request.truckTypeId = _selectedTruckType.id;
      this.request.productPackageId = _selectedPackage.id;
      this.request.unitTypeId =
      (_selectedPackage?.nameEn != 'Shipment' && _selectedPackage != null)
          ? _selectedUnit?.id
          : null;
      this.request.capacity = int.parse(capacityController.text);
      this.request.accessories = accessoriesController.text;
      this.request.comment = commentController.text;
      print(this.request);
      _bloc.add(SaveRequestEvent(this.request));
      loadingAlertDialog(context);
    }
  }
    setState(() {
      if (currentStep < 2) {
        if (currentStep == 0 && _formKey.currentState.validate()) {
             currentStep = currentStep + 1;
             completeOne = true;
          } else if (currentStep == 1 && _formKeyTwo.currentState.validate()) {
            currentStep = currentStep + 1;
            completeOne = true;
            completeTwo = true;
      }
      } else {
     // currentStep = 0;
      }
    });
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }


  @override
  void initState() {
    _bloc.add(GetRequestFormDataEvent());
    super.initState();
  }

//  Future<void> initPlatformState() async {
//    await BackgroundLocator.initialize();
//  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
  String validateTruckNumber(String value) {
    var testData  =  (value.isEmpty) ? true : (int.parse(value) <= 0 );
    if (testData)
      return  translator.translate('required');
    else
      return null;
  }
  String validateCapacity( value) {
    var testValue  =  (value.isEmpty) ? true : (int.parse(value) > 60 );
    if (testValue)
      return  translator.translate('required');
    else
      return null;
  }
  @override
  Widget  build(BuildContext context) {
    // TODO: implement  build
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('requestHeader'),style: TextStyle(fontFamily: FONT_FAMILY)),
         centerTitle: true,
      ),
     backgroundColor: Colors.white,
      body: Container(
        child: BlocConsumer(
                cubit: _bloc,
                builder: (context, state) {
                  if (state is RequestFailedState) {
                    if (_clicked) {
                      _clicked = false;
                      Navigator.pop(context);
                    }
                  }
                  return  Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Stepper(
                              type: StepperType.horizontal,
                              currentStep: currentStep,
                              onStepContinue: () => next(context),
                              onStepTapped: (step) => null,
                              onStepCancel: cancel,
                              controlsBuilder: (BuildContext context,{VoidCallback onStepContinue,VoidCallback onStepCancel})
                              {
                                return Container(
                                    margin: EdgeInsets.only(top: 45),
//                                  alignment: Alignment.center,
                                    height: 60,
                                    width: MediaQuery.of(context).size.width - 30.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    if (currentStep != 0)  Expanded(
                                        flex:1,
                                        child: MaterialButton(
                                          height: 50,

                                          child: Text(translator.translate('back'),
                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,color: Colors.orange),
                                          ),
//                                        borderSide: BorderSide(color: Colors.orange),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: Colors.orange),
                                          ),
                                          onPressed: onStepCancel,
                                        )),
                                    if (currentStep != 0)  SizedBox(width:10.0),
                                    Expanded(
                                      flex:1,
                                      child: MaterialButton(
                                        height: 50,
                                        child: Text((currentStep != 2) ? translator.translate('next') : translator.translate('send')  ,
                                          style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),),
                                        onPressed: onStepContinue,
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                      ),
                                    ),

                                ],));
                              },
                              steps: [
                                Step(
                                    title:  Text(translator.translate('location'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),
                                    isActive: (currentStep >= 0 || completeOne)? true : false,
                                    state: currentStep == 0 ? StepState.editing : StepState.indexed,
                                    content: Container(
                                       // padding: const EdgeInsets.all(20.0),
                                        child:  Form(
                                          key: _formKey,
                                          autovalidateMode: AutovalidateMode.disabled,
                                          child:Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          DropdownButtonFormField<LocationModel>(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: translator.translate('source'),
                                                hintMaxLines: 1,
                                                labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                            ),
                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                            validator: (value) => value == null ? translator.translate('required') : null,
                                           // iconSize: 40.0,
                                            value: _selectedSource,
                                            isExpanded: true,
                                            onChanged: (LocationModel value) {
                                              var _destinations = sources.where((element) => element.id != value.id).toList();
                                              setState(() {
                                                _selectedSource = value;
                                                destinations = _destinations;
                                                _selectedDestination = null;
                                              });
                                            },
                                            items: sources.map((LocationModel source) {
                                              return  DropdownMenuItem<LocationModel>(
                                                value: source,
                                                child: Text(
                                                  source.name, overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
                                                ),
                                              );
                                            }).toList(),) ,
                                          SizedBox(height:20.0),
                                          DropdownButtonFormField<LocationModel>(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: translator.translate('destination'),
                                                hintMaxLines: 1,
                                                labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                            ),
                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                            validator: (value) => value == null ? translator.translate('required') : null,
                                          //  iconSize: 40.0,
                                            value: _selectedDestination,
                                            isExpanded: true,
                                            onChanged: (LocationModel value) {
                                              setState(() {
                                                _selectedDestination = value;
                                              });
                                            },
                                            items: destinations.map((LocationModel dest) {
                                              return  DropdownMenuItem<LocationModel>(
                                                value: dest,
                                                child:Text(
                                                  dest.name, overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
                                                ),
                                              );
                                            }).toList(),) ,
                                          SizedBox(height:20.0),
                                          DateTimeField(
                                            controller: pickUpDateController,
                                            validator: (value){
                                             return  pickUpDate == null ? translator.translate('required') : null;}
                                              ,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: translator.translate('pickUpDate'),
                                              labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),                                              contentPadding: EdgeInsets.all(3.0),
                                              prefixIcon: const Icon(
                                                Icons.calendar_today,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),

                                            format: DateFormat("dd-MM-yyyy HH:mm "),
                                            onShowPicker: (context, currentValue) async {
                                              final date = await showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime.now(),
                                                  initialDate: currentValue ?? DateTime.now(),
                                                  lastDate: DateTime(2100),
                                              );
                                              if (date != null) {
                                                final time = await showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                                );

                                                return DateTimeField.combine(date, time);
                                              } else {
                                                return currentValue;
                                              }
                                            },
                                            onChanged: (value){
                                              print(value);
                                              setState(() {
                                                pickUpDate = value;
                                              });
                                            },
                                          ),
                                          SizedBox(height:20.0),
                                          DateTimeField(
                                            controller: deliverDateController,
                                            validator: (value) => deliverDate == null ? translator.translate('required') : null,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: translator.translate('pickUpDate'),
                                              labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),                                              contentPadding: EdgeInsets.all(3.0),
                                              prefixIcon: const Icon(
                                                Icons.calendar_today,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                            format:  DateFormat("dd-MM-yyyy HH:mm"),
                                            onShowPicker: (context, currentValue) async {
                                              final date = await showDatePicker(
                                                  context: context,
                                                  firstDate: pickUpDate,
                                                  initialDate: currentValue ?? pickUpDate,
                                                  lastDate: DateTime(2100));
                                              if (date != null) {
                                                final time = await showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                                );
                                                return DateTimeField.combine(date, time);
                                              } else {
                                                return currentValue;
                                              }
                                            },
                                            onChanged: (value){
                                              setState(() {
                                            deliverDate = value;
                                            });
                                            },
                                          ),

                              ]
                          ),

                                        )),

                                ),
                                Step(
                                    isActive: (currentStep >= 1 || completeTwo) ? true : false,
                                    state: currentStep == 1 ? StepState.editing : StepState.indexed,
                                    title:  Text(translator.translate('truck'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),
                                    content:Container(
                                      child: Form(
                                        key: _formKeyTwo,
                                        autovalidateMode: AutovalidateMode.disabled,
                                      child:Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                DropdownButtonFormField<DropDownDataModel>(
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: translator.translate('truckType'),
                                                      hintMaxLines: 1,
                                                      labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                                  ),
                                                  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                                  validator: (value) => value == null ? translator.translate('required') : null,
                                                 // iconSize: 40.0,
                                                  value: _selectedTruckType,
                                                  isExpanded: true,
                                                  onChanged: (DropDownDataModel value) {
                                                    setState(() {
                                                      _selectedTruckType = value;
                                                    });
                                                  },
                                                  items: truckTypes.map((DropDownDataModel unitType) {
                                                    return  DropdownMenuItem<DropDownDataModel>(
                                                      value: unitType,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            (translator.currentLanguage == 'en')?  unitType.nameEn : unitType.nameAr,
                                                            style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),) ,
                                                SizedBox(height:20.0),
                                                TextFormField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: translator.translate('numberOfTrucks'),
                                                      labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                                  ),
                                                  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                                  keyboardType: TextInputType.phone,
                                                  controller: truckNumberController,
                                                  validator: validateTruckNumber,
                                                  onChanged: (String val) {
                            //                                this.user?.email = emailController.text.toString();
                                                  },
                                                ),
                                                SizedBox(height:20.0),
                                                TextFormField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: translator.translate('accessories'),
                                                      labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                                  ),
                                                  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                                  keyboardType: TextInputType.text,
                                                  controller: accessoriesController,
//                                                  validator: null,
                                                maxLines: 3,
                                                  onChanged: (String val) {
                            //                                this.user?.email = emailController.text.toString();
                                                  },
                                                ),
                                                ]
                                            ),
                                      ),
                                      ),
                                ),
                                Step(
                                  isActive: (currentStep == 2 || completeThree) ? true : false,
                                  state: currentStep == 2 ? StepState.editing : StepState.indexed,
                                  title:  Text(translator.translate('package'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),
                                          content: Container(
                                              child: Form(
                                              key: _formKeyThree,
                                              autovalidateMode: AutovalidateMode.disabled,
                                                child:Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      DropdownButtonFormField<DropDownDataModel>(
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: translator.translate('package'),
                                                            hintMaxLines: 1,
                                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                                        ),
                                                        style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                                        validator: (value) => value == null ? translator.translate('required') : null,
                                                       // iconSize: 40.0,
                                                        value: _selectedPackage,
                                                        isExpanded: true,
                                                        onChanged: (DropDownDataModel value) {
                                                          setState(() {
                                                            _selectedPackage = value;
                                                          });
                                                        },
                                                        items: packages.map((DropDownDataModel unitType) {
                                                          return  DropdownMenuItem<DropDownDataModel>(
                                                            value: unitType,
                                                            child:  Text(
                                                              (translator.currentLanguage == 'en')?  unitType.nameEn : unitType.nameAr,
                                                              style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45,fontFamily: FONT_FAMILY),
                                                            ),

                                                          );
                                                        }).toList(),
                                                      ) ,
                                                      if(_selectedPackage?.nameEn != 'Shipment' && _selectedPackage != null)    SizedBox(height:20.0),
                                                      if(_selectedPackage?.nameEn != 'Shipment' && _selectedPackage != null)   DropdownButtonFormField<DropDownDataModel>(
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: translator.translate('unitType'),
                                                            hintMaxLines: 1,
                                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                                        ),
                                                        style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                                        validator: (value) => value == null ? translator.translate('required') : null,
                                                       // iconSize: 40.0,
                                                        value: _selectedUnit,
                                                        isExpanded: true,
                                                        onChanged: (DropDownDataModel value) {
                                                          setState(() {
                                                            _selectedUnit = value;
                                                          });
                                                        },
                                                        items: unitTypes.map((DropDownDataModel unitType) {
                                                          return  DropdownMenuItem<DropDownDataModel>(
                                                            value: unitType,
                                                            child: Row(
                                                              children: <Widget>[
                                                                Text(
                                                                  (translator.currentLanguage == 'en')?  unitType.nameEn : unitType.nameAr,
                                                                  style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),) ,
                                                      SizedBox(height:20.0),
                                                      TextFormField(
                                                        decoration: InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          labelText: ( _selectedPackage?.nameEn != 'Shipment' && _selectedPackage != null) ?translator.translate('capacityPerUnit'): translator.translate('capacityPerTn'),
                                                          hintText: translator.translate('capacity'),
                                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                                        ),
                                                        style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                                        keyboardType: TextInputType.number,
                                                        controller: capacityController,
                                                        validator: validateCapacity,
                                                        onChanged: (String val) {
        //                                this.user?.email = emailController.text.toString();
                                                        },
                                                      ),
                                                      SizedBox(height:20.0),
                                                      TextFormField(
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: translator.translate('comment'),
                                                            hintText: '',
                                                            labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                                        ),
                                                        style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                                        keyboardType: TextInputType.text,
                                                        maxLines: 3,
                                                        controller: commentController,
                                                        validator: null,
                                                        onChanged: (String val) {
        //                                this.user?.email = emailController.text.toString();
                                                        },
                                                      ),
                                                    ]
                                                ),
                                              )
                                          ),
                                        ),
                              ],
                            ),
                          ),
                          SizedBox(height:20.0),
                         if (state is RequestFailedState)  Text('يوجد خطاء برجاء المحاوله مره ثانيه',style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: FONT_FAMILY)),
//                          Container(
//                            height: 50,
//                            width: 250,
//                            decoration: BoxDecoration(
//                                color: Colors.blue, borderRadius: BorderRadius
//                                .circular(20)),
//                            child: FlatButton(
//                              onPressed: () {
//                                if (!_formKey.currentState.validate()) {
//                                  return;
//                                }
//                                if (_formKey.currentState.validate()) {
//                                  setState(() {
//                                    _clicked = true;
//                                  });
//                                  this.request.numberOfTrucks = int.parse(truckNumberController.text);
//                                  this.request.pickUpDate = pickUpDate;
//                                  this.request.deliverDate = deliverDate;
//                                  this.request.sourceId = _selectedSource.id;
//                                  this.request.destinationId = _selectedDestination.id;
//                                  this.request.truckTypeId = _selectedTruckType.id;
//                                  this.request.productPackageId = _selectedPackage.id;
//                                  this.request.unitTypeId = (_selectedPackage?.nameEn != 'Shipment' && _selectedPackage != null) ? _selectedUnit?.id : null;
//                                  this.request.capacity = int.parse(capacityController.text);
//                                  this.request.accessories = accessoriesController.text;
//                                  this.request.comment = commentController.text;
//                                  print(this.request);
//                                  _bloc.add(SaveRequestEvent(this.request));
//                                  loadingAlertDialog(context);
//                                }
//
//                              },
//                              child: Text(
//                                'Save',
//                                style: TextStyle(color: Colors.white, fontSize: 25),
//                              ),
//                            ),
//                          ),
                        ])
                      );

                },
                listener: (context, state) {
                  if (state is RequestSuccessState) {
                   print(state.requestFormData.locations);
                   setState(() {
                     allLocations = state.requestFormData.locations;
                     sources = state.requestFormData.locations;
                     unitTypes = state.requestFormData.unitTypes;
                     packages = state.requestFormData.packages;
                     truckTypes = state.requestFormData.truckTypes;
                   });
                  }
                  if (state is RequestSaveState) {
                    Navigator.pop(context);
//                    Navigator.pushReplacementNamed(context, RequestListWidget.routeName);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, RequestListWidget.routeName);
//                    Navigator.of(context).pushNamedAndRemoveUntil(RequestListWidget.routeName, (Route<dynamic> route) => false);

                  }
                  if (state is RequestLoadingState ) loadingAlertDialog(context);
                  if (state is RequestSuccessState) Navigator.of(context).pop();

                }
        )
      ),
    );
  }
}
