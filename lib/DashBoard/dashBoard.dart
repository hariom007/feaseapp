import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:feaseapp/API/api.dart';
import 'package:feaseapp/DashBoard/HomePage/homePage.dart';
import 'package:feaseapp/DashBoard/MyProfile/myProfile.dart';
import 'package:feaseapp/Helper/helper.dart';
import 'package:feaseapp/Login_Register/Institute_verify/verifivationPending.dart';
import 'package:feaseapp/MyNavigator/myNavigator.dart';
import 'package:feaseapp/Values/AppColors.dart';

class DashBoard extends StatefulWidget {

  String regiInstiCode;
  DashBoard({Key key,this.regiInstiCode}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {


  bool showBadge = false;

  int _currentIndex = 0;
  int _pState = 0;
  String regiInstiCode;
  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
  var pages = [new  HomePage(regiInstiCode:'${widget.regiInstiCode}',), new  MyProfile(),];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: new BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: AppColors.primaryColor,
            selectedItemColor: AppColors.primaryColorDark,
            unselectedItemColor: AppColors.appButtonColor,
            onTap: onTappedChanged,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text("DashBoard"),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.person),
                title: new Text("My Profile"),
              )
            ],
          )
      ),
    );
  }
  void onTappedChanged(int index) {
    setState(() {
      _currentIndex = index;
      _pState=_currentIndex;
    });
  }
}
