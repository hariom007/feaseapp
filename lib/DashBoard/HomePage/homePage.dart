import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:feaseapp/API/api.dart';
import 'package:feaseapp/Login_Register/Institute_verify/verifivationPending.dart';
import 'package:feaseapp/Values/AppColors.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  String regiInstiCode;
  HomePage({Key key,this.regiInstiCode}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
enum LegendShape { Circle, Rectangle }


class _HomePageState extends State<HomePage> {

  bool isLoaded= false;
  var collectedFee = "", pendingFee="", todayFee="" ;
  int cFee =0,pFee =0,tFee =0;
  SharedPreferences sharedPreferences;


  Map<String, String> dataMap = {
      "Today Fee": '',
      "Pending fee": '105000',
      "Today fee": '',
  };



  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];


  bool isLoading = false;
  String Name="";

  void checkVerificationStatus() async {
    var data = {
      "RegInstCode":'${widget.regiInstiCode}'
    };
    // print(data);
    try {
      setState(() {
        isLoading=true;
      });

      var res = await CallApi().postData(data, 'CheckVerificationStatus');
      var body = json.decode(res.body);
      // print('${widget.regiInstiCode}'+"============"+body.toString());

      if (body['ddlNm'] != 'Institute Is Verified.' )
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationPending()));
        Fluttertoast.showToast(
          msg: 'Your Verification is Pending',
          textColor: Colors.black,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 15,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
        );

      }

      setState(() {
        isLoading=false;
        isLoaded = true;
      });

    }

    catch(e){
      print('print error: $e');
    }
  }


  void feeCollection() async {
    var data = {
      "RegInstCode":'${widget.regiInstiCode}'
    };
    // print(data);
    try {
      setState(() {
        isLoading=true;
      });

      var res = await CallApi().postData(data, 'FeesCollectionStatus');
      var body = json.decode(res.body);
      // print('${widget.regiInstiCode}'+"============"+body.toString());
      // print(body);

      if (body['Msg'] != 'Institute Code is not registered' )
      {
        // print('Total fee');
        collectedFee = body['TotalCollectedFees'];
        pendingFee = body['TotalPendingFees'];
        todayFee = body['TodaysFeesCollection'];

      }

      setState(() {
        isLoading=false;
      });

    }

    catch(e){
      print('print error: $e');
    }
  }

  void profileShow() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var mobileNum = sharedPreferences.getString("MOB");

    var data = {
      "MobileNo": mobileNum
    };
    try {
      setState(() {
        isLoading=true;
      });

      var res = await CallApi().postData3(data, 'GetStaffPersonalDetail');
      var body = json.decode(res.body);

      if (body != null )
      {
        Name = body['Name'];
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
  void initState() {
    // TODO: implement initState
    super.initState();
    checkVerificationStatus();
    profileShow();

    feeCollection();
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoaded ? Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            width: width,
            height: 80,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.2)
                )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 9,bottom: 9),
                  child: Image.asset(
                    'assets/logo/sample_logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          radius: 32,
                          child: CircleAvatar(
                            radius: 31,
                            child: Image.asset('assets/icon/as.png'),
                          ),

                        ),
                      ),
                    )
                )

              ],
            ),
          ),
        ),
      ),
      body: isLoaded == true ? Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                      padding: EdgeInsets.only(left: 20,top: 20,bottom: 25),
                    child: Text(Name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.white_70,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.assignment,
                                      color: AppColors.primaryColorDark
                                      ,
                                      size: 30,
                                    ),
                                    //Image.asset('assets/homexp_icon/myservice.png',height: 30,),
                                    SizedBox(height: 3,),
                                    Text('1.2K\n Students',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.black
                                      ),)
                                  ],
                                ),
                              ),
                            )
                        ),
                        SizedBox(width: 5,),

                        Expanded(
                            child: GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.white_70,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.assignment,
                                      color: AppColors.primaryColorDark
                                      ,
                                      size: 30,
                                    ),
                                    //Image.asset('assets/homexp_icon/myservice.png',height: 30,),
                                    SizedBox(height: 3,),
                                    Text('1.2K\n Students',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.black
                                      ),)
                                  ],
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Today Collection History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.appBarColor
                        ),),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)
                            ),
                            color: AppColors.primaryLightColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 15,),
                                  Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-Regular',
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16
                                          ),
                                          children: [

                                            TextSpan(
                                              text: "Today fee collect : ",
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-Regular',
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                      children: [
                                        WidgetSpan(
                                            child: Image.asset('assets/icon/rupee.png',
                                            height: 20,)
                                        ),
                                        TextSpan(
                                          text: todayFee.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),

                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Collection History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.appBarColor
                        ),),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)
                            ),
                            color: AppColors.primaryLightColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 15,),
                                  Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-Regular',
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16
                                          ),
                                          children: [

                                            TextSpan(
                                              text: "Total fee collect : ",
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-Regular',
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                      children: [
                                        WidgetSpan(
                                            child: Image.asset('assets/icon/rupee.png',
                                            height: 20,)
                                        ),
                                        TextSpan(
                                          text: collectedFee.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),

                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)
                            ),
                            color: AppColors.white_70,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 15,),
                                  Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-Regular',
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16
                                          ),
                                          children: [

                                            TextSpan(
                                              text: "Pending fee collect : ",
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-Regular',
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                      children: [
                                        WidgetSpan(
                                            child: Image.asset('assets/icon/rupee.png',
                                            height: 20,)
                                        ),
                                        TextSpan(
                                          text: pendingFee.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),

                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 40,),

                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: PieChart(
                      dataMap: {
                        'Today Fee' : double.tryParse(collectedFee),
                        "Pending fee": double.tryParse(pendingFee),
                        "Today fee": double.tryParse(todayFee),
                      },
                      animationDuration: Duration(milliseconds: 100),
                      chartLegendSpacing: 62,
                      chartRadius: MediaQuery.of(context).size.width,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 30,
                      centerText: "Student\n Graph",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat-semibold'
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        chartValueBackgroundColor: AppColors.primaryColor,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: true,
                        chartValueStyle: TextStyle(
                          fontFamily: 'Montserrat-semibold',
                          color: AppColors.black
                        )
                      ),
                    ),
                  ),

                  SizedBox(height: 40,),
                ],
              ),
            ),
          ),


        ],
      ): Center(child: CircularProgressIndicator()),
    ):Center(child: CircularProgressIndicator());
  }
}
