import 'dart:convert';
import 'package:homeiot/models/data.dart';
import 'package:homeiot/providers/requests_provider.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:clay_containers/clay_containers.dart';
import 'package:provider/provider.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


void get_data(String response, requestsProvider) async{
  Future.delayed(const Duration(seconds: 2), () async{
    dynamic data = await jsonDecode(response);
    dynamic variable = await Data.fromMap(data);
    requestsProvider.data = variable;
  });
}


class _HomeScreenState extends State<HomeScreen> {
  final channel = IOWebSocketChannel.connect('ws://192.168.1.7:8000/last/');
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    final RequestProvider requestsProvider = Provider.of<RequestProvider>(context);
    return Scaffold(
      body:StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if(snapshot.hasData)
            get_data(snapshot.data, requestsProvider);
          if(!firstTime) return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [
                      0.1,
                      0.4,
                      0.6,
                      0.9
                    ],
                    colors: [
                      Colors.lightBlue[300],
                      Colors.lightBlue[200],
                      Colors.lightBlue[100],
                      Colors.lightBlue[50],
                    ]
                )
            ),
            child: ListView(
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "دما:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "BNazanin",
                          ),
                        ),
                        Text(
                          "° ${requestsProvider.data.temp.toString()}",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: "BTitr_Bold",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "فشار هوا:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "BNazanin",
                          ),
                        ),
                        Text(
                          "${requestsProvider.data.pressure.toString()}" + " hPa",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: "BTitr_Bold",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "رطوبت هوا:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "BNazanin",
                          ),
                        ),
                        Text(
                          "${requestsProvider.data.humidity.toString()} %",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: "BTitr_Bold",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "میزان رطوبت خاک گلدون:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "BNazanin",
                          ),
                        ),
                        Text(
                          requestsProvider.data.moisture.toString(),
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: "BTitr_Bold",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 50.0,),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "نیاز به آب:",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "BNazanin",
                          ),
                        ),
                        Text(
                          requestsProvider.data.moisture > 260 ? "ندارد"
                          : "دارد",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: "BTitr_Bold",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
          else {
            Future.delayed(Duration(seconds: 7),() =>
              setState(() => firstTime = false));
            return Center(
              child: Container(
                color: Colors.white,
                child: Center(
                    child: Image.asset(
                      "assets/gif/loading.gif",
                      gaplessPlayback: true,
                    )
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
