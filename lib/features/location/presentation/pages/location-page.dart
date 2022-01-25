import 'dart:ui';
import 'package:haulerapp/features/location/data/models/area-data.dart';
import 'package:haulerapp/features/location/data/models/location-request.dart';
import 'package:haulerapp/features/location/presentation/bloc/add-location-bloc.dart';
import 'package:haulerapp/features/location/presentation/bloc/add-location-events.dart';
import 'package:haulerapp/features/location/presentation/bloc/add-location-state.dart';
import 'package:haulerapp/features/locationList/presentation/pages/locations-page.dart';
import 'package:haulerapp/features/share/loading-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haulerapp/core/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:geocoder/geocoder.dart';

class LocationWidget extends StatefulWidget {
  static const routeName = 'LocationWidget';

  LocationWidgetState createState() => LocationWidgetState();
}

class LocationWidgetState extends State<LocationWidget> {
  AddLocationBloc _bloc = AddLocationBloc(BaseLocationState());
  Governorate _selectedGov;
  City _selectedCity;

  TextEditingController nameController = TextEditingController();
  TextEditingController detailedAddressController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

//  List<AreaDataModel>  allLocations = [];
  List<Governorate>  gov = [];
  List<City>  cities = [];
  List<City>  allcCities = [];

  LocationRequestModel request = new LocationRequestModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller;
  LatLng _center = LatLng(27.167928, 31.196732);
  LatLng _lastMapPosition =  LatLng(27.2134, 31.4456);
  MapType _currentMapType = MapType.normal;
  Position currentLocation;
  Map<MarkerId, Marker> markers = {};
  double Longitude = 27.167928;
  double Latitude = 31.196732;

  bool _clicked = false;
  bool _visible = false;
  @override
  void initState() {
    _bloc.add(GetAreaDataEvent());
    getUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }
//  moveCamera() {
////    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
////        target: LatLng(),
////        zoom: 14.0,
////        bearing: 45.0,
////        tilt: 45.0)
////    )
////    );
//  }
  moveCamera(latitude, longitude) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)
    )
    );
  }
  addMarker(latitude,longitude){
    markers.clear();
    Marker marker = Marker(
        onTap: () {
          print('Tapped');
        },
        draggable: true,
        markerId: MarkerId('Marker'),
        position: LatLng(latitude, longitude),
        onDragEnd: ((newPosition) {
          Longitude = newPosition.longitude;
          Latitude = newPosition.latitude;
        }));

    setState(() {
      _center = LatLng(latitude, longitude);
      markers[ MarkerId('Marker')] = marker;

    });

  }
  getUserLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    addMarker(currentLocation.latitude, currentLocation.longitude);
  }

  getAddress() async {
    var results = await Geocoder.google(MAP_API_KEY).findAddressesFromCoordinates(new Coordinates(Latitude, Longitude));
    this.request.mapAddress =  results.first.addressLine == null ? this.request.detailedAddress : results.first.addressLine;

  }

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
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
        title: Text(translator.translate('addLocation'),style: TextStyle(fontFamily: FONT_FAMILY)),
         centerTitle: true,
      ),
     backgroundColor: Colors.white,
      body:SingleChildScrollView(
    child:  Container(
        child: BlocConsumer(
                cubit: _bloc,
                builder: (context, state) {
//                  if (state is LocationFailedState) {
//                    if (_clicked) {
//                      _clicked = false;
//                      Navigator.pop(context);
//                    }
//                  }
                  return  Container(
                      child: Stack(
                  children: <Widget>[
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                           Padding(
                            padding: const EdgeInsets.only(left:15.0,right: 15.0,top:30,bottom: 10),
                            child: Form(
                              key: _formKey,
//                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child:FormField(
                              builder: (FormFieldState state) {
                                return Container(
                                  child:Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: translator.translate('name'),
                                              labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                          ),
                                          style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                          keyboardType: TextInputType.text,
                                          controller: nameController,
                                          validator: (value) => value.isEmpty ? translator.translate('required') : null,
                                          onChanged: (String val) {},
                                        ),
                                        SizedBox(height:10.0),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: translator.translate('contactName'),
                                              labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                          ),
                                          style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                          keyboardType: TextInputType.text,
                                          controller: contactNameController,
                                          validator: (value) => value.isEmpty ? translator.translate('required') : null,
                                          onChanged: (String val) {
                                          },
                                        ),
                                        SizedBox(height:10.0),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: translator.translate('contactPhone'),
                                              labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                          ),
                                          style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          controller: contactNumberController,
                                          validator: (value) {
                                            return RegExp(r'^01(0|1|2|5){1}[0-9]{8}$').hasMatch(value) ? null :  translator.translate('required') ;

                                          },
                                          onChanged: (String val) {
                                          },
                                        ),
                                        SizedBox(height:10.0),
                                        Row(children: [
                                          Expanded( flex: 1,
                                            child:DropdownButtonFormField<Governorate>(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: translator.translate('gov'),
                                                  hintMaxLines: 1,
                                                  labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                              ),
                                              style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                              validator: (value) => value == null ? translator.translate('required') : null,
                                              // iconSize: 40.0,
                                              value: _selectedGov,
                                              isExpanded: true,
                                              onChanged: (Governorate value) {
                                                // var _cities =  allcCities.where((element) => element.governorateId == value.id).toList();
                                                setState(() {
                                                  _selectedGov = value;
                                                  cities = value.cities;
                                                  _selectedCity = null;
                                                  Longitude = value.longitude;
                                                  Latitude = value.latitude;
//                                                  addMarker(value.latitude, value.longitude);
                                                  MarkerId id = MarkerId('Marker'); //uid of the marker I want to update
                                                  markers[id]= markers[id].copyWith(positionParam:LatLng(value.latitude,value.longitude));
                                                  moveCamera(value.latitude, value.longitude);
                                                });
                                              },
                                              items: gov.map((Governorate source) {
                                                return  DropdownMenuItem<Governorate>(
                                                  value: source,
                                                  child: Text(
                                                    translator.currentLanguage == 'en' ? source.nameEn : source.nameAr , overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
                                                  ),
                                                );
                                              }).toList(),) ,
                                          ),
                                          SizedBox(width:10.0),
                                          Expanded( flex: 1,
                                            child:DropdownButtonFormField<City>(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: translator.translate('city'),
                                                  hintMaxLines: 1,
                                                  labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                              ),
                                              style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                              validator: (value) => value == null ? translator.translate('required') : null,
                                              //  iconSize: 40.0,
                                              value: _selectedCity,
                                              isExpanded: true,
                                              onChanged: (City value) {
                                                setState(() {
                                                  _selectedCity = value;
                                                  Longitude = value.longitude;
                                                  Latitude = value.latitude;
                                                  addMarker(value.latitude, value.longitude);
                                                  moveCamera(value.latitude, value.longitude);
                                                });
                                              },
                                              items: cities.map((City dest) {
                                                return  DropdownMenuItem<City>(
                                                  value: dest,
                                                  child:Text(
                                                    translator.currentLanguage == 'en' ?  dest.nameEn : dest.nameAr , overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: true,
                                                    style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
                                                  ),
                                                );
                                              }).toList(),) ,
                                          ),
                                        ],),
                                        SizedBox(height:10.0),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: translator.translate('address'),
                                              labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
                                          ),
                                          style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
                                          keyboardType: TextInputType.text,
                                          controller: detailedAddressController,
                                          validator: (value) => value.isEmpty ? translator.translate('required') : null,
                                          onChanged: (String val) {
                                            //                                this.user?.email = emailController.text.toString();
                                          },
                                        ),
                                        //  TextButton(onPressed: _toggle, child: Text('view Map')),
                                        SizedBox(height:10.0),

                                        Container(
                                          alignment: Alignment.topCenter,
                                          height: 260.0,
                                          child: Card(
                                            elevation: 5.0,
                                            child: Stack(
                                              children: [
                                                GoogleMap(
                                                  onMapCreated: _onMapCreated,
                                                  initialCameraPosition: CameraPosition(
                                                    target: _center,
                                                    zoom: 8.0,
                                                  ),
                                                  mapType: _currentMapType,
                                                  myLocationEnabled: true,
                                                  tiltGesturesEnabled: true,
                                                  compassEnabled: true,
                                                  rotateGesturesEnabled: true,
                                                  scrollGesturesEnabled: true,
                                                  zoomGesturesEnabled: true,
                                                  markers:  Set<Marker>.of(markers.values),
//
                                                  gestureRecognizers: Set()
                                                    ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                                                    ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
//                                                      ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                                                    ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
                                                    ..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer())),
                                                ),

                                              ],
                                            ),
                                          ) ,
                                        )
                                      ]
                                  ),
                                );
                              },),
//                            Form(
//                                          key: _formKey,
//                                          autovalidateMode: AutovalidateMode.,
//                                          child:Column(
//                                        mainAxisSize: MainAxisSize.min,
//                                        mainAxisAlignment: MainAxisAlignment.start,
//                                        children: <Widget>[
//                                          TextFormField(
//                                            decoration: InputDecoration(
//                                                border: OutlineInputBorder(),
//                                                labelText: translator.translate('name'),
//                                                labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
//                                            ),
//                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
//                                            keyboardType: TextInputType.text,
//                                            controller: nameController,
//                                            validator: (value) => value == null ? translator.translate('required') : null,
//                                            onChanged: (String val) {
//                                              //                                this.user?.email = emailController.text.toString();
//                                            },
//                                          ),
//                                          SizedBox(height:10.0),
//                                          TextFormField(
//                                            decoration: InputDecoration(
//                                                border: OutlineInputBorder(),
//                                                labelText: translator.translate('contactName'),
//                                                labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
//                                            ),
//                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
//                                            keyboardType: TextInputType.text,
//                                            controller: contactNameController,
//                                                  validator:(value) => value == null ? translator.translate('required') : null,
//                                            onChanged: (String val) {
//                                              //                                this.user?.email = emailController.text.toString();
//                                            },
//                                          ),
//                                          SizedBox(height:10.0),
//                                          TextFormField(
//                                            decoration: InputDecoration(
//                                                border: OutlineInputBorder(),
//                                                labelText: translator.translate('contactPhone'),
//                                                labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
//                                            ),
//                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
//                                            keyboardType: TextInputType.number,
//                                            inputFormatters: <TextInputFormatter>[
//                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                                            ],
//                                            controller: contactNumberController,
//                                            validator: (value) {
//                                              return RegExp(r'^01(0|1|2|5){1}[0-9]{8}$').hasMatch(value) ? null :  translator.translate('required') ;
//
//                                            },
//                                            onChanged: (String val) {
//                                              //                                this.user?.email = emailController.text.toString();
//                                            },
//                                          ),
//                                          SizedBox(height:10.0),
//                                          Row(children: [
//                                            Expanded( flex: 1,
//                                              child:DropdownButtonFormField<Governorate>(
//                                              decoration: InputDecoration(
//                                                  border: OutlineInputBorder(),
//                                                  labelText: translator.translate('gov'),
//                                                  hintMaxLines: 1,
//                                                  labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
//                                              ),
//                                              style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
//                                              validator: (value) => value == null ? translator.translate('required') : null,
//                                              // iconSize: 40.0,
//                                              value: _selectedGov,
//                                              isExpanded: true,
//                                              onChanged: (Governorate value) {
//                                               // var _cities =  allcCities.where((element) => element.governorateId == value.id).toList();
//                                                setState(() {
//                                                  _selectedGov = value;
//                                                  cities = value.cities;
//                                                  _selectedCity = null;
//                                                  Longitude = value.longitude;
//                                                  Latitude = value.latitude;
////                                                  addMarker(value.latitude, value.longitude);
//                                                  MarkerId id = MarkerId('Marker'); //uid of the marker I want to update
//                                                  markers[id]= markers[id].copyWith(positionParam:LatLng(value.latitude,value.longitude));
//                                                  moveCamera(value.latitude, value.longitude);
//                                                });
//                                              },
//                                              items: gov.map((Governorate source) {
//                                                return  DropdownMenuItem<Governorate>(
//                                                  value: source,
//                                                  child: Text(
//                                                    source.nameEn, overflow: TextOverflow.ellipsis,
//                                                    maxLines: 1,
//                                                    style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
//                                                  ),
//                                                );
//                                              }).toList(),) ,
//                                            ),
//                                            SizedBox(width:10.0),
//                                            Expanded( flex: 1,
//                                              child:DropdownButtonFormField<City>(
//                                              decoration: InputDecoration(
//                                                  border: OutlineInputBorder(),
//                                                  labelText: translator.translate('city'),
//                                                  hintMaxLines: 1,
//                                                  labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
//                                              ),
//                                              style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
//                                              validator: (value) => value == null ? translator.translate('required') : null,
//                                              //  iconSize: 40.0,
//                                              value: _selectedCity,
//                                              isExpanded: true,
//                                              onChanged: (City value) {
//                                                setState(() {
//                                                  _selectedCity = value;
//                                                  Longitude = value.longitude;
//                                                  Latitude = value.latitude;
//                                                  addMarker(value.latitude, value.longitude);
//                                                  moveCamera(value.latitude, value.longitude);
//                                                });
//                                              },
//                                              items: cities.map((City dest) {
//                                                return  DropdownMenuItem<City>(
//                                                  value: dest,
//                                                  child:Text(
//                                                    dest.nameEn, overflow: TextOverflow.ellipsis,
//                                                    maxLines: 1,
//                                                    softWrap: true,
//                                                    style:  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontFamily: FONT_FAMILY),
//                                                  ),
//                                                );
//                                              }).toList(),) ,
//                                            ),
//                                          ],),
//                                          SizedBox(height:10.0),
//                                          TextFormField(
//                                            decoration: InputDecoration(
//                                                border: OutlineInputBorder(),
//                                                labelText: translator.translate('address'),
//                                                labelStyle: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600)
//                                            ),
//                                            style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400, color: Colors.black45),
//                                            keyboardType: TextInputType.text,
//                                            controller: detailedAddressController,
//                                            validator: (value) => value == null ? translator.translate('required') : null,
//                                            onChanged: (String val) {
//                                              //                                this.user?.email = emailController.text.toString();
//                                            },
//                                          ),
//                                        //  TextButton(onPressed: _toggle, child: Text('view Map')),
//                                          SizedBox(height:10.0),
//
//                                          Container(
//                                            alignment: Alignment.topCenter,
//                                            height: 260.0,
//                                            child: Card(
//                                              elevation: 5.0,
//                                              child: Stack(
//                                                children: [
//                                                  GoogleMap(
//                                                    onMapCreated: _onMapCreated,
//                                                    initialCameraPosition: CameraPosition(
//                                                      target: _center,
//                                                      zoom: 8.0,
//                                                    ),
//                                                    mapType: _currentMapType,
//                                                    myLocationEnabled: true,
//                                                    tiltGesturesEnabled: true,
//                                                    compassEnabled: true,
//                                                    rotateGesturesEnabled: true,
//                                                    scrollGesturesEnabled: true,
//                                                    zoomGesturesEnabled: true,
//                                                    markers:  Set<Marker>.of(markers.values),
////
//                                                    gestureRecognizers: Set()
//                                                      ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
//                                                      ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
////                                                      ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
//                                                      ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
//                                                      ..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer())),
//                                                  ),
//
//                                                ],
//                                              ),
//                                            ) ,
//                                          )
//                                        ]
//                                          ),
//                            )
                            ),
                           ),
                          SizedBox(height:10.0),
                         if (state is LocationFailedState)   Padding(
                             padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5, bottom: 5),
                             child:Align(child: Text(state.error.message,
                               style: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),),
                               alignment: Alignment.centerRight,
                             )),
                          Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 30.0,
                              decoration: BoxDecoration( color: Colors.blue, borderRadius: BorderRadius.circular(5),),
                              child: FlatButton(
                                onPressed: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                if (_formKey.currentState.validate()) {
//                                  setState(() {
//                                    _clicked = true;
//                                  });
                                  this.request.name = nameController.text;
                                  this.request.contactName = contactNameController.text;
                                  this.request.contactNumber = contactNumberController.text;
                                  this.request.governorate = _selectedGov.nameEn;
                                  this.request.city = _selectedCity.nameEn;
                                  this.request.detailedAddress = detailedAddressController.text;
                                  this.request.latitude = Latitude;
                                  this.request.longitude = Longitude;
                                    await getAddress();
                                  print(this.request);
                                  _bloc.add(SaveLocationEvent(this.request));
                                }

                              },
                              child: Text(translator.translate('saveLocation'),
                                style: TextStyle(color: Colors.white,  fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(height:10.0),

                        ]),
                    Visibility (
                      visible: _visible,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child:
                          Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.all(4.0),
                            height: 260.0,
                            child: Card(
                              elevation: 5.0,
                              margin: EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: _center,
                                      zoom: 8.0,
                                    ),
                                    mapType: _currentMapType,
//                                    onCameraMove: _onCameraMove,
                                    myLocationEnabled: true,
                                    tiltGesturesEnabled: true,
                                    compassEnabled: true,
                                    rotateGesturesEnabled: true,
                                    scrollGesturesEnabled: true,
                                    zoomGesturesEnabled: true,
                                    markers: Set<Marker>.of(markers.values),
                                    gestureRecognizers: Set()
                                      ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                                      ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                                      ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                                      ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
                                      ..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer())),
                                  ),

                                ],
                              ),
                            ) ,
                          )
                      ),
                    ),
                  ])
                      );

                },
                listener: (context, state) {
                  if (state is LocationSuccessState) {
                   print(state.requestFormData);
                   setState(() {
                     gov = state.requestFormData.governorates;
                     allcCities  = state.requestFormData.cities;
                   });
                  }
                  if (state is LocationSaveState) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, LocationsWidget.routeName);
                  }
                  if (state is LocationLoadingState ) loadingAlertDialog(context);
                  if (state is LocationSuccessState) Navigator.of(context).pop();
                  if (state is LocationFailedState) Navigator.of(context).pop();


                }
        )
      ),
    )
    );
  }
}
