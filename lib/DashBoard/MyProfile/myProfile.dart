import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:feaseapp/API/api.dart';
import 'package:feaseapp/DashBoard/MyProfile/ProfilePage/edit_profile.dart';
import 'package:feaseapp/DashBoard/MyProfile/StudentsData/students_data.dart';
import 'package:feaseapp/DashBoard/MyProfile/UploadStudentData/uploadStudentDataWebView.dart';
import 'package:feaseapp/MyNavigator/myNavigator.dart';
import 'package:feaseapp/Values/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  SharedPreferences sharedPreferences;
  bool isLoading = false;
  String url;

  void uploadStudent() async{
    sharedPreferences = await SharedPreferences.getInstance();
    var mobileNum = sharedPreferences.getString("MOB");
    var data = {
      "MobileNo": mobileNum
    };
    print(data);
    try {
      setState(() {
        isLoading=true;
      });

      var res = await CallApi().postData2(data, 'UploadStudent');
      var body = json.decode(res.body);
      // print(body);

      url  = body["Url"];

      print(url);
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
    super.initState();
    uploadStudent();
  }


  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: (){
              }
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Upload Student',
        style: TextStyle(
          fontFamily: 'Montserrat-semibold'
        ),),
        isExtended: true,
        backgroundColor: AppColors.appBarColor,
        onPressed: () async{
         /* await launch(
            url,
            forceSafariVC: true,
            forceWebView: true,
            enableJavaScript: true,
          );*/
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadStudentDatWebView(url: url,)));
        },
      ),
      body:  Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 0.4),
                          ),
                          child: CircleAvatar(
                              radius: 42,
                              backgroundColor: AppColors.white_90,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage('assets/icon/as.png',),
                                        fit: BoxFit.fill
                                    )
                                ),
                              )
                          )
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Advance Group Tuition',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.appButtonColor
                            ),),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.appBackGroundColor,
                      border: Border(
                        top: BorderSide(
                            width: 0.5,
                            color: AppColors.grey_10
                        ),
                        bottom: BorderSide(
                            width: 0.5,
                            color: AppColors.grey_10
                        ),
                      )
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text('Account Management',
                      style: TextStyle(
                          fontFamily: 'Montserrat-regular',
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: 0.5,
                            color: AppColors.grey_10
                        ),
                        bottom: BorderSide(
                            width: 0.5,
                            color: AppColors.grey_10
                        ),
                      )
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile()));
                    },
                    dense: true,
                    title: Text('Profile',
                      style: TextStyle(
                          fontFamily: 'Montserrat-regular',
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey_10
                      ),),
                    trailing: Icon(Icons.person_outline,color: AppColors.primaryColorDark,),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: 0.5,
                            color: AppColors.grey_10
                        ),
                        bottom: BorderSide(
                            width: 0.5,
                            color: AppColors.grey_10
                        ),
                      )
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentsData()));
                    },
                    dense: true,
                    title: Text('Students Data',
                      style: TextStyle(
                          fontFamily: 'Montserrat-regular',
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey_10
                      ),
                    ),
                    trailing: Image.asset('assets/icon/multi_person.png',color: AppColors.primaryColorDark,height: 23,),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: 0.5,
                            color: AppColors.grey_10
                        ),
                        bottom: BorderSide(
                            width: 0.5,
                            color: AppColors.grey_10
                        ),
                      )
                  ),
                  child: ListTile(
                    onTap: (){

                    },
                    dense: true,
                    title: Text('Feedback',
                      style: TextStyle(
                          fontFamily: 'Montserrat-regular',
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey_10
                      ),),
                    trailing: Icon(Icons.feedback_outlined,color: AppColors.primaryColorDark,),
                  ),
                ),

              ],
            ),


            Container(
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 0.5,
                        color: AppColors.grey_10
                    ),
                    bottom: BorderSide(
                        width: 0.5,
                        color: AppColors.grey_10
                    ),
                  )
              ),
              child: ListTile(
                onTap: (){
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
                              child: Text('Logout',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.primaryColorDark,
                                  fontFamily: 'Montserrat-SemiBold',
                                ),),
                              onPressed: ()async{
                                      sharedPreferences = await SharedPreferences.getInstance();
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
                dense: true,
                title: Text('Logout',
                  style: TextStyle(
                      fontFamily: 'Montserrat-regular',
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey_10
                  ),),
                trailing: Icon(Icons.exit_to_app,color: AppColors.primaryColorDark,),
              ),
            ),

          ],
        ),
      )
    );
  }
}
