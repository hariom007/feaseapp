import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:feaseapp/API/api.dart';
import 'package:feaseapp/DashBoard/dashBoard.dart';
import 'package:feaseapp/Helper/helper.dart';
import 'package:feaseapp/Login_Register/Institute_verify/fill_institute_detail.dart';
import 'package:feaseapp/Login_Register/Institute_verify/UploadInstituteDocuments.dart';
import 'package:feaseapp/MyNavigator/myNavigator.dart';
import 'package:feaseapp/Values/AppColors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreenPage extends StatefulWidget {
  bool _isInit = true;

  String phone,mobilecontroller;
  
  OTPScreenPage({Key key,this.phone,this.mobilecontroller}) :  super(key: key);
  
  @override
  _OTPScreenPageState createState() => _OTPScreenPageState();
}

class _OTPScreenPageState extends State<OTPScreenPage> {
  int _state = 0;
  bool tandc = false;
  bool isLoading = false;
  String mobileNumber;
  SharedPreferences sharedPreferences;

  String smsOTP;
  String verificationId;
  String errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController optController = TextEditingController();

  Future<void> generateOtp(String contact) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: contact,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {},
          verificationFailed: (FirebaseAuthException exception) {
            // Navigator.pop(context, exception.message);
          });
    } catch (e) {
      handleError(e as FirebaseAuthException);
      // Navigator.pop(context, (e as PlatformException).message);
    }
  }

  Future<void> verifyOtp() async {
    setState(() {
      _state =0;
    });
    if (optController.text == null || optController.text == '') {
      showAlertDialog(context, 'please enter 6 digit otp');
      return;
    }
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: optController.text,
      );
      final UserCredential user = await _auth.signInWithCredential(credential);
      final User currentUser = await _auth.currentUser;
      assert(user.user.uid == currentUser.uid);
        getToken();

    } catch (e) {
      handleError(e as FirebaseAuthException);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load data only once after screen load
    if (widget._isInit) {
      widget.phone = '${ModalRoute.of(context).settings.arguments as String}';
      generateOtp(widget.phone);
      widget._isInit = false;
    }
  }
  //Method for handle the errors
  void handleError(FirebaseAuthException error) {

    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;

      default:
        showAlertDialog(context, error.message);
        break;
    }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
              setState(() {
                _state = 0;
                Navigator.pop(context,true);
              });
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    setState(() {
      _state =0;
    });
  }

  //dispose controllers
  @override
  void dispose() {
    super.dispose();
  }

  Widget setUpButtonChild() {
    if (_state == 0 ) {
      return new Text(
        "Sign Up",
        style: const TextStyle(
          color: AppColors.white_00,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat-regular',
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check,size: 30, color: Colors.white);
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 2200), () {

      setState(() {
        _state = 2;
      });
      verifyOtp();
    });
  }


  void getToken() async {

    String a = widget.phone;
    String removerCountryCode=a.toString().substring(3);

    print(removerCountryCode + " Finally mobile number mil gya.");
    try {

      var response = await http.post(
        "https://finaltestapi.acadmin.in/token",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "Password=$removerCountryCode&grant_type=password&flag=1",
      );

      var body = json.decode(response.body);
      print(body);
      String access_token = body['access_token'];
      print("Device token"+access_token);

      String insCode = body['InstCode'];

      if(insCode != '0'){

        /* Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) =>
          DashBoard(regiInstiCode : insCode)), (Route<dynamic> route) => false,);*/
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("ICODE", insCode);
        String mobileNum = body['MobileNo'];
        print(mobileNum + " Mobile number print");
        sharedPreferences.setString("MOB", mobileNum);
        MyNavigator.goToSplashScreen(context);
        //  checkDocumentsStatus(insCode);
      }

      else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=> FillInstituteDetails(
          access_token: access_token,
          mobileNumber: removerCountryCode,
        )));
      }
    }
    catch (exception) {
      print('$exception');
    }

  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 300,
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              transform: Matrix4.translationValues(0, -15, 0),
                              child: /*Text('Sign In',style: GoogleFonts.galada(
                           color: AppColors.white_00,
                           fontSize: 55
                         ),)*/
                              Image.asset('assets/logo/sample_logo.png',
                                height: 200,
                                width: width*0.6,),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        color: AppColors.white_30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              transform: Matrix4.translationValues(0, height*-0.1, 0),
                              child: Card(
                                elevation: 2,
                                shadowColor: AppColors.white_90,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: AppColors.primaryColor,
                                child: Container(
                                  width: width*0.9,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 30,),
                                      Text('OTP Verification',
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      SizedBox(height: 5,),
                                      Text('Your Mobile No. is : '+widget.phone,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),),
                                      SizedBox(height: 5,),
                                      Text('Enter your OTP code here',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      SizedBox(height: 30,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                                        child: PinCodeTextField(
                                          controller: optController,
                                          appContext: context,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          length:6,
                                          keyboardType: TextInputType.phone,
                                          autoDismissKeyboard: true,
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat-SemiBold',
                                          ),
                                          backgroundColor: AppColors.primaryColor,
                                          autoFocus: true,
                                          enablePinAutofill: true,
                                          pinTheme: PinTheme(
                                              activeColor: AppColors.red_00,
                                              inactiveColor: AppColors.black,
                                              shape: PinCodeFieldShape.box,
                                              selectedColor: AppColors.grey_60,
                                              selectedFillColor: AppColors.grey_60,
                                              borderRadius: BorderRadius.circular(5),
                                              activeFillColor: AppColors.red_00
                                          ),
                                          animationType: AnimationType.slide,
                                          animationDuration: Duration(milliseconds: 300),
                                          // errorAnimationController: errorController, // Pass it here
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(vertical: 20),
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                },
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                      text: 'Didn\'t get the OTP ?',
                                                      style: TextStyle(
                                                          fontFamily: 'Montserrat-Regular',
                                                          color: AppColors.black
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: 'Resend OTP.',
                                                          style: TextStyle( color: AppColors.red_00, fontSize: 18),
                                                        ),
                                                      ]),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width*0.07),
                                        child : new MaterialButton(
                                          child: setUpButtonChild(),
                                          onPressed: () {
                                            setState(() {
                                              if (_state == 0) {
                                               animateButton();
                                              }
                                            });

                                          },
                                          elevation: 4.0,
                                          minWidth: double.infinity,
                                          height: 48.0,
                                          color: AppColors.appBarColor,
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 40,
                  left: 0,
                  child: InkWell(
                    onTap: () {
                      MyNavigator.goToLoginPage(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                            child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
                          ),
                          Text('Back',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                  )),
            ],
          )
      ),
    );
  }
}
