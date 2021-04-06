import 'dart:async';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:feaseapp/Login_Register/OTPScreen/otp_screen.dart';
import 'package:feaseapp/MyNavigator/myNavigator.dart';
import 'package:feaseapp/Values/AppColors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidationMixin {

  int _state = 0;
  bool tandc = false;
  String _status;
  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code;
  bool isLoading = false;
  final _formKey= GlobalKey<FormState>();

  TextEditingController mobileNumberController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _handleError(e) {
    print(e.message);
    setState(() {
      _status += e.message + '\n';
    });
  }

  Country _country= CountryPickerUtils.getCountryByPhoneCode('91');

  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.pink),
      child: CountryPickerDialog(
        searchCursorColor: Colors.pinkAccent,
        divider: Divider(),
        searchInputDecoration: InputDecoration(
            hintText: 'Search...',
            suffixIcon: Icon(Icons.search,color: AppColors.grey_10,),
            hintStyle: TextStyle(
                fontFamily: 'Montserrat-Semibold'
            )
        ),
        isSearchable: true,
        title: Text('Select your phone code',
          style: TextStyle(
              fontFamily: 'Montserrat-Semibold'
          ),),
        onValuePicked: (Country country) =>
            setState(() => _country = country),
        itemBuilder: (Country country){
          return Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(width: 8.0),
              Text("+${country.phoneCode}",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Montserrat-regular'
                ),),
              SizedBox(width: 8.0),
              Flexible(child: Text(country.name,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Montserrat-regular'
                ),))
            ],
          );
        },
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('IN'),
          CountryPickerUtils.getCountryByIsoCode('DE'),
        ],
      ),
    ),
  );

  Future<void> loginUser(String phone) async{

    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        _status += 'verificationCompleted';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(FirebaseAuthException error) {
      print('verificationFailed');
      _handleError(error);

      if (error.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code;
      // print(code.toString());
      setState(() {
        _status += 'Code Sent\n';
      });

    }

    void codeAutoRetrievalTimeout(String verificationId) {
      Duration(seconds: 60);
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    }

    catch (e){
      print(e);
    }
  }



  void showInSnackBar(String args) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
            backgroundColor: AppColors.appBarColor,
            content: new Text(args,style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat-Semibold'
            ),)
        )
    );
  }


  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "Send OTP",
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
      String phone= '+${_country.phoneCode}' + mobileNumberController.text;

      setState(() {
        _state = 2;
        setState(() {
          isLoading =true;
        });
        loginUser(phone);
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
        body:
            isLoading == false ?
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
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
                        child: Image.asset(
                          'assets/logo/sample_logo.png',
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
                                Text('Sign In',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold
                                ),),
                                SizedBox(height: 30,),
                                Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width*0.07),
                                    child: Material(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(2)
                                      ),
                                      elevation: 4.0,
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(left: 15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        right: BorderSide(
                                                            color: AppColors.grey_20,
                                                            width: 0.9
                                                        )
                                                    )
                                                ),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    _openCountryPickerDialog();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      CountryPickerUtils.getDefaultFlagImage(_country),
                                                      Text("  +${_country.phoneCode}  ",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily: 'Monteserrat-semibold'
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              autofocus: false,
                                              validator: validateMobile,
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              controller: mobileNumberController,
                                              decoration: InputDecoration(
                                                  hintText: "Enter Mobile number",
                                                  hintStyle: TextStyle(
                                                      color: AppColors.grey_20,
                                                      fontFamily: 'Montserrat-Semibold',
                                                      fontSize: 14
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 10)
                                              ),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat-regular',
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w700
                                              ),

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 45,),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      tandc = !tandc;
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: CheckboxListTile(
                                            value: tandc,
                                            checkColor: AppColors.white_00,
                                            onChanged: (val) {
                                              if (tandc == false) {
                                                setState(() {
                                                  tandc = true;
                                                });
                                              } else if (tandc == true) {
                                                setState(() {
                                                  tandc = false;
                                                });
                                              }
                                            },
                                            subtitle: !tandc
                                                ? Text(
                                              'Accept T&C and apply.',
                                              style: TextStyle(color: AppColors.red_80),
                                            )
                                                : null,
                                            title:  /*Text('By Registering You Confirm That You Accept Terms & Conditions and Privacy Policy',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat-regular',
                                                  fontSize: 13
                                              ),)*/
                                            RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat-regular',
                                                      fontSize: 13,
                                                      color: AppColors.black
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                        text: 'By Registering You Confirm That You Accept '
                                                    ),
                                                    TextSpan(
                                                      text: 'Terms & Conditions and Privacy Policy.',
                                                      style: TextStyle(
                                                          fontFamily: 'Montserrat-regular',
                                                          fontSize: 14,
                                                          color: AppColors.red_00
                                                      ),
                                                    )
                                                  ]
                                              ),
                                            ),
                                            controlAffinity: ListTileControlAffinity.leading,
                                            activeColor: AppColors.appBarColor,
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width*0.07),
                                  child : new MaterialButton(
                                    child: setUpButtonChild(),
                                    onPressed: () {
                                      setState(() {
                                        if (_state == 0 && tandc == true) {
                                          if (_formKey.currentState.validate() ) {

                                            animateButton();
                                          }
                                          else{
                                            showInSnackBar('Please Fill Details.');
                                          }
                                        }
                                        else{
                                          showInSnackBar('Please Accept and Terms & Conditions and Privacy Policy.');
                                        }
                                      });
                                    },
                                    elevation: 4.0,
                                    minWidth: double.infinity,
                                    height: 48.0,
                                    color: AppColors.appBarColor,
                                  ),
                                ),
                              SizedBox(height: 50,)
                              /*  Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            MyNavigator.goToRegistrationPage(context);
                                          },
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text: 'Already have an account?',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-Regular',
                                                    color: AppColors.black
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: ' Sign In',
                                                    style: TextStyle( color: AppColors.appButtonColor, fontSize: 18),
                                                  ),
                                                ]),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
        : OTPScreenPage(phone: mobileNumberController.text,)

    );
  }
}

class ValidationMixin {

  String validateMobile(String value) {
    if (value.isEmpty) {
      return 'Please enter mobile number\n';
    }
    if (value.length > 10) {
      return 'Must be more than 10 character\n';
    }
    if (value.length < 10) {
      return 'Must be more than 10 character\n';
    }
    return null;
  }

}
