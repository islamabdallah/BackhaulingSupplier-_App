import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:haulerapp/features/location/presentation/pages/location-page.dart';
import 'package:haulerapp/features/locationList/data/models/truck.dart';
import 'package:haulerapp/features/locationList/presentation/bloc/locations-bloc.dart';
import 'package:haulerapp/features/locationList/presentation/bloc/locations-events.dart';
import 'package:haulerapp/features/locationList/presentation/bloc/locations-state.dart';
import 'package:haulerapp/features/request/data/models/location.dart';
import 'package:haulerapp/features/share/loading-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haulerapp/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haulerapp/features/trips/data/models/trip.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../home.dart';

class LocationsWidget extends StatefulWidget {
  static const routeName = 'LocationsWidget';

  LocationsWidgetState createState() => LocationsWidgetState();
}

class LocationsWidgetState extends State<LocationsWidget> {
  LocationsBloc _bloc = LocationsBloc(BaseLocationsState());
  final AppBarController appBarController = AppBarController();
  List<Truck>  locations = [];
//  List<LocationModel>  allLocations = [];
  List<Truck> allLocations = [];

//  List<LocationModel> activeLocations = [];
//  List<LocationModel>  notActiveLocations = [];

  final List<Truck> dataList = <Truck>[];
  List<Truck> currentDataList = <Truck>[];
  int page = 1;
  int pageCount = 5;
  int startAt = 0;
  int endAt;
  int totalPages = 0;
  bool active = false;
  bool notActive = false;
  bool all = true;



  @override
  void initState() {
    _bloc.add(GetLocationsDataEvent());
    super.initState();
  }

  activeTapButton({bool allBtn, bool activeBtn, bool notActiveBtn,}) {
    dataList.clear();
    var data;
    if(allBtn) {
       data = allLocations;
    }
//    else if (activeBtn) {
//       data = activeLocations;
//    } else if (notActiveBtn) {
//       data = notActiveLocations;
//    }
    setState(() {
      active = activeBtn;
       notActive = notActiveBtn;
       all = allBtn;
      dataList.addAll(data);
      pageInfo(reload: true);
    });
  }
  void searchValue(String value) {
    print("clear");
    print(value);

    dataList.clear();
    var data = (value != '') ? locations.where((element) =>
        element.toJson().values.any((x) => x.toString().toLowerCase().contains(value.toLowerCase()))) : locations;
    print(data);
    setState(() {
      allLocations = data.toList();
//      activeLocations = data.where((element) => element.active == true ).toList();
//      notActiveLocations = data.where((element) => element.active != true ).toList();
      activeTapButton(allBtn: true, activeBtn: false, notActiveBtn: false);
      dataList.addAll(data);
      pageInfo(reload: true);
      });

  }
  void pageInfo({bool reload}) {
    if (reload == true) {
       page = 1;
       pageCount = 5;
       startAt = 0;
       totalPages = 0;
    }
  endAt = startAt + pageCount;
  totalPages = (dataList.length / pageCount).floor();
  if (dataList.length / pageCount > totalPages) {
    totalPages = totalPages + 1;
  }

  var dataLength =  dataList.length;
  if(endAt > dataLength) endAt = dataLength;
  currentDataList = dataList.getRange(startAt, endAt).toList();
}
  void loadPreviousPage() {
    if (page > 1) {
      setState(() {
        startAt = startAt - pageCount;
        endAt = page == totalPages
            ? endAt - currentDataList.length
            : endAt - pageCount;
        currentDataList = dataList.getRange(startAt, endAt).toList();
        page = page - 1;
      });
    }
  }
  void loadNextPage() {
    if (page < totalPages) {
      setState(() {
        startAt = startAt + pageCount;
        endAt = dataList.length > endAt + pageCount ? endAt + pageCount : dataList.length;
        currentDataList = dataList.getRange(startAt, endAt).toList();
        page = page + 1;
      });
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  _launchCaller(phone) async {
    final url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildMessageList(Truck item) => Card(
      elevation: 4,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 3.0),
          child: Row(
    children: [
      Container(
          height: 90.0,
          width: 90.0,
          decoration: BoxDecoration(
              borderRadius: (translator.currentLanguage == 'en' ) ? BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  topLeft: Radius.circular(5.0)) : BorderRadius.only(
                  bottomRight: Radius.circular(5.0),
                  topRight: Radius.circular(5.0)),
              image: DecorationImage(
                  image: item.imageUrl.isNotEmpty ? NetworkImage( item.imageUrl) :  AssetImage('assets/images/bg1.jpg'),
                  fit: BoxFit.cover)
          )
      ),
      SizedBox(width:10.0),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${item.sapTruckNumber}',
                    style:  TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,),
                ),
                Icon(Icons.label_important ,color: Colors.blue,size: 20,),
                Text('${item.category}',)
              ],
            ),
            SizedBox(height:2.0),
            Text('${item.driverName}',style:  TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height:2.0),
            Row(
              children: [
                Expanded(
                  child: Text('${item.type}',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                Text('${item.lastUpdate}',)
              ],
            )
          ],
        ),
      )
    ],
  )));


  @override
  Widget  build(BuildContext context) {
    // TODO: implement  build
    return Scaffold(
      appBar:  SearchAppBar(
          primary: Theme.of(context).primaryColor,
          appBarController: appBarController,
    // You could load the bar with search already active
    autoSelected: false,
    searchHint: translator.translate('search'),
    mainTextColor: Colors.white,
    onChange: (String value) => searchValue(value),
    //Will show when SEARCH MODE wasn't active
    mainAppBar: AppBar(
      title: Text(translator.translate('trucksHeader'),style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400)),
      centerTitle: true,
      actions: <Widget>[
        InkWell(
          child: Icon(Icons.search,),
          onTap: () {
            //This is where You change to SEARCH MODE. To hide, just
            //add FALSE as value on the stream
          //  activeTapButton(activeBtn: false,allBtn: true,notActiveBtn: false);

            appBarController.stream.add(true);
            },
        ),
      ],
    )
      ),
//     backgroundColor: Colors.white,

      body: Container(
          child: BlocConsumer(
           cubit: _bloc,
               builder: (context, state) {
             return (currentDataList.isNotEmpty) ?
             Column(
      children: <Widget>[
        Expanded(
            child:Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                itemBuilder: (ctx, index) {
              final item = currentDataList[index];
              return buildMessageList(item);
//                Container(
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(10.0),
//                    color: Colors.white),
//                child:
//                    Card(
//                        elevation: 4,
//                        child: Container(
//                    padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Container(
//
//                            child: Row(children: [
//                              Container(
//                                  height: 90.0,
//                                  width: 90.0,
//                                  decoration: BoxDecoration(
//                                      borderRadius: (translator.currentLanguage == 'en' ) ? BorderRadius.only(
//                                          bottomLeft: Radius.circular(10.0),
//                                          topLeft: Radius.circular(10.0)) : BorderRadius.only(
//                                          bottomRight: Radius.circular(10.0),
//                                          topRight: Radius.circular(10.0)),
//                                      image: DecorationImage(
//                                          image: item.imageUrl.isNotEmpty ? NetworkImage( item.imageUrl) :  AssetImage('assets/images/bg1.jpg'),
//                                          fit: BoxFit.cover)
//                                  )
//                              ),
//                              SizedBox(width: 5.0),
//                              Column(
//                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: [
//                                    Text(
//                                      item.sapTruckNumber,
//                                      style: TextStyle(
//                                          fontSize: 12.5,
//                                          fontWeight: FontWeight.bold),
//                                    ),
//                                    Text(
//                                      item.lastUpdate,
//                                      style: TextStyle(
//                                          fontSize: 12.0,
//                                          fontWeight: FontWeight.w600),
//                                    ),
//                                    Container(
//                                      width: 170.0,
//                                      child: Text('${item.driverName}',style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,),
//                                        overflow: TextOverflow.ellipsis,
//                                        maxLines: 2,
//                                      ),
//                                    )
//                                  ])
//                            ]))
//                      ]))),
//
//
//
//
//
//
//
//
//
//
//
//                //            Card(
////              elevation: 4,
////              margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
////              child: Container(
////                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
////                  child: Column(
////                    crossAxisAlignment: CrossAxisAlignment.start,
////                    children: [
////                      Row(
////                          mainAxisAlignment: MainAxisAlignment.start,
////                          children: [
////                            Expanded(
////                              flex:1,
////                              child:
////                              Text('${item.name}',style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,),
////                                overflow: TextOverflow.ellipsis,
////                                maxLines: 2,
////                              ),
////                            ),
////                            SizedBox(width: 5,),
//////                            Align(
//////                              child:
////                              Container(
////                                alignment: AlignmentDirectional.topEnd,
////                                width: 90,
////                                height: 30,
////                                child: (item.active) ? RichText(
////                                  text: TextSpan(
////                                    style: TextStyle(color: Colors.green),
////                                    children: [
////                                      TextSpan(
////                                        text:  translator.translate('active'),
////                                      ),
////                                      WidgetSpan(
////                                        child: Icon(Icons.done_all ,color: Colors.green,size: 20,),
////                                      ),
////                                    ],
////                                  ),
////                                ) : RichText(
////                                  text: TextSpan(
////                                    style: TextStyle(color: Colors.red,
////                                        fontSize: 14.0),
////                                    children: [
////                                      TextSpan(
////                                        text: translator.translate('notActive'),
////                                      ),
////                                      WidgetSpan(
////                                        child:  Icon(Icons.block ,color: Colors.red,size: 20,),
////                                      ),
////                                    ],
////                                  ),
////                                ),
////                              ) ,
//////                              alignment:(translator.currentLanguage == 'en' ) ?  Alignment.topRight :  Alignment.topLeft,
//////                            )
////                          ]
////                      ),
////                      Row(
////                          mainAxisAlignment: MainAxisAlignment.start,
////                          children: [
////                            Icon(Icons.home,color: Colors.grey,size: 25,),
////                            SizedBox(width: 5,),
////                            Text('${item.governorate} - ${item.city}',style: TextStyle(fontFamily: FONT_FAMILY)),
////                          ]
////                      ),
////                      SizedBox(height: 3,),
////                      Row(
////                          mainAxisAlignment: MainAxisAlignment.start,
////                          children: [
////                            Icon(Icons.place,color: Colors.orange,size: 25,),
////                            SizedBox(width: 5,),
////                            Text('${item.detailedAddress}',style: TextStyle(fontFamily: FONT_FAMILY)),
////                          ]
////                      ),
////                      SizedBox(height: 3,),
////                  Row( mainAxisAlignment: MainAxisAlignment.start,
////                    children: [
////                      Expanded(
////                          flex:2,
////                          child: Row(
////                          mainAxisAlignment: MainAxisAlignment.start,
////                          children: [
////                            Icon(Icons.person,color: Colors.grey,size: 25,),
////                            SizedBox(width: 2,),
////                        Expanded( child: Text('${item.contactName}',style: TextStyle(fontFamily: FONT_FAMILY),
////                        maxLines: 2,
////                        overflow: TextOverflow.ellipsis,
////                        )),
////                          ]
////                      ),),
//////                      SizedBox(height: 3,),
////                      Row(
////
////                          mainAxisAlignment: MainAxisAlignment.start,
////                          children: [
////                              InkWell(
////                              onTap: () {
////                                _launchCaller(item.contactNumber);
////                              },
////                                  child: RotatedBox(
////                              quarterTurns: (translator.currentLanguage == 'en' ) ? 0 : 3,
////                              child:  Icon(Icons.call,color: Colors.blue,size: 25,)))
////                            ,
////                            SizedBox(width: 2,),
////                            Text('${item.contactNumber}',style: TextStyle(fontFamily: FONT_FAMILY, fontSize: 14)),
////                          ]
////                      ),
////                      ])
////                    ],)
////
////
////              ),
////
////            ),
//              );
              } ,
          separatorBuilder: (ctx, index) => SizedBox(height: 20,),
          itemCount: currentDataList.length ,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
    ),
            )),
        Container(
        padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 1.0),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
            IconButton(
              onPressed: page > 1 ? loadPreviousPage : null,
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
              ),
            ),
            Text("$page / $totalPages"),
            IconButton(
              onPressed: page < totalPages ? loadNextPage : null,
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 25,
              ),
            ),]),
          ],
        ),

      ),
      ]):
             Column(
      children: <Widget>[
             Expanded(
                 child: Column(
                     children: <Widget>[
                       SizedBox( height: 20,),
                       Text( translator.translate('noData'),  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),),
                       SizedBox( height: 20,),
                       Container( height: 300, child: SvgPicture.asset("assets/images/empty1.svg",)),
                     ])
             ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 1.0),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            ],
          ),

        )
      ],
    );
             },
              listener: (context, state) {
                  if (state is LocationsSuccessState) {
                   print(state.locationsData.data);
                   setState(() {
                     locations = state.locationsData.data;
//                     dataList.addAll(allLocations);
                     allLocations = locations;
//                     activeLocations = locations.where((element) => element.active == true ).toList();
//                     notActiveLocations = locations.where((element) => element.active != true ).toList();

                     activeTapButton(activeBtn: false,allBtn: true,notActiveBtn: false);
                   });
                  }
                  if (state is LocationsLoadingState ) loadingAlertDialog(context);
                  if (state is LocationsSuccessState) Navigator.of(context).pop();
                  if (state is LocationsFailedState) Navigator.of(context).pop();
                }
        )
      ),
    );
  }
}
