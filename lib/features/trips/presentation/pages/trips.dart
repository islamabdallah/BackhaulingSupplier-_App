import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:haulerapp/features/share/loading-dialog.dart';
import 'package:haulerapp/features/trips/data/models/trip.dart';
import 'package:haulerapp/features/trips/data/models/trips.dart';
import 'package:haulerapp/features/trips/presentation/bloc/trip-bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/services/local_storage/local_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:haulerapp/features/trips/presentation/bloc/trip-events.dart';
import 'package:haulerapp/features/trips/presentation/bloc/trip-state.dart';

class TripsWidget extends StatefulWidget {
  static const routeName = 'TripsWidget';

  TripsWidgetState createState() => TripsWidgetState();
}

class TripsWidgetState extends State<TripsWidget> {
  TripBloc _bloc = TripBloc(BaseTripState());
//  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller;
  LatLng _center = LatLng(27.167928, 31.196732);
  LatLng _lastMapPosition =  LatLng(27.2134, 31.4456);
  MapType _currentMapType = MapType.normal;
  Position currentLocation;
  Map<String, String> _activeStatus = {"Key": '', "value": ""};
  Map<String, String> _deactiveStatus = {"Key": '', "value": ""};
  String _activeText = '';
  String _deactiveText = '';
  bool showActiveBtn = false;
  bool showDeactiveBtn = false;
  SharedPreferences prefs;
  LocalStorageService localStorage = LocalStorageService();
  int tripIndex = 0;
  bool _visible = false;
  BitmapDescriptor icon;
  Timer _timer;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

//  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = MAP_API_KEY;

  List<TripModel> allLocations = [];
  List<TripModel> noTrip = [];
  TripModel currentTrip = new TripModel();

  String all = '';
  String onTrip = '';
  PageController _pageController;
  int prevPage;
  bool showInfo = false;
  BitmapDescriptor bitmapDescriptorRed;
  BitmapDescriptor bitmapDescriptorGreen;
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  void _toggleBreak() {

  }

// Update the position on CameraMove
  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
//    pointsLatLng.add(_lastMapPosition);
  }

  getUserLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final _bitmapDescriptorGreen = await MarkerGenerator(200)
        .createBitmapDescriptorFromIconData(Icons.local_shipping, Colors.green, Colors.transparent, Colors.transparent);
    final _bitmapDescriptorRed = await MarkerGenerator(200)
        .createBitmapDescriptorFromIconData(Icons.local_shipping, Colors.red, Colors.transparent, Colors.transparent);
    _bloc.add(GetTripEvent());

    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      bitmapDescriptorRed = _bitmapDescriptorRed;
      bitmapDescriptorGreen = _bitmapDescriptorGreen;
    });
  }

  @override
  void initState() {
    getUserLocation();
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
    _timer = Timer.periodic(Duration(seconds: 1200), (timer) {
      _bloc.add(GetTripEvent());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _bloc.close();
    super.dispose();
  }
  void _onScroll() {

    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }
  moveCamera() {
    if(allLocations.isNotEmpty) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(allLocations[_pageController.page.toInt()].latitude,
              allLocations[_pageController.page.toInt()].longitude),
          zoom: 14.0,
          bearing: 45.0,
          tilt: 45.0)
      )
      );
    }
  }
  _launchCaller(phone) async {
    final url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget button(Function function, IconData icon, String tag) {
    return FloatingActionButton(
      heroTag: tag,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }
  Widget activeButton() {
    return SizedBox(
      height: 50.0,
//      width: MediaQuery.of(context).size.width / 2,
      child: new RaisedButton(
        elevation: 5.0,
        color: Colors.lightGreen,
        child: new AutoSizeText(_activeText,
            style: new TextStyle(
                fontFamily: FONT_FAMILY, fontSize: 12.0, color: Colors.white),
          maxLines: 1,),
        onPressed: () async {
          // Navigator.pushReplacementNamed(context, '/tabs');
//          prefs = await SharedPreferences.getInstance();

        },
      ),
    );
  }

  Widget callCard(String name, String tele, String text) {
    return  Card(
        elevation: 3,
        child: Container(
          color: Colors.black.withOpacity(0.70),
          height: 65.0,
//          padding: const EdgeInsets.all(2),
         child: ListTile(
            leading:  Icon(Icons.person_pin,size:50.0,  color: Colors.blue),
            title: Text( text,style: TextStyle(
                fontSize: 12,
                 fontWeight: FontWeight.w700,
                 fontFamily: FONT_FAMILY,
                 color: Colors.white
            )),
            subtitle: Text( name??'',style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: FONT_FAMILY,
                              color: Colors.white
                          ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
           isThreeLine: true,
           trailing: (tele != '' && tele != null)  ?  Icon(Icons.call, color: Colors.green, size: 30.0) : null,
           onTap: () {
             if(tele == null || tele == '') return;
                       _launchCaller(tele);
                       },

         ),
        )
    );
  }

  void choiceAction(TripModel choice) {
    print("chose: $choice");
//    markers.clear();
//    markers[MarkerId(choice.id.toString())] = Marker(
//      markerId: MarkerId(choice.id.toString()),
//      position:  LatLng(choice.latitude, choice.longitude),
//      infoWindow: InfoWindow(
//        title: choice.tripDestination,
//      ),
//      icon: BitmapDescriptor.defaultMarkerWithHue(
//          (choice.status != 'Idle') ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed
//      ),
//    );
   var index =   noTrip.indexWhere((element) => element.id  == choice.id);
//   print(index);
    _pageController.jumpToPage(index);
//    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//        target: LatLng(choice.latitude, choice.longitude),
//        zoom: 14.0,
//        bearing: 45.0,
//        tilt: 45.0,)
//    )
  //  );

//   setState(() {
//    markers =  markers;
//   });
  }
 void clrear() {
//   allLocations.forEach((element) {
//     print(element.id);
//     Marker marker = Marker(
//       markerId: MarkerId(element.id.toString()),
//       position:  LatLng(element.latitude, element.longitude),
//       infoWindow: InfoWindow(
//         title: element.tripDestination,
//           snippet: element.truckNumber
//
//       ),
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//           (element.status != 'Idle') ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed
//       ),
//     );
//     markers[MarkerId(element.id.toString())] = marker;
//
//   });
//   setState(() {
//      markers = markers;
//      _center = _center;
//
//    });
   _pageController.jumpToPage(0);
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _center,
        zoom: 6.3,
        bearing: 45.0,
        tilt: 45.0,)
    )
     );
  }


  _coffeeShopList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
           //  moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: (translator.currentLanguage == 'en' ) ? BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)) : BorderRadius.only(
                                      bottomRight: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: allLocations[index].imageUrl.isNotEmpty ? NetworkImage( allLocations[index].imageUrl) :  AssetImage('assets/images/bg1.jpg'),
                                      fit: BoxFit.cover)
                              )),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allLocations[index].tripDestination,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  allLocations[index].driver.name,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    allLocations[index].truckNumber,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }
  @override
  Widget  build(BuildContext context) {
  var  screenWidth = MediaQuery.of(context).size.width;
  var  screenHeight = MediaQuery.of(context).size.height;

    // TODO: implement  build
    return  Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('truckMap'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),

        centerTitle: true,
      ),
      backgroundColor: Colors.white,
        body: Container(
          child: BlocConsumer(
                cubit: _bloc,
                builder: (context, state) {
//        child: Stack(
                  return Stack(
                    children: <Widget>[
                      Container(
//        child: Stack(
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 6.2,
                            ),
                            mapType: _currentMapType,

//                            onCameraMove: _onCameraMove,
                            myLocationEnabled: true,
                            tiltGesturesEnabled: true,
                            compassEnabled: true,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            markers: Set<Marker>.of(markers.values),
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(() =>
                                  PanGestureRecognizer()))..add(
                                  Factory<ScaleGestureRecognizer>(() =>
                                      ScaleGestureRecognizer()))..add(
                                  Factory<TapGestureRecognizer>(() =>
                                      TapGestureRecognizer()))..add(
                                  Factory<VerticalDragGestureRecognizer>(() =>
                                      VerticalDragGestureRecognizer()))..add(
                                  Factory<HorizontalDragGestureRecognizer>(() =>
                                      HorizontalDragGestureRecognizer())),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.all(10),
                        height: 100,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(

                                children: <Widget>[
                                  Container(
                                      padding:
                                      EdgeInsets.only(top: 10, bottom: 5),
                                      child: Text(translator.translate('all'),
                                          style: TextStyle(
                                              color: Colors.black54))),
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text(all,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16))),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: <Widget>[
                                  Container(
                                      padding:
                                      EdgeInsets.only(top: 10, bottom: 5),
                                      child: Text(translator.translate('onTrip'),
                                          style: TextStyle(
                                              color: Colors.black54))),
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text(onTrip,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16))),
                                ],
                              ),
//                              Column(
//                                children: <Widget>[
//                                  Row(
//                                      children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 10, bottom: 5),
                                      child:  PopupMenuButton<TripModel>(
                                        icon: Icon(Icons.filter_list),
                                        onSelected: choiceAction,
                                        itemBuilder: (BuildContext context) {
                                          return noTrip.map((TripModel loc) {
                                            return PopupMenuItem<TripModel>(
                                              value: loc,
                                              child: Text(loc.tripDestination),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, bottom: 5),
                                      child:  IconButton(
                                        icon: Icon(Icons.cached),
                                        onPressed: clrear,

                                      ),
                                    ),
//                                  ])
//
//                                ],
//                              ),

                            ],
                          ),
                        ),
                      ),
                    if(showInfo) InkWell(
                          onTap: () {
                            showInfo = !showInfo;
                            setState(() {});
                          },
                          child: Align(
                            alignment:Alignment.bottomCenter,
                            child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 20.0,
                            ),
                            height: 120.0,
                             width: MediaQuery.of(context).size.width -40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    offset: Offset(0.0, 4.0),
                                    blurRadius: 10.0,
                                  ),
                                ]),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white),
                                child: Row(children: [
                                  Container(
                                      height: 130.0,
                                      width: 130.0,
                                      decoration: BoxDecoration(
                                          borderRadius: (translator.currentLanguage == 'en' ) ? BorderRadius.only(
                                              bottomLeft: Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0)) : BorderRadius.only(
                                              bottomRight: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0)),
                                          image: DecorationImage(
                                              image: currentTrip.imageUrl.isNotEmpty ? NetworkImage( currentTrip.imageUrl) :  AssetImage('assets/images/bg1.jpg'),
                                              fit: BoxFit.cover)
                                      )),
                                  SizedBox(width: 5.0),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentTrip.tripDestination,
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          currentTrip.driver.name,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          width: 170.0,
                                          child: Text(
                                            currentTrip.truckNumber,
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      ])
                                ])))),),
                      if(!showInfo) Positioned(
                        bottom: 20.0,
                        child: Container(
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: allLocations.length,
                            itemBuilder: (BuildContext context, int index) {
//                              final item = allLocations[index];
                              return _coffeeShopList(index);
                            },
                          ),
                        ),
                      )
                    ],
                  );
                }, listener: (context, state) {
            if (state is TripSuccessState) {
              print(state.trips.data);
               markers.clear();
               noTrip = state.trips.data.where((e) => e.status != 'Idle').toList();
              state.trips.data.forEach((element) {
                  Marker marker = Marker(
                    markerId: MarkerId(element.id.toString()),
                    position: LatLng(element.latitude, element.longitude),
                    infoWindow: InfoWindow(
                        title: element.tripDestination,
                        snippet: element.truckNumber
                    ),
                    icon: (element.status != 'Idle')? bitmapDescriptorGreen : bitmapDescriptorRed,
                    onTap: () {
                      //  _pageController.jumpToPage(state.trips.data.indexOf(element));
                      currentTrip = element;
                      showInfo = !showInfo;
                      setState(() {});
                    },
                  );
                  markers[MarkerId(element.id.toString())] = marker;

              });
              setState(() {
                allLocations = state.trips.data;
                all = state.trips.data.length.toString();
                noTrip = noTrip;
                onTrip = noTrip.length.toString();
                markers = markers;
              });
            }
            if (state is TripLoadingState ) loadingAlertDialog(context);
            if (state is TripSuccessState) Navigator.of(context).pop();

          })
      ),
    );

  }


  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
//    PolylineId id = PolylineId("poly");
//    Polyline polyline = Polyline(
//        polylineId: id, color: Colors.red, points: polylineCoordinates,width: 5);
//    polylines[id] = polyline;
//    setState(() {});
  }

//  _getPolyline() async {
//
////    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
////        googleAPiKey,
////        PointLatLng(double.parse(trip.srcLat) , double.parse(trip.srcLong)),
////        PointLatLng(double.parse(trip.destLat), double.parse(trip.destLong)),
////        travelMode: TravelMode.driving,);
////    if (result.points.isNotEmpty) {
////      result.points.forEach((PointLatLng point) {
////        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
////      });
////    }
//    _addPolyLine();
//  }
}

class MarkerGenerator {
  final double _markerSize;
  double _circleStrokeWidth;
  double _circleOffset;
  double _outlineCircleWidth;
  double _fillCircleWidth;
  double _iconSize;
  double _iconOffset;

  MarkerGenerator(this._markerSize) {
    // calculate marker dimensions
    _circleStrokeWidth = _markerSize / 10.0;
    _circleOffset = _markerSize / 2;
    _outlineCircleWidth = _circleOffset - (_circleStrokeWidth / 2);
    _fillCircleWidth = _markerSize / 2;
    final outlineCircleInnerWidth = _markerSize - (2 * _circleStrokeWidth);
    _iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
    final rectDiagonal = sqrt(2 * pow(_markerSize, 2));
    final circleDistanceToCorners = (rectDiagonal - outlineCircleInnerWidth) / 2;
    _iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);
  }

  /// Creates a BitmapDescriptor from an IconData
  Future<BitmapDescriptor> createBitmapDescriptorFromIconData(
      IconData iconData, Color iconColor, Color circleColor, Color backgroundColor) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintCircleFill(canvas, backgroundColor);
    _paintCircleStroke(canvas, circleColor);
    _paintIcon(canvas, iconColor, iconData);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(_markerSize.round(), _markerSize.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  /// Paints the icon background
  void _paintCircleFill(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(Offset(_circleOffset, _circleOffset), _fillCircleWidth, paint);
  }

  /// Paints a circle around the icon
  void _paintCircleStroke(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = _circleStrokeWidth;
    canvas.drawCircle(Offset(_circleOffset, _circleOffset), _outlineCircleWidth, paint);
  }

  /// Paints the icon
  void _paintIcon(Canvas canvas, Color color, IconData iconData) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: _iconSize,
          fontFamily: iconData.fontFamily,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset(_iconOffset, _iconOffset));
  }
}
