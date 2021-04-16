import 'dart:convert';
import 'dart:io';
import 'package:feaseapp/API/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:feaseapp/Values/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  bool isloading = false;
  File _image;
  SharedPreferences sharedPreferences;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();


  void profileShow() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var mobileNum = sharedPreferences.getString("MOB");
    sharedPreferences = await SharedPreferences.getInstance();
    var regiCode = sharedPreferences.getString("ICODE");
    var data = {
      "MobileNo": mobileNum
    };
    // print(data);

    try {
      setState(() {
        isloading=true;
      });

      var res = await CallApi().postData3(data, 'GetStaffPersonalDetail');
      var body = json.decode(res.body);
      print(body);

      if (body != null )
      {
        name.text = body['Name'];
        address.text = body['Address'];
        email.text = body['EmailID'];
      }

      setState(() {
        isloading = false;
      });

    }

    catch(e){
      print('print error: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    profileShow();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.3,
                          color: AppColors.black
                        )
                      )
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    child: _image ==null ?  Center(
                      child: CircleAvatar(
                        radius: 85,
                        child: Image.asset('assets/icon/as.png'),
                      ),
                    ) : Image.file(_image,
                    fit: BoxFit.contain,),
                  ),
                  /*Align(
                    alignment: Alignment(0, 0.8),
                    child: MaterialButton(
                      minWidth: 0,
                      elevation: 0.5,
                      color: AppColors.white_90,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: _optionDialogBox,
                    ),
                  ),*/
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: "Institue Name",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat-regular',
                          fontSize: 15
                      ),

                    ),
                    readOnly: true,
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Institute Email",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat-regular',
                          fontSize: 15,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    controller: email,
                    readOnly: true,
                    style: TextStyle(
                        fontFamily: 'Montserrat-regular',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: address,
                    decoration: InputDecoration(
                      labelText: "Institute Address",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat-regular',
                          fontSize: 15
                      ),
                    ),
                    readOnly: true,
                    style: TextStyle(
                      fontFamily: 'Montserrat-regular',

                    ),
                  ),

                  SizedBox(height: 20.0),

                  MaterialButton(
                    child: Text("Save",
                    style: TextStyle(
                      fontFamily: 'Montserrat-semibold',
                      fontSize: 15
                    ),),
                    color: AppColors.appBarColor,
                    onPressed: (){

                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _optionDialogBox() async {
    final height = MediaQuery.of(context).size.height;
    final imageSource = await showModalBottomSheet<ImageSource>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[50],
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
                          onTap: () =>
                              Navigator.pop(context, ImageSource.camera),
                          title: new Row(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: height*0.02),
                            ),
                            Icon(Icons.camera_alt),
                            Padding(
                              padding: EdgeInsets.only(left: height*0.02),
                            ),
                            Text('Camera',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'montserrat-regular'
                              ),),
                          ],),
                        ),
                        ListTile(
                          onTap: () =>
                              Navigator.pop(context, ImageSource.gallery),
                          title: new Row(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: height*0.02),
                            ),
                            Icon(Icons.sd_storage),
                            Padding(
                              padding: EdgeInsets.only(left: height*0.02),
                            ),
                            Text('Gallery',style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'montserrat-regular'
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
}
