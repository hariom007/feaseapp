import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';


class Helper{
  static final Helper dialogHelper=Helper._();
  Helper._();

  void hideDialogBox(ProgressDialog pr,BuildContext context) {
    pr.hide();
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5),child:Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(" Loading ...",style: TextStyle(fontSize: 18), ),
          )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}
