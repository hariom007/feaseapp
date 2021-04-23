import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:feaseapp/API/api.dart';
import 'package:feaseapp/Helper/helper.dart';
import 'package:feaseapp/Login_Register/Institute_verify/UploadInstituteDocuments.dart';
import 'package:feaseapp/MyNavigator/myNavigator.dart';
import 'package:feaseapp/Values/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FillInstituteDetails extends StatefulWidget {

  final String access_token,mobileNumber;
  FillInstituteDetails({Key key, this.access_token,this.mobileNumber}) : super(key: key);

  @override
  _FillInstituteDetailsState createState() => _FillInstituteDetailsState();
}
class Type {
  final String id;
  final String name;

  Type(this.id, this.name);
}

class _FillInstituteDetailsState extends State<FillInstituteDetails> with ValidationMixin {

  String ID;
  bool isLoading = false;
  File _image;
  String img_Data = '';
  bool _status = true;
  bool isloading = false;
  SharedPreferences sharedPreferences;

  String InstTypeId;

  TextEditingController instituteTrustNameController =  TextEditingController();
  TextEditingController instituteNameController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController contactController =  TextEditingController();
  TextEditingController websiteController =  TextEditingController();
  TextEditingController addressController =  TextEditingController();
  TextEditingController shortNameController =  TextEditingController();
  TextEditingController placeController =  TextEditingController();
  TextEditingController udiseNoController =  TextEditingController();
  TextEditingController indexNoController =  TextEditingController();
  TextEditingController centerCodeController =  TextEditingController();

  Type bindCampus;
  Type bindInstituteType;
  Type bindBoardType;
  Type bindUniversity;

  List<Type> bindCampusList = <Type>[];
  List<Type> bindInstituteTypeList = <Type>[];
  List<Type> bindBoardTypeList = <Type>[];
  List<Type> bindUniversityList = <Type>[];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _fbKey = GlobalKey<FormState>();

  void showInSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
            backgroundColor: AppColors.appBarColor,
            content: new Text(text,style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat-Semibold'
            ),)
        )
    );
  }

  getBindCampusList() async {

      var data ={

      };

    setState(() {
      isLoading = true;
    });

    try {
      var res = await CallApi().postData(data,'BindCampusList');
      var body = json.decode(res.body);
      print(body);
      if (body != null)
      {
        var result  = body as List;
        // print(result);
        var send;
        for (var abc in result) {
          send = Type(abc['ddID'],abc['ddlNm']);
          bindCampusList.add(send);
        }
      }
    }
    catch(e){
      print('print error: $e');
    }
    setState(() {
      isLoading = false;
      // isLoaded = true;

    });
  }
  getBindInstituteType() async {

    var data ={

    };

    setState(() {
      isLoading = true;
    });

    try {
      var res = await CallApi().postData(data,'BindInstituteType');
      var body = json.decode(res.body);
      // print(body);

      if (body != null)
      {
        var result  = body as List;
        // print(result);
        var send;
        for (var abc in result) {
          send = Type(abc['ddID'],abc['ddlNm']);
          bindInstituteTypeList.add(send);

          InstTypeId = abc['ddID'];
         // print("Institute Type :  ----"+ddID);
        }
      }
    }
    catch(e){
      print('print error: $e');
    }
    setState(() {
      isLoading = false;
      // isLoaded = true;

    });
  }
  getBindBoardTypeList() async {

    var data ={

    };

    setState(() {
      isLoading = true;
    });

    try {
      var res = await CallApi().postData(data,'BindBoard');
      var body = json.decode(res.body);
      print(body);
      if (body != null)
      {
        var result  = body as List;
        // print(result);
        var send;
        for (var abc in result) {
          send = Type(abc['ddID'],abc['ddlNm']);
          bindBoardTypeList.add(send);
        }
      }
    }
    catch(e){
      print('print error: $e');
    }
    setState(() {
      isLoading = false;
      // isLoaded = true;

    });
  }
  getBindUniversityList() async {

    var data ={

    };

    setState(() {
      isLoading = true;
    });

    try {
      var res = await CallApi().postData(data,'BindUniversityList');
      var body = json.decode(res.body);
      print(body);
      if (body != null)
      {
        var result  = body as List;
        // print(result);
        var send;
        for (var abc in result) {
          send = Type(abc['ddID'],abc['ddlNm']);
          bindUniversityList.add(send);
        }
      }
    }
    catch(e){
      print('print error: $e');
    }
    setState(() {
      isLoading = false;
      // isLoaded = true;

    });
  }


  @override
  void initState() {
    super.initState();

    getBindCampusList();
    getBindInstituteType();
    getBindBoardTypeList();
    getBindUniversityList();
    contactController.text = '${widget.mobileNumber}';

  }

  void saveInstituteDetail(String imgData) async {
    Helper.dialogHelper.showAlertDialog(context);
    var data = {

      "InstTrustName": instituteTrustNameController.text,
      "InstName": instituteNameController.text,
      "EmailID": emailController.text,
      "ContactDetail": contactController.text,
      "WebSite": websiteController.text,
      "CampusID": bindCampus.id==null ? '' : bindCampus.id,
      "InstTypeID": bindInstituteType.id==null ? '' : bindInstituteType.id,
      "BoardID": bindBoardType.id==null ? '' : bindBoardType.id,
      "UniversityID": bindUniversity.id==null ? '' : bindUniversity.id,
      "InstAddress": addressController.text,
      "InstShortName": shortNameController.text,
      "place": placeController.text,
      "UdiseNo": udiseNoController.text,
      "IndexNo": indexNoController.text,
      "CenterCode": centerCodeController.text,
      "InstLogo" : imgData,
      "DeviceToken" : '${widget.access_token}',

    };
    print(data);
    try {
      setState(() {
        isLoading=true;
      });
      var res = await CallApi().postData(data, 'saveNewInstitute');
      var body = json.decode(res.body);
      print("Save New Institute : "+body.toString());

        if (body['ddID'] != null && body['ddlNm'] != null)
        {
          String regiInstiCode = body['ddID'];
          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("ICODE", regiInstiCode);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadInstituedocuments(InstTypeId : InstTypeId,regiInstiCode: regiInstiCode,)));
        }
        else
        {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Error Occured",
            textColor: Colors.black,
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 15,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
          );
        }
      setState(() {
        isLoading=false;
      });

    }


    catch(e){
      print('print error: $e');
    }
  }

  void _optionDialogBox() async {
    final height = MediaQuery.of(context).size.height;
    final imageSource = await showModalBottomSheet<ImageSource>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.white_00,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(2.0)),
        ),
        elevation: 2,
        builder: (builder) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    child: Wrap(
                      children: <Widget>[
                        ListTile(
                          dense: true,
                          onTap: () => Navigator.pop(context, ImageSource.camera),
                          title: Row(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: height * 0.02),
                            ),
                            Icon(Icons.camera_alt,color: AppColors.black,),
                            Padding(
                              padding: EdgeInsets.only(left: height * 0.02),
                            ),
                            Text('Camera',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Montserrat-regular'
                              ),),
                          ],),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => Navigator.pop(context, ImageSource.gallery),
                          title: new Row(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: height * 0.02),
                            ),
                            Icon(Icons.sd_storage,color: AppColors.black,),
                            Padding(
                              padding: EdgeInsets.only(left: height * 0.02),
                            ),
                            Text('Gallery', style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat-regular'
                            ),),
                          ],),
                        ),
                      ],
                    ))),
          );
        }
    );
    if (imageSource != null) {
      setState(() {
        isloading = true;
      });
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() => _image = file);
      }
      setState(() {
        isloading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Container(
                    child: Form(
                      key: _fbKey,
                      child: Column(
                        children: [
                          Container(
                            height: 300,
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.asset('assets/logo/sample_logo.png',
                                    height: 200,
                                    width: width*0.6,),
                                ),
                              ],
                            ),
                          ),
                          Card(
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
                                  SizedBox(height: 20,),
                                  Text('Fill Institute Form',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 20,),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        validator: validateinstituteTrustName,
                                        controller: instituteTrustNameController,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.person_outline,color: AppColors.red_90,),
                                            ),
                                            isDense: true,
                                            labelText: 'Institute Trust Name',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        controller: instituteNameController,
                                        validator: validateinstituteName,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.person_outline,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Institute Name',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        validator: validateEmail,
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.alternate_email,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Email Id',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        readOnly: true,
                                        controller: contactController,
                                        validator: validateMobile,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.phone,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Contact number',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        controller: websiteController,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.alternate_email,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Website',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),

                                  //institute type

                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: DropdownButtonFormField<Type>(
                                        isExpanded: true,
                                        validator: (value) => value == null ? 'Select any Institute type' : null,
                                        hint: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Text('Select Institute Type',
                                            style: TextStyle(
                                                color: AppColors.grey_00,
                                                fontFamily: 'Montserrat-Regular'
                                            ),
                                          ),
                                        ),
                                        // underline: SizedBox(),
                                        decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.none
                                        )),
                                        value: bindInstituteType,
                                        onChanged: (Type t) {
                                          setState(() {
                                            bindInstituteType = t;
                                            print(t.id.toString());
                                          });
                                        },
                                        items: bindInstituteTypeList.map((Type t) {
                                          return DropdownMenuItem<Type>(
                                            value: t,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: Text(t.name,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat-Regular'
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),

                                  //University
                                  bindInstituteType == null ? Container(): bindInstituteType.name == "COLLEGE" ?
                                    Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: DropdownButtonFormField<Type>(
                                        isExpanded: true,
                                        validator: (value) => value == null ? 'Select University type' : null,
                                        hint: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Text('Select University Type',
                                            style: TextStyle(
                                                color: AppColors.grey_00,
                                                fontFamily: 'Montserrat-Regular'
                                            ),
                                          ),
                                        ),
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide.none
                                            )
                                        ),
                                        value: bindUniversity,
                                        onChanged: (Type t) {
                                          setState(() {
                                            bindUniversity = t;
                                            print(t.id.toString());
                                          });
                                        },
                                        items: bindUniversityList.map((Type t) {
                                          return DropdownMenuItem<Type>(
                                            value: t,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: Text(t.name,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat-Regular'
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ): Container(),
                                  //Board type
                                  bindInstituteType == null ? Container():bindInstituteType.name =="SCHOOL"?
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: DropdownButtonFormField<Type>(
                                        isExpanded: true,
                                        validator: (value) => value == null ? 'Select any Board Type' : null,
                                        hint: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Text('Select Board Type',
                                            style: TextStyle(
                                                color: AppColors.grey_00,
                                                fontFamily: 'Montserrat-Regular'
                                            ),
                                          ),
                                        ),
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide.none
                                            )),
                                        value: bindBoardType,
                                        onChanged: (Type t) {
                                          setState(() {
                                            bindBoardType = t;
                                            print(t.id.toString());
                                          });
                                        },
                                        items: bindBoardTypeList.map((Type t) {
                                          return DropdownMenuItem<Type>(
                                            value: t,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: Text(t.name,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat-Regular'
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ): Container(),

                                  //Campus
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: DropdownButton<Type>(
                                        isExpanded: true,
                                        // validator: (value) => value == null ? 'Select any PG type' : null,
                                        hint: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Text('Select Campus List',
                                            style: TextStyle(
                                                color: AppColors.grey_00,
                                                fontFamily: 'Montserrat-Regular'
                                            ),
                                          ),
                                        ),
                                        underline: SizedBox(),
                                        /*decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white))),*/
                                        value: bindCampus,
                                        onChanged: (Type t) {
                                          setState(() {
                                            bindCampus = t;
                                            print(t.id.toString());
                                          });
                                        },
                                        items: bindCampusList.map((Type t) {
                                          return DropdownMenuItem<Type>(
                                            value: t,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: Text(t.name,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat-Regular'
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        validator: validateinstituteAddress,
                                        controller: addressController,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.location_on,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Institute Address',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        controller: shortNameController,
                                        validator: validateinstituteShortName,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.person,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Institute Short Name',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        controller: placeController,
                                        validator: validateinstitutePlace,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.place_outlined,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Place',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        controller: udiseNoController,
                                        validator: validateusideNo,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.format_list_numbered,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'UdiseNo',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        validator: validateindexno,
                                        controller: indexNoController,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.format_list_numbered,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Index No',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),

                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Material(
                                      elevation: 5,
                                      color: AppColors.primaryColorLight,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        validator: validatecentercode,
                                        controller: centerCodeController,
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Icon(Icons.code,color: AppColors.red_90,),
                                            ),
                                            // isDense: true,
                                            labelText: 'Center Code',
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat-regular',
                                                color: AppColors.red_90
                                            ),
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 25,right: 20,bottom: 10,top: 5),
                                      child: Text('Select Institute Logo',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-regular',
                                            color: AppColors.red_90,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      _optionDialogBox();
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(left: 20,right: 20,bottom: 30,top: 5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                        ),
                                        child:  _image == null
                                            ? Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                  image: AssetImage('assets/icon/camera.png',),
                                                  fit: BoxFit.contain
                                              )
                                          ),
                                        )
                                            :
                                        Container(
                                          height: 170,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                  image: FileImage(_image),
                                                  fit: BoxFit.fill
                                              )
                                          ),
                                        )
                                    ),
                                  ),

                                  Container(
                                    width: width,
                                    margin: EdgeInsets.only(left: 20,right: 20,bottom: 30,top: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color: AppColors.primaryColor
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: RaisedButton(

                                      color: AppColors.appBarColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 17.0,
                                      ),
                                      child: Text('Submit',style: TextStyle(
                                          color: AppColors.white_00,
                                          fontSize: 15,
                                          fontFamily: 'Montserrat-SemiBold'
                                      ),),
                                      onPressed: () {



                                        if (_fbKey.currentState.validate() ) {
                                        if(_image != null){
                                          Helper.dialogHelper.showAlertDialog(context);
                                          if(_image != null){
                                            img_Data = base64Encode(_image.readAsBytesSync());
                                          }
                                          saveInstituteDetail(img_Data);
                                          Navigator.pop(context);
                                        }
                                        else{
                                          showInSnackBar('Select Institute logo');
                                        }
                                        }

                                        else{
                                          showInSnackBar('Please Fill details.');
                                        }

                                      },
                                    ),
                                  ),
                                  SizedBox(height: 30,),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40,)
                        ],
                      ),
                    ),
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
          ),
        ),
    );
  }
}

class ValidationMixin {



  String validateinstituteTrustName(String value) {
    if (value.isEmpty) {
      return 'Please enter Institute Trust Name\n';
    }
    if (value.length < 3) {
      return 'Must be more than 3 character\n';
    }
    return null;
  }

  String validateinstituteName(String value) {
    if (value.isEmpty) {
      return 'Please enter Institute Name\n';
    }
    if (value.length < 3) {
      return 'Must be more than 3 character\n';
    }
    return null;
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

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

  String validateinstituteAddress(String value) {
    if (value.isEmpty) {
      return 'Please enter Institute Address\n';
    }
    if (value.length < 3) {
      return 'Must be more than 3 character\n';
    }
    return null;
  }

  String validateinstituteShortName(String value) {
    if (value.isEmpty) {
      return 'Please enter Institute Short Name\n';
    }
    if (value.length < 3) {
      return 'Must be more than 3 character\n';
    }
    return null;
  }

  String validateinstitutePlace(String value) {
    if (value.isEmpty) {
      return 'Please enter Place name\n';
    }
    if (value.length < 3) {
      return 'Must be more than 3 character\n';
    }
    return null;
  }
  String validateusideNo(String value) {
    if (value.isEmpty) {
      return 'Please enter UsideNo\n';
    }
    return null;
  }

  String validateindexno(String value) {
    if (value.isEmpty) {
      return 'Please enter Index No.\n';
    }
    return null;
  }
  
  String validatecentercode(String value) {
    if (value.isEmpty) {
      return 'Please enter Center Code\n';
    }
    return null;
  }

}

//com.feaseapp
// MD5: B6:37:C4:F1:AA:EF:7F:64:2A:BD:AC:9F:9E:47:AD:D6
// SHA1: 49:6C:C2:86:19:7E:E1:00:B7:9B:94:0E:C7:DD:A3:50:88:A0:CF:31
// SHA-256: A6:31:1B:98:A2:DE:FF:F3:45:2D:1A:B2:EC:EA:E7:AE:53:86:80:56:B5:0A:B1:10:B0:09:65:58:48:3D:1F:79
