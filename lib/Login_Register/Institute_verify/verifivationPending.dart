import 'package:flutter/material.dart';
import 'package:feaseapp/MyNavigator/myNavigator.dart';
import 'package:feaseapp/Values/AppColors.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationPending extends StatefulWidget {
  @override
  _VerificationPendingState createState() => _VerificationPendingState();
}

class _VerificationPendingState extends State<VerificationPending> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quit Application?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat-SemiBold',
              ),),
            content: Text(
              'Are you sure you want to quit app?',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat-Regular',
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryColorDark,
                    fontFamily: 'Montserrat-SemiBold',
                  ),),
                onPressed: ()async{
                  SystemNavigator.pop();
                },
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: FlatButton(
                  child: Text('No',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.appBarColor,
                      fontFamily: 'Montserrat-SemiBold',
                    ),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],

          );
        }
    )) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icon/pending.png',height: 100,
                fit: BoxFit.fill,color: AppColors.red_00,),
              SizedBox(height: 20,),
              Text('Your Verification is still pending.',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),),
              SizedBox(height: 20,),
              Container(
                width: width,
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 30,top: 25),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5,
                        color: AppColors.primaryColor
                    ),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: RaisedButton(
                  color: AppColors.appBarColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Text('Logout',style: TextStyle(
                      color: AppColors.white_00,
                      fontSize: 15,
                      fontFamily: 'Montserrat-SemiBold'
                  ),),
                  onPressed: () async{

                    showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Exit',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat-SemiBold',
                              ),),
                            content: Text(
                              'Are you sure you want to Logout?',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat-Regular',
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Logout?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryColorDark,
                                    fontFamily: 'Montserrat-SemiBold',
                                  ),),
                                onPressed: ()async{
                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  sharedPreferences.clear();
                                  MyNavigator.goToLoginPage(context);
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: FlatButton(
                                  child: Text('Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.appBarColor,
                                      fontFamily: 'Montserrat-SemiBold',
                                    ),),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],

                          );
                        }
                    );

                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
