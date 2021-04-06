import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:feaseapp/API/api.dart';
import 'package:feaseapp/DashBoard/dashBoard.dart';
import 'package:feaseapp/Login_Register/Institute_verify/UploadInstituteDocuments.dart';
import 'package:feaseapp/MyNavigator/myNavigator.dart';
import 'package:feaseapp/Values/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();

  }

  bool _isLoggedIn= false;
  bool isLoading = false;
  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var instCode = localStorage.getString('ICODE');

    if (instCode != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }

    if (_isLoggedIn) {
      checkDocumentsStatus(instCode);
     // MyNavigator.goToKillDashBoard(context);
    }
    else{
      MyNavigator.goToLoginPage(context);
    }

  }

  void checkDocumentsStatus(String regiInstCode) async {
    var data = {
      "RegInstCode": regiInstCode
    };
    print(data);
    try {
      setState(() {
        isLoading=true;
      });
      var res = await CallApi().postData(data, 'CheckDocumentStatus');
      var body = json.decode(res.body);

      if (body['ddlNm'] != '1' )
      {
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) =>
            UploadInstituedocuments(/*ddID : ddID,*/regiInstiCode: regiInstCode,)), (Route<dynamic> route) => false,);
      }
      else
      {
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) =>
            DashBoard(regiInstiCode : regiInstCode)), (Route<dynamic> route) => false,);
      }
      setState(() {
        isLoading=false;
      });

    }

    catch(e){
      print('print error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final height  = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/sample_logo.png',height: 200,width: 300,fit: BoxFit.contain,),
            SizedBox(height: height/4,),
            SpinKitRing(color: AppColors.appBarColor,size: 60,)
          ],
        )
      ),
    );
  }
}
