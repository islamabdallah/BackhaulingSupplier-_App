import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:haulerapp/features/requestList/data/models/request-list-data.dart';
import 'package:haulerapp/features/requestList/data/models/review.dart';
import 'package:haulerapp/features/requestList/presentation/bloc/request-list-bloc.dart';
import 'package:haulerapp/features/requestList/presentation/bloc/request-list-events.dart';
import 'package:haulerapp/features/requestList/presentation/bloc/request-list-state.dart';
import 'package:haulerapp/features/share/custom-dialog.dart';
import 'package:haulerapp/features/share/loading-dialog.dart';
import 'package:flutter/material.dart';
import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/services/local_storage/local_storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:intl/date_symbol_data_local.dart';

class RequestListWidget extends StatefulWidget {
  static const routeName = 'RequestListWidget';

  RequestListWidgetState createState() => RequestListWidgetState();
}

class RequestListWidgetState extends State<RequestListWidget> with SingleTickerProviderStateMixin  {
//  var selectedIndex = 0;
  RequestListBloc _bloc = RequestListBloc(BaseRequestListState());
  TabController _tabController;
  int _selectedTab = 0;
  LocalStorageService localStorage = LocalStorageService();
  Count count = Count(approved: 0,assigned: 0,canceled: 0,completed: 0,pending: 0,rejected: 0);
  List<Request> pendingList = [];
  List<Request> approvedList = [];
  List<Request> assignedList = [];
  List<Request> rejectedList = [];
  List<Request> completedList = [];
  List<Request> canceledList = [];
  ReviewModel reviewRate;
  String dateLang  = 'en_US';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
//    _bloc.add(GetPendingDataEvent());
    _bloc.add(GetAssignedDataEvent());

//
    setState(() {
      dateLang =  translator.currentLanguage == 'en' ? 'en_US' : 'ar_SA';
    });
    changeDateFormate();
    _tabController.addListener((){
      if (!_tabController.indexIsChanging){
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
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
// show the rating dialog
   _showRatingDialog(Request item) {
     reviewRate = new ReviewModel(reqId: item.id, clientId: item.clientId);
    final _dialog = RatingDialog(
      title: translator.translate('rateTitle'),
      // encourage your user to leave a high rating?
      message: translator.translate('rateMessage'),
//      image: const FlutterLogo(size: 100),
      submitButton: translator.translate('submitButton'),
      commentHint: translator.translate('commentHint'),
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, comment: ${response.comment}');
        reviewRate.rate = response.rating;
        reviewRate.comment = response.comment;
        _bloc.add(ReviewRequestEvent(reviewRate));
      },
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,

    );
  }

  _showRequestDetails(Request item) {
    final df = new DateFormat('d-M-yyyy hh:mm a', dateLang);
    var outputFormat = DateFormat('d-M-yyyy hh:mm a', dateLang);
    var deliverDate = outputFormat.format(item.deliverDate);
    var pickUpDate = df.format(item.pickUpDate);
    final _body = SimpleDialog(
        title:Container(
        color: Colors.blue,
        width: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Text(translator.translate('requestDetails'), style: TextStyle(fontFamily: FONT_FAMILY,
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400)),
        ),
      ),
      children: [
        Container(
        padding: EdgeInsets.only(left: 20,top:5,right: 20,bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex:1,
              child: Row(
                children: [
                  Icon(Icons.label_important,color: Colors.orange,size: 25,),
                  SizedBox(width: 5,),
                  Text('${item.id}', style: TextStyle(fontFamily: FONT_FAMILY,
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w400)),
                ],
              ),
            ),
              Expanded(
                  flex:1,
                  child: InkWell(
                    onTap: (){if(!item.rated && item.statusAsString == 'Completed')  _showRatingDialog(item);},
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.star,color: (item.rate >= 1) ? Colors.yellow : Colors.grey[400] ,size: 20),
                          Icon(Icons.star,color: (item.rate >= 2) ? Colors.yellow : Colors.grey[400],size: 20),
                          Icon(Icons.star,color:(item.rate >= 3) ? Colors.yellow : Colors.grey[400],size: 20),
                          Icon(Icons.star,color: (item.rate >= 4) ? Colors.yellow : Colors.grey[400],size: 20),
                          Icon(Icons.star,color: (item.rate >= 5) ? Colors.yellow : Colors.grey[400],size: 20),

                        ]),
                  )),
            ]),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
//                Icon(Icons.gps_fixed,color: Colors.orange,size: 25,),
//                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.gps_fixed,color: Colors.orange,size: 25,),
                            SizedBox(width: 5,),
                            Expanded(child:
                            Text(translator.translate('sourceData'),
                                style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,color:Colors.grey)),
                            ),
                          ]),
                        SizedBox(height: 10,),
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(translator.translate('date')+":" ,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
                            Expanded(child: Text( " $pickUpDate",style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,))),
                          ]),
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(translator.translate('address')+":" ,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
                            Expanded(child: Text( " ${item.sourceDetailedAddress}",style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,),),
                          ]),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              indent: 16,
              endIndent: 16,
              thickness: 2,
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.place,color: Colors.green,size: 25,),
                            SizedBox(width: 5,),
                            Expanded(child:
                            Text(translator.translate('destinationData'),
                                style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,color:Colors.grey)),
                            ),
                          ]),
                      SizedBox(height: 10,),
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(translator.translate('date')+":" ,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
                            Expanded(child: Text( " $deliverDate ",style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,))),
                          ]),
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(translator.translate('address')+":" ,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
                            Expanded(child: Text( " ${item.destinationDetailedAddress}",style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,),),
                          ]),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              indent: 16,
              endIndent: 16,
              thickness: 2,
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.assignment,color: Colors.grey,size: 25,),
                            SizedBox(width: 5,),
                            Expanded(child:
                            Text(translator.translate('requestDetails'),
                                style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,color:Colors.grey)),
                            ),
                          ]),
                          SizedBox(height: 10,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex:1,
                              child: Row(
                                children: [
                                  Text(translator.translate('carType')+":" ,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
                                  SizedBox(width: 5,),
                                  Text('${item.truckType}',style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex:1,
                              child: Row(
                                children: [
                                  Text(translator.translate('carNo')+":" ,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,)),
                                  SizedBox(width: 5,),
                                  Text('${item.numberOfTrucks}',style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,)),

                                ],
                              ),
                            ),
                          ]),
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(translator.translate('quantity')+":" ,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
                            SizedBox(width: 5,),

                            Text(" ${item.capacity}",style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
                            SizedBox(width: 10,),
                            Text('${item.productPackage}',
                              style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,), maxLines: 3,
                              overflow: TextOverflow.ellipsis,),
                          ]),
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(translator.translate('accessories')+":" ,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Text('${item.accessories}',
                                style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,), maxLines: 3,
                                overflow: TextOverflow.ellipsis,),
                            ),
                          ]),

                    ],
                  ),
                )
              ],
            ),
            Divider(
              indent: 16,
              thickness: 2,
              endIndent: 16,
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.comment ,color: Colors.blue,size: 25,),
                            SizedBox(width: 10,),
//                            Icon(Icons.star,color: (item.rate >= 1) ? Colors.yellow : Colors.grey[400] ,size: 20),
//                            Icon(Icons.star,color: (item.rate >= 2) ? Colors.yellow : Colors.grey[400],size: 20),
//                            Icon(Icons.star,color:(item.rate >= 3) ? Colors.yellow : Colors.grey[400],size: 20),
//                            Icon(Icons.star,color: (item.rate >= 4) ? Colors.yellow : Colors.grey[400],size: 20),
//                            Icon(Icons.star,color: (item.rate >= 5) ? Colors.yellow : Colors.grey[400],size: 20),
                            Expanded(
                              child: Text(" ${item.ratingComment}",
                                  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,),
                            ),

                          ]),
                      SizedBox(height: 15,),

                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),],
      backgroundColor: Colors.white,
      elevation: 4.0,
      insetPadding: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), //this right here
    //  child:

    );
    // show the dialog
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black45,
      barrierLabel: MaterialLocalizations.of(context)
          .modalBarrierDismissLabel,
      pageBuilder: (BuildContext buildContext,
          Animation animation,
          Animation secondaryAnimation) => _body,
    );
  }


  changeDateFormate() async{
    await initializeDateFormatting(dateLang, null);
  }
  Widget requestCard(Request item, bool pending) {
    final df = new DateFormat('d-M-yyyy hh:mm a', dateLang);
    var outputFormat = DateFormat( 'd-M-yyyy',dateLang);
    var deliverDate =  df.format(item.deliverDate);
    var pickUpDate = outputFormat.format(item.pickUpDate);
    return  InkWell(
      onTap: () => _showRequestDetails(item),
      child: Container(
        child: Stack(children: <Widget>[
          Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 15.0),
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex:1,
                                child: Row(
                                  children: [
                                    Icon(Icons.label_important,color: Colors.grey,size: 25,),
                                    SizedBox(width: 5,),
                                    Text('${item.id}', style: TextStyle(fontFamily: FONT_FAMILY,
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                              if(pending)  IconButton(
                                    icon: Icon(Icons.delete,color: Colors.grey,size: 25),onPressed: () {
                                  _bloc.add(CancelRequestEvent(item));
                                }),
                              if(item.statusAsString == 'Completed') Expanded(
                                  flex:1,
                                  child: InkWell(
                                    onTap: (){if(!item.rated && item.statusAsString == 'Completed')  _showRatingDialog(item);},
                                    child: Row(
                                        textBaseline: TextBaseline.alphabetic,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.star,color: (item.rate >= 1) ? Colors.yellow : Colors.grey[400] ,size: 20),
                                          Icon(Icons.star,color: (item.rate >= 2) ? Colors.yellow : Colors.grey[400],size: 20),
                                          Icon(Icons.star,color:(item.rate >= 3) ? Colors.yellow : Colors.grey[400],size: 20),
                                          Icon(Icons.star,color: (item.rate >= 4) ? Colors.yellow : Colors.grey[400],size: 20),
                                          Icon(Icons.star,color: (item.rate >= 5) ? Colors.yellow : Colors.grey[400],size: 20),

                                        ]),
                                  )),
                            ]),
//                        Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: [
//                              Icon(Icons.flag,color: Colors.blue,size: 25,),
//                              SizedBox(width: 5,),
//                              Expanded(
//                                child: Text('${item.id}',style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w600,)),
//                              ),
//                         if(pending)  IconButton(
//                                    icon: Icon(Icons.delete,color: Colors.grey,size: 25),onPressed: () {
//                                  _bloc.add(CancelRequestEvent(item));
//                                }),
//
//                         if(item.statusAsString == 'Completed')
//                           Expanded(
//                               flex:1,
//                               child: InkWell(
//                                 onTap: (){if(item.rated && item.statusAsString == 'Completed')  _showRatingDialog(item);},
//                                 child: Row(
//                                     textBaseline: TextBaseline.alphabetic,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Icon(Icons.star,color: (item.rate >= 1) ? Colors.yellow : Colors.grey[400] ,size: 20),
//                                       Icon(Icons.star,color: (item.rate >= 2) ? Colors.yellow : Colors.grey[400],size: 20),
//                                       Icon(Icons.star,color:(item.rate >= 3) ? Colors.yellow : Colors.grey[400],size: 20),
//                                       Icon(Icons.star,color: (item.rate >= 4) ? Colors.yellow : Colors.grey[400],size: 20),
//                                       Icon(Icons.star,color: (item.rate >= 5) ? Colors.yellow : Colors.grey[400],size: 20),
//
//                                     ]),
//                               )),
////                         Expanded(
////                              flex:1,
////                              child:
////                                Row(
////                                    mainAxisAlignment: MainAxisAlignment.start,
////                                    children: [
////                                      Icon(Icons.star,color: Colors.yellow,size: 20),
////                                      Icon(Icons.star_half_rounded,color: Colors.yellow,size: 20),
////                                      if(item.rated)  Text('${item.rate}',style: TextStyle(
////                                        color: (item.rate > 3) ? Colors.green: (item.rate < 3) ? Colors.redAccent: Colors.yellowAccent,
////                                      ),),
////                                      if(!item.rated) SizedBox(width: 5,),
////                                      if(!item.rated)  InkWell(
////                                        child: Icon(Icons.edit,color: Colors.green,size: 20),
////                                        onTap: () { _showRatingDialog(item);},
////                                      ) ,
////                                    ]),
//
////                            ),
//                            ]
//                        ),
//                        Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: [
//                              Icon(Icons.label,color: Colors.grey[300],size: 25,),
//                              SizedBox(width: 5,),
//                              Text('${item.id}',style: TextStyle(fontFamily: FONT_FAMILY)),
//                            ]
//                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.gps_fixed,color: Colors.orange,size: 25,),
                              SizedBox(width: 5,),
                              Text('${item.sourceName}',style: TextStyle(fontFamily: FONT_FAMILY)),
                            ]
                        ),
                        SizedBox(height: 3,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.place,color: Colors.green,size: 25,),
                              SizedBox(width: 5,),
                              Text('${item.destinationName}',style: TextStyle(fontFamily: FONT_FAMILY)),
                            ]
                        ),
                        SizedBox(height: 3,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex:1,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: (translator.currentLanguage == 'en' ) ? BorderRadius.only(topRight: Radius.circular(20),
                                                bottomRight: Radius.circular(20)) : BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomLeft: Radius.circular(20)),
                                            color: Colors.orange,
                                          ),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.local_shipping,color: Colors.white,size: 25,),
                                                SizedBox(width: 5,),
                                                Text('X',style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,)),
                                                SizedBox(width: 5,),
                                                Text('${item.numberOfTrucks}',style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,)),
                                              ]
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Text('${item.truckType}',style: TextStyle(fontFamily: FONT_FAMILY,fontSize: 12)),
                                      ])),
                              Expanded(
                                  flex:1,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.date_range,color: Colors.orange,size: 25,),
                                        SizedBox(width: 5,),
                                        Text(deliverDate, style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,)),
                                      ])),
                            ]
                        ),
                      ],)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0,left: 5,right: 5),
                width: 110,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: (translator.currentLanguage == 'en' ) ? BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                        : BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    border: Border.all(color: Colors.grey, width: 3),
                    color: Colors.white
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //                            Icon(Icons.local_shipping,color: Colors.white,size: 25,),
                      SizedBox(width: 10,),
                      Text(pickUpDate,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w700,color: Colors.grey)),
                    ]
                ),
              ),
            ]),
      ),
    );
  }
  @override
  Widget  build(BuildContext context) {

//    final Map<String, Object> rcvData = ModalRoute.of(context).settings.arguments;
//    this.selectedIndex = rcvData['id'];
    return Scaffold(
    //  backgroundColor:  Colors.white,
          appBar: AppBar(
              title: Text(translator.translate('requestList'),style: TextStyle(fontFamily: FONT_FAMILY),),
            centerTitle: true,
          ),
          body: DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
              //    SizedBox(height: 10,),
                  Material(
                    elevation: 3,
                    borderOnForeground: true,

               //    color: Colors.grey,
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.blue,
                      indicatorColor: Colors.blue,
                      controller: _tabController,
                     // isScrollable: true,
                   //   labelPadding: const EdgeInsets.only(left: 1.5,top: 2.0,right: 1.5),
                      onTap: (value) => changeTab(value),
                      tabs: [
//                        _getTab(count.pending, translator.translate('pending'),Icons.departure_board),
                        _getTab(count.assigned, translator.translate('approved'),Icons.approval),
                        _getTab(count.completed, translator.translate('completed'),Icons.done),
//                        _getTab(count.rejected, translator.translate('rejected'),Icons.not_interested),
//                        _getTab(count.canceled, translator.translate('canceled'),Icons.cancel),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocConsumer(
                    cubit: _bloc,
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                        assignedList.isEmpty ? Column(
                                children: <Widget>[
                                  SizedBox( height: 20,),
                                  Text( translator.translate('noData'),  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),),
                                  SizedBox( height: 20,),
                                  Container( height: 300, child: SvgPicture.asset("assets/images/empty1.svg",)),
                                ]) : ListView.builder(
                              itemBuilder: (ctx, index) {
                                final approvedItem = assignedList[index];
                                return requestCard(approvedItem, false);

                              },
                              itemCount: assignedList.length ,
                            ),

                            //pendingItem
//                            pendingList.isEmpty ? Column(
//                                    children: <Widget>[
//                                      SizedBox( height: 20,),
//                                      Text( translator.translate('noData'),  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),),
//                                      SizedBox( height: 20,),
//                                      Container( height: 300, child: SvgPicture.asset("assets/images/empty1.svg",)),
//                                    ]) : ListView.builder(
//                              itemBuilder: (ctx, index) {
//                                final pendingItem = pendingList[index];
//                                return requestCard(pendingItem, true);
//                              },
//                              itemCount: pendingList.length ,
//                            ),
                            completedList.isEmpty ? Column(
                                children: <Widget>[
                                  SizedBox( height: 20,),
                                  Text( translator.translate('noData'),  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),),
                                  SizedBox( height: 20,),
                                  Container( height: 300, child: SvgPicture.asset("assets/images/empty1.svg",)),
                                ]): ListView.builder(
                              itemBuilder: (ctx, index) {
                                final completedItem = completedList[index];
                                return requestCard(completedItem, false);
                              },
                              itemCount: completedList.length ,
                            ),
                            //approvedItem
//                            assignedList.isEmpty ?  Column(
//                                children: <Widget>[
//                                  SizedBox( height: 20,),
//                                  Text( translator.translate('noData'),  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),),
//                                  SizedBox( height: 20,),
//                                  Container( height: 300, child: SvgPicture.asset("assets/images/empty1.svg",)),
//                                ]) : ListView.builder(
//                              itemBuilder: (ctx, index) {
//                                final approvedItem = assignedList[index];
//                                return requestCard(approvedItem, false);
//
//                              },
//                              itemCount: assignedList.length ,
//                            ),
//                            //assignedItem// rejectedItem
//                            rejectedList.isEmpty ?  Column(
//                                children: <Widget>[
//                                  SizedBox( height: 20,),
//                                  Text( translator.translate('noData'),  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),),
//                                  SizedBox( height: 20,),
//                                  Container( height: 300, child: SvgPicture.asset("assets/images/empty1.svg",)),
//                                ]) : ListView.builder(
//                              itemBuilder: (ctx, index) {
//                                final rejectedItem = rejectedList[index];
//                                return requestCard(rejectedItem, false);
//                              },
//                              itemCount: rejectedList.length ,
//                            ),
//                            //canceledItem
//                            canceledList.isEmpty ?  Column(
//                                children: <Widget>[
//                                  SizedBox( height: 20,),
//                                  Text( translator.translate('noData'),  style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400),),
//                                  SizedBox( height: 20,),
//                                  Container( height: 300, child: SvgPicture.asset("assets/images/empty1.svg",)),
//                                ]): ListView.builder(
//                              itemBuilder: (ctx, index) {
//                                final canceledItem = canceledList[index];
//                                return requestCard(canceledItem, false);
//                              },
//                              itemCount: canceledList.length ,
//                            ),
                          ],
                        ),
                      );
                    },  listener: (context, state) {
                      if (state is PendingListSuccessState) {
                        pendingList = state.requestListData.requests;
                        setState(() {
                          pendingList.sort((a,b) => b.id.compareTo(a.id));
                          count = state.requestListData.count;
                        });
                      }
                      if (state is AssignedListSuccessState) {
                        print(state.requestListData);
                        assignedList = state.requestListData.requests;
                        setState(() {
                         assignedList.sort((a,b) => b.id.compareTo(a.id));
                         count = state.requestListData.count;
                        });
                      }
                      if (state is ApprovedListSuccessState) {
                        print(state.requestListData);
                        approvedList = state.requestListData.requests;
                        setState(() {
                          approvedList.sort((a,b) => b.id.compareTo(a.id));
                          count = state.requestListData.count;
                        });
                      }
                      if (state is CanceledListSuccessState) {
                        print(state.requestListData.requests);
                        canceledList = state.requestListData.requests;
                        setState(() {
                          canceledList.sort((a,b) => b.id.compareTo(a.id));
                          count = state.requestListData.count;
                        });
                      }
                      if (state is CompletedListSuccessState) {
                        print(state.requestListData);
                        completedList = state.requestListData.requests;

                        setState(() {
                          completedList.sort((a,b) => b.id.compareTo(a.id));
                          count = state.requestListData.count;
                        });
                      }
                      if (state is RejectedListSuccessState) {
                        print(state.requestListData);
                        rejectedList = state.requestListData.requests;
                        setState(() {
                          rejectedList.sort((a,b) => b.id.compareTo(a.id));
                          count = state.requestListData.count;
                        });
                      }

                      if (state is RequestListLoadingState ) loadingAlertDialog(context);
                      if (state is RequestListSuccessState) Navigator.of(context).pop();
                      if (state is RequestListFailedState) Navigator.of(context).pop();

                      if (state is RequestReviewORCancelFailedState) {
                        Navigator.of(context).pop();
                        var msg = state.error.message;
                        var title = (translator.currentLanguage == 'en' ) ? 'Error':'خطاء';
                        showAlertDialog(title, msg, false);
                      }
                      if (state is ReviewRequestSuccessState) {
                            Navigator.pop(context);
                        var successData = state.successData;
                        var msg = (translator.currentLanguage == 'en' ) ? successData.msgEN : successData.msgAR;
                        var title = (translator.currentLanguage == 'en' ) ? 'Success':'تأكيد';
                          showAlertDialog(title, msg, true);
                            _bloc.add(GetCompletedDataEvent());

                      }
                      if (state is CancelRequestSuccessState) {
                        Navigator.pop(context);
                        var successData = state.successData;
                        var msg = (translator.currentLanguage == 'en' ) ? successData.msgEN : successData.msgAR;
                        var title = (translator.currentLanguage == 'en' ) ? 'Success':'تأكيد';
                        showAlertDialog(title, msg, true);
                        _bloc.add(GetPendingDataEvent());

                      }
                    })
                  ),
                ],
              )
          ),
        );
  }
  _getTab(index, child, icon) {
    return Container(
    //  constraints:  BoxConstraints.expand(width: double.infinity ,height: 58.0) ,
      height: 58.0,
      alignment: Alignment.center,
//      padding: const EdgeInsetsDirectional.only(end: 1.0, start: 1.0),
      child: Tab(
        icon: Badge(
            position: BadgePosition.topEnd(top: -6),
            badgeColor: Colors.red,
            badgeContent: Text('${index.toString()}',style: TextStyle(
              color: Colors.white,
              fontSize: index > 9 ? 10 : 12,
            ),),
            child: Icon(icon,size: 25,)),
        text: child,
        iconMargin: EdgeInsets.only(bottom:2.0,top: 5.0),
//      child: Container(
//          alignment: Alignment.center,
//          constraints: (translator.currentLanguage == 'ar' ) ? BoxConstraints.expand(width: 60) : null,
//          child:Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              mainAxisSize: MainAxisSize.min,
//              children: [
//                Badge(
//                      position: BadgePosition.topEnd(top: -6),
//                      badgeColor: Colors.red,
//                      badgeContent: Text('${index.toString()}',style: TextStyle(
//                          color: Colors.white,
//                        fontSize: index > 9 ? 10 : 12,
//                      ),),
//                      child: Icon(icon,size: 25,)),
//                Text(child,style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w400,))
//              ]
//
//          )
//        ),

      ),
    );
  }
  changeTab(int value) {
    switch(value) {
      case 0:
        _bloc.add(GetAssignedDataEvent());
        break;
      case 1:
        _bloc.add(GetCompletedDataEvent());
        break;
      case 2:
        _bloc.add(GetPendingDataEvent());
        break;
      case 3:
        _bloc.add(GetRejectedDataEvent());
        break;
      case 4:
        _bloc.add(GetCanceledDataEvent());
        break;
    }
  }

  _generateBorderRadius(index) {
    if ((index + 1) == _selectedTab)
      return BorderRadius.only(bottomRight: Radius.circular(10.0));
    else if ((index - 1) == _selectedTab)
      return BorderRadius.only(bottomLeft: Radius.circular(10.0));
    else
      return BorderRadius.zero;
  }
}

