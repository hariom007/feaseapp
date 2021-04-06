import 'dart:convert';
import 'package:flutter/cupertino.dart';

List<GetDocumentList> GetDocumentListModelListFromJson(String str) =>
    List<GetDocumentList>.from(json.decode(str).map((x) => GetDocumentList.fromJson(x)));

String GetDocumentListListToJson(List<GetDocumentList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetDocumentList{
  String DocID;
  String DocName;
  bool IsRequired;

  GetDocumentList({
    this.DocID,
    this.DocName,
    this.IsRequired,

  });

  factory GetDocumentList.fromJson(Map<String, dynamic> json) {
    return GetDocumentList(
      DocID: json['DocID'],
      DocName: json['DocName'],
      IsRequired: json['IsRequired'],

    );}

  Map<String,dynamic> toJson() => {
    'DocID' : DocID,
    'DocName' : DocName,
    'IsRequired' : IsRequired

  };
}