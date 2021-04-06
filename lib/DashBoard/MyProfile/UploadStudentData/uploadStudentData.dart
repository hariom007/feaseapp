import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feaseapp/Values/AppColors.dart';

class UploadStudentData extends StatefulWidget {
  @override
  _UploadStudentDataState createState() => _UploadStudentDataState();
}

class _UploadStudentDataState extends State<UploadStudentData> {

  bool _isImageShown = false;
  String _error = 'Please select images in gallery';
  String fileName ='';
  int serial;
  bool isLoading = false;
  File files;
  String _extension;
  bool _loadingPath = false;
  bool _hasValidMime = false;
  FileType _pickingTypes = FileType.custom;
  TextEditingController _controller = new TextEditingController();


  void uploadFiles() async {

    setState(() => _loadingPath = true);


    try {

      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: _pickingTypes,
        allowedExtensions: ['xlsx', 'xlsm', 'xlsb','xltx','xltm'],
      );
      // print(result.paths.last);

      fileName = result.paths.last;



    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
    });
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white_00,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Icon(Icons.person),
                text: 'Add Student',
              ),
              Tab(
                  icon: Image.asset('assets/icon/excel.png',height: 20,color: AppColors.white_90,),
                text: 'Upload Student',
              ),
            ],
            indicatorColor: AppColors.black,
            labelStyle: TextStyle(
              fontFamily: 'Montserrat-semibold'
            ),
          ),
          title: Text('Add & Upload Student Data'),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 20,top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Material(
                          elevation: 2,
                          color: AppColors.white_30,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: TextField(
//                                    controller: nameController,
                            autofocus: false,
                            decoration: InputDecoration(
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 7),
                                  child: Icon(Icons.person,color:AppColors.appBarColor,),
                                ),
                                isDense: true,
                                labelText: 'Student Name',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat-semibold'
                                ),
                                border: InputBorder.none
                            ),

                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 20,),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Material(
                          elevation: 2,
                          color: AppColors.white_30,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: TextField(
//                                    controller: nameController,
                            autofocus: false,
                            decoration: InputDecoration(
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 7),
                                  child: Icon(Icons.location_on,color: AppColors.appBarColor,),
                                ),
                                isDense: true,
                                labelText: 'Student Address',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat-semibold'
                                ),
                                border: InputBorder.none
                            ),

                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 20,),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Material(
                          elevation: 2,
                          color: AppColors.white_30,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: TextField(
//                                    controller: nameController,
                            autofocus: false,
                            decoration: InputDecoration(
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 7),
                                  child: Image.asset('assets/icon/rupee.png',height: 20,color: AppColors.appBarColor,),
                                ),
                                isDense: true,
                                labelText: 'Student Fee Amount',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat-semibold'
                                ),
                                border: InputBorder.none
                            ),

                          ),
                        ),
                      ),
                      Container(
                        width: width,
                        margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
                        child: MaterialButton(
                          child: Text("Add Student",
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),

                  GestureDetector(
                    onTap: (){
                      uploadFiles();

                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon/excel.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 20,),
                        Text('Select File',
                          style: TextStyle(
                              fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),),
                      ],
                    ),
                  ),
                  fileName.isNotEmpty  ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: ListTile(
                      tileColor: AppColors.white_30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      ),
                      title: Text(fileName.split('/').last,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat-regular',
                            fontWeight: FontWeight.bold
                        ),),
                      subtitle: Text(fileName.toString(),
                        maxLines: 3,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat-regular',
                        ),
                      ),
                    ),
                  ) : Container(),

                  Container(
                    width: width,
                    margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
                    child: MaterialButton(
                      child: Text("Upload Student",
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
                  ),




                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
