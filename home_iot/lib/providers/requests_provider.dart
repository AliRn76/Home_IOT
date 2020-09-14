
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

import 'package:homeiot/models/data.dart';

class RequestProvider extends ChangeNotifier{

  RequestProvider(){}

  Data _data;

  Data get data => _data;

  set data(Data value){
    _data = value;
    notifyListeners();
  }
}