import 'package:feaseapp/Login_Register/OTPScreen/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:feaseapp/DashBoard/dashBoard.dart';
import 'package:feaseapp/Login_Register/Login_register/login.dart';
import 'package:feaseapp/Login_Register/SplashScreen/splashscreen.dart';
import 'Values/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Feaseapp());
}

class Feaseapp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: 'FeaseApp',
      theme: ThemeData(
        primaryColor: AppColors.red_00,
        scaffoldBackgroundColor: AppColors.primaryBackGroundColor,
        primaryIconTheme: IconThemeData(color: AppColors.white_00),
        iconTheme: new IconThemeData(color: AppColors.primaryColorDark),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: AppColors.white_00,
            fontSize: 16,
            fontFamily: 'Montserrat-SemiBold'
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: AppColors.black,
            fontFamily: 'Montserrat-SemiBold',
          ),
          bodyText2: TextStyle(
              fontFamily: 'Montserrat-Regular',
              color: AppColors.black
          ),
          headline1: TextStyle(
              fontFamily: 'Montserrat-ExtraBold',
              color: AppColors.black
          ),
        ),
      ),
      routes: <String,WidgetBuilder>{
        '/dashboard' : (BuildContext context) => DashBoard(),
        '/logIn' : (BuildContext context) => LoginPage(),
        '/splashScreen' : (BuildContext context) => SplashScreen(),
        '/otpScreen' : (BuildContext context) => OTPScreenPage(),
      },
    );
  }
}
