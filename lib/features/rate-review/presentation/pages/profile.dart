import 'package:haulerapp/core/constants.dart';
import 'package:haulerapp/core/sqllite/sqlite_api.dart';
import 'package:haulerapp/features/locationList/presentation/pages/locations-page.dart';
import 'package:haulerapp/features/login/data/models/user.dart';
import 'package:haulerapp/features/login/presentation/pages/login-page.dart';
import 'package:haulerapp/features/navigationDrawer/navigationDrawer.dart';
import 'package:haulerapp/features/request/presentation/pages/request-page.dart';
import 'package:haulerapp/features/requestList/presentation/pages/request-list.dart';
import 'package:haulerapp/features/trips/presentation/pages/trips.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../home.dart';

class RateWidget extends StatefulWidget {
  static const routeName = 'RateWidget';
  RateWidgetState createState() => RateWidgetState();
}

class RateWidgetState extends State<RateWidget> {
  String currentLanguage = translator.currentLanguage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget  build(BuildContext context) {
    // TODO: implement  build
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Rate",
                  style: TextStyle(fontSize: 24.0),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                      size: 30.0,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                      size: 30.0,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                      size: 30.0,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                      size: 30.0,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                      size: 30.0,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Add Review",
                  border: InputBorder.none,
                ),
                maxLines: 8,
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0)),
                ),
                child: Text(
                  "Rate Product",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
