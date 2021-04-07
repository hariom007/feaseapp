import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:feaseapp/API/api.dart';
import 'package:feaseapp/DashBoard/dashBoard.dart';
import 'package:feaseapp/Helper/helper.dart';
import 'package:feaseapp/Login_Register/Institute_verify/verifivationPending.dart';
import 'package:feaseapp/Model/getDocumentList.dart';
import 'package:feaseapp/MyNavigator/myNavigator.dart';
import 'package:feaseapp/Values/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadInstituedocuments extends StatefulWidget {

  String InstTypeId,regiInstiCode;
  UploadInstituedocuments({Key key,this.InstTypeId,this.regiInstiCode}) : super(key: key);

  @override
  _UploadInstituedocumentsState createState() => _UploadInstituedocumentsState();
}

class _UploadInstituedocumentsState extends State<UploadInstituedocuments> {

  String ddID;
  bool _isImageShown = false;
  String _error = 'Please select images in gallery';
  String _fileName;
  bool isLoading = false;
  Map<String, String> _paths;
  List<File> tempfiles;
  List<File> files = [];
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingTypes = FileType.any;
  TextEditingController _controller = new TextEditingController();

  List<GetDocumentList> _getDocList = [];
  List<FilePickerResult> result;


  Future<List<dynamic>> makeUploadRequest()async{
    var send;
    var list = [];
    int i = 0;
    for (var abc in _getDocList) {
      if(files.asMap().containsKey(i)){
        send = {'DocID': abc.DocID, 'DocName': abc.DocName , 'DocumentFile' : base64Encode(files[i].readAsBytesSync())};
        list.add(send);
      }
      i++;
    }
    return list;
  }
  void uploadFiles(int index) async {

    setState(() => _loadingPath = true);
    setState(() => _multiPick = true);

    result[index] = await FilePicker.platform.pickFiles(
        allowMultiple: false, type: _pickingTypes);

    try {
        //_paths = await FilePicker.getMultiFilePath(type: _pickingType, fileExtension: _extension);
        tempfiles = result[index].paths.map((path) => File(path)).toList();
        if(files.asMap().containsKey(index)){
          files[index] = tempfiles.first;
        }
        else{
          files.add(tempfiles.first);
        }

    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
    });
  }

  uploadDoc() async{

    Helper.dialogHelper.showAlertDialog(context);

    var listOfDoc = await makeUploadRequest();
    var data = {
      'RegInstCode' : '${widget.regiInstiCode}',
      'UploadedDocumentList' : listOfDoc
    };
    var res = await CallApi().postData(data, 'UploadDocuments');
    var body = json.decode(res.body);
    print(body);

    if (body != null && body['ddID'] =='1')
    {
     Navigator.pushAndRemoveUntil(
       context, MaterialPageRoute(builder: (context) =>
         DashBoard(regiInstiCode : '${widget.regiInstiCode}')), (Route<dynamic> route) => false,
     );
    }
    else
    {
      Fluttertoast.showToast(
        msg: body['msg'].toString(),
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

/*  void uploadFiles() async {

    setState(() => _loadingPath = true);

    List<FilePickerResult> result =[];

    for(var i = 0; i<_getDocList.length; i++){
      var ax = await FilePicker.platform.pickFiles(allowMultiple: false, type: _pickingTypes);
      result.add(ax);
      try {
        //_paths = await FilePicker.getMultiFilePath(type: _pickingType, fileExtension: _extension);
        tempfiles = ax.paths.map((path) => File(path)).toList();
        files.addAll(tempfiles);

      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
    });
  }*/

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getDocList() async{
    List<GetDocumentList> list;

    var data = {
      "InstTypeID": "1"//'${widget.InstTypeId}'
    };
    try{
      var res = await CallApi().postData(data, 'GetDocumentList');
      var body = json.decode(res.body);
      // print(body);
      {
        List getDocList = body as List;
        list = getDocList.map<GetDocumentList>((json) => GetDocumentList.fromJson(json)).toList();

        setState(() {
          _getDocList.addAll(list);
        });
        result = List(_getDocList.length);
        tempfiles = List(_getDocList.length);

      }

    }
    catch(e){
      print('print error: $e');
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


  void checkVerificationStatus() async {
    Helper.dialogHelper.showAlertDialog(context);
    var data = {
      "RegInstCode":'${widget.regiInstiCode}'
    };
    print(data);
    try {
      setState(() {
        isLoading=true;
      });
      var res = await CallApi().postData(data, 'CheckVerificationStatus');
      var body = json.decode(res.body);
      print(body);

      if (body['ddlNm'] == 'Institute Is Verified.' )
      {
        MyNavigator.goToKillDashBoard(context);
      }
      else
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
      });

    }

    catch(e){
      print('print error: $e');
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  //  print('${widget.InstTypeId}');
    getDocList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            height: 100,
            width: width,
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: RichText(
                        text: TextSpan(
                            children:[
                              TextSpan(
                                text: 'Your institute code is  ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                    fontFamily: 'Montserrat-regular'
                                ),
                              ),
                              TextSpan(
                                text: '${widget.regiInstiCode}'+' .',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.red_90,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat-regular'
                                ),
                              )
                            ]
                        )
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.appBarColor,
                    child: IconButton(
                        icon: Icon(Icons.logout),
                        onPressed:(){
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
                        }
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )
            ),

          ),
          Container(
            padding: EdgeInsets.only(top: 100,bottom: 70),
            child: Builder(
              builder: (context){
                return _getDocList.isNotEmpty ?
                ListView.builder(
                    itemCount: _getDocList.length,
                    itemBuilder: (BuildContext context, index){
                      return Container(
                        width: width*0.9,
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10,),
                            Text("DOC NAME : "+_getDocList[index].DocName+" --- "+" --- DOC ID : " + _getDocList[index].DocID,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),
                            SizedBox(height: 20,),

                            RichText(
                                text: TextSpan(
                                    children:[
                                      TextSpan(
                                        text: 'Your institute code is  ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black,
                                            fontFamily: 'Montserrat-regular'
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'XXXXX033XX .',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.red_90,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat-regular'
                                        ),
                                      )
                                    ]
                                )
                            ),
                            SizedBox(height: 13,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kindly proceed with ',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),),
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (_) => Material(
                                        type: MaterialType.transparency,
                                        child: Center(
                                          // Aligns the container to center
                                          child: Container(
                                            width: 100.0,
                                            height: 56.0,
                                            color: Colors.green,
                                            child: Text('jojo'),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('KYC ?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.red_00
                                    ),),
                                ),
                              ],
                            ),

                            SizedBox(height:20,),
                            files.asMap().containsKey(index)?
                            Container():
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: AppColors.white_00
                                  ),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Material(
                                elevation: 5,
                                color: AppColors.white_00,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: TextField(
                                  autofocus: false,
                                  readOnly: true,
                                  onTap: (){
                                    uploadFiles(index);
                                    print('Open File explorer');
                                  },
                                  decoration: InputDecoration(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 7),
                                      child: Icon(Icons.upload_file,color: AppColors.black,),
                                    ),
                                    hintText: 'Upload New Document',
                                    hintStyle:  TextStyle(
                                        fontFamily: 'Montserrat-regular',
                                        color: AppColors.black
                                    ),
                                    border: InputBorder.none,

                                  ),
                                  style:  TextStyle(
                                      fontFamily: 'Montserrat-regular',
                                      color: AppColors.red_90
                                  ),
                                ),
                              ),
                            ),

                            files.asMap().containsKey(index) ?
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Your Selected files here   ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Image.asset('assets/icon/hand-down.png',
                                    height: 20,),
                                ],
                              ),
                            ) :  Container(),


                            files.asMap().containsKey(index)? GestureDetector(
                                onTap: (){
                                  uploadFiles(index);
                                },
                                child:Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Text((index+1).toString()+".  ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Montserrat-regular',
                                              fontWeight: FontWeight.bold
                                          ),),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          tileColor: AppColors.white_00,
                                          dense: true,
                                          title: Text(files[index].path.split('/').last,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Montserrat-regular',
                                                fontWeight: FontWeight.bold
                                            ),),
                                          subtitle: Text(files[index].path,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat-regular',
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )
                            ): Container(),


                            SizedBox(height: 20,),
                           /* Container(
                              width: width,
                              child: RaisedButton(
                                color: AppColors.appBarColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 13.0,
                                ),
                                child: Text('Submit',style: TextStyle(
                                    color: AppColors.white_00,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat-SemiBold'
                                ),),
                                onPressed: () {
                                  // checkVerificationStatus();
                                  // printReq();
                                  if(files.isNotEmpty ){

                                    uploadFiles(index);

                                    // MyNavigator.goToKillDashBoard(context);
                                  }
                                  else{
                                    showInSnackBar('Please Upload mandatory documents files.');

                                  }




                                },
                              ),
                            ),*/


                            SizedBox(height: 10,),

                          ],
                        ),
                      );
                    })
                    :Container();
              },
            ),
          ),

          Positioned(
            bottom: 0,
              child: Container(
                width: width,
                height: 50,
                child: RaisedButton(
                  color: AppColors.appBarColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 13.0,
                  ),
                  child: Text('Upload Document & Submit',style: TextStyle(
                      color: AppColors.white_00,
                      fontSize: 15,
                      fontFamily: 'Montserrat-SemiBold'
                  ),),
                  onPressed: () {

                    if(files.isNotEmpty ){
                      uploadDoc();
                    }
                    else{
                      showInSnackBar('Please Upload mandatory documents files.');
                    }




                  },
                ),
              ),
          ),
        ],
      ),
    );
  }
}


/*Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(height: 20,),
                  Card(
                    elevation: 2,
                    shadowColor: AppColors.white_90,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: AppColors.primaryColor,
                    child: Container(
                      width: width*0.9,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Text('Your Institute Details',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),),
                          SizedBox(height: 20,),

                          RichText(
                              text: TextSpan(
                                children:[
                                  TextSpan(
                                    text: 'Your institute code is  ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      fontFamily: 'Montserrat-regular'
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'XXXXX033XX .',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.red_90,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat-regular'
                                    ),
                                  )
                                ]
                              )
                          ),
                          SizedBox(height: 13,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kindly proceed with ',
                              style: TextStyle(
                                fontSize: 14,
                              ),),
                              GestureDetector(
                                onTap: (){
                                 *//* showDialog(
                                    context: context,
                                    builder: (_) => Material(
                                      type: MaterialType.transparency,
                                      child: Center(
                                        // Aligns the container to center
                                        child: Container(
                                          width: 100.0,
                                          height: 56.0,
                                          color: Colors.green,
                                          child: Text('jojo'),
                                        ),
                                      ),
                                    ),
                                  );*//*
                                },
                                child: Text('KYC ?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.red_00
                                ),),
                              ),
                            ],
                          ),

                          SizedBox(height:20,),
                          files.isNotEmpty ?
                          Container():
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5,
                                    color: AppColors.white_00
                                ),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Material(
                              elevation: 5,
                              color: AppColors.white_00,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: TextField(
                                autofocus: false,
                                readOnly: true,
                                onTap: (){
                                  uploadFiles();
                                  print('Open File explorer');
                                },
                                decoration: InputDecoration(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 7),
                                      child: Icon(Icons.upload_file,color: AppColors.black,),
                                    ),
                                    hintText: 'Upload New Document',
                                    hintStyle:  TextStyle(
                                        fontFamily: 'Montserrat-regular',
                                        color: AppColors.black
                                    ),
                                    border: InputBorder.none,

                                ),
                                style:  TextStyle(
                                    fontFamily: 'Montserrat-regular',
                                    color: AppColors.red_90
                                ),
                              ),
                            ),
                          ),

                          files.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Your Selected files here   ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Image.asset('assets/icon/hand-down.png',
                                  height: 20,),
                              ],
                            ),
                          ) :  Container(),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(files.length, (index) {
                              File file = files[index];
                              var sr= index+1;

                              String path =file.path;
                              String fileName = file.path.split('/').last;
                              print(fileName);

                              return Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(sr.toString()+".  ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Montserrat-regular',
                                            fontWeight: FontWeight.bold
                                        ),),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        tileColor: AppColors.white_00,
                                        dense: true,
                                        title: Text(fileName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Montserrat-regular',
                                          fontWeight: FontWeight.bold
                                        ),),
                                        subtitle: Text(path,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat-regular',
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 0,left: 5),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            files.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.remove_circle,color: AppColors.red_00,),
                                      )
                                    ),

                                  ],
                                ),
                              );
                            }),
                          ),

                          SizedBox(height:20,),

                          files.isNotEmpty ?
                          RaisedButton.icon(
                              onPressed: (){
                                uploadFiles();
                              },
                              color: AppColors.appButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              icon: Icon(Icons.add,color: AppColors.white_00,),
                              label: Text('Add New File',
                              style: TextStyle(
                                fontFamily: 'Montserrat-semibold',
                                color: AppColors.white_00
                              ),)
                          )
                           : Container(),

                          SizedBox(height: 20,),
                          Container(
                            width: width,
                            child: RaisedButton(
                              color: AppColors.appBarColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 13.0,
                              ),
                              child: Text('Submit',style: TextStyle(
                                  color: AppColors.white_00,
                                  fontSize: 15,
                                  fontFamily: 'Montserrat-SemiBold'
                              ),),
                              onPressed: () {
                                // checkVerificationStatus();
                               if(files.isNotEmpty ){

                                MyNavigator.goToKillDashBoard(context);
                               }
                               else{
                                 showInSnackBar('Please Upload mandatory documents files.');

                               }




                              },
                            ),
                          ),

                          SizedBox(height: 10,),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
              top: 40,
              left: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
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
      )*/