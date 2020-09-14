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
  final channel = IOWebSocketChannel.connect('ws://192.168.1.7:8000/moisture/');
//  final channel = IOWebSocketChannel.connect('ws://al1.best:84/moisture/');
  int timer = 0;
  @override
  Widget build(BuildContext context) {
    final RequestProvider requestsProvider = Provider.of<RequestProvider>(context);
    Data _data = requestsProvider.data;
//    if(_data.temp != null)
//      print(_data.temp);
    if(timer < 10)
      timer ++;
    return Scaffold(
      body:StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if(snapshot.hasData)
            get_data(snapshot.data, requestsProvider);
          if(requestsProvider.data != null && timer == 10)
            return SafeArea(
              child: Container(
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
//                  Divider(
//                    thickness: 1,
//                    height: 1,
//                  ),
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
//                  Directionality(
//                    textDirection: TextDirection.rtl,
//                    child: Padding(
//                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Text(
//                            "نیاز به آب:",
//                            style: TextStyle(
//                              fontSize: 18.0,
//                              fontWeight: FontWeight.bold,
//                              fontFamily: "BNazanin",
//                            ),
//                          ),
//                          Text(
//                            "ندارد",
//                            style: TextStyle(
//                              fontSize: 13.0,
//                              fontFamily: "BTitr_Bold",
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  Divider(
//                    thickness: 1,
//                    height: 1,
//                  ),
//                  Padding(
//                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
//                    child: ClayContainer(
//                        height: MediaQuery.of(context).size.width * 0.65,
//                        color: Colors.lightBlue[50],
//                        depth: 50,
//                        spread: 3,
//                        borderRadius: 5,
//                        child: _buildChart()
//                    ),
//                  ),
                  ],
                ),
              ),
            );
          else
            return SafeArea(
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
        },
      ),
    );
  }


  _buildChart(){
    return charts.LineChart(_createSampleData(),
        defaultRenderer:
        charts.LineRendererConfig(includeArea: true, stacked: true)
    );
  }

  List<charts.Series<LinearValue, int>> _createSampleData() {
    final List<LinearValue>myFakeTabletData = [];
    var rng = Random();
    for(int i=0 ; i<5 ; i++){
      myFakeTabletData.add(LinearValue(i, rng.nextInt(100)));
    }

    final List<LinearValue>myFakeDesktopData = [];
    for(int i=0 ; i<5 ; i++){
      myFakeDesktopData.add(LinearValue(i, rng.nextInt(100)));
    }

    final List<LinearValue>myFakeMobileData = [];
    for(int i=0 ; i<5 ; i++){
      myFakeMobileData.add(LinearValue(i, rng.nextInt(100)));
    }

    final List<LinearValue>data2 = [];
    for(int i=0 ; i<5 ; i++){
      data2.add(LinearValue(i, rng.nextInt(100)));
    }

    return [
      new charts.Series<LinearValue, int>(
        id: 'Moisture',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.value,
        data: myFakeDesktopData,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Temp',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.value,
        data: myFakeTabletData,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Pressure',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.value,
        data: myFakeMobileData,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Humidity',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.value,
        data: data2,
      ),
    ];
  }
}

/// Sample linear data type.
class LinearValue {
  final int time;
  final int value;

  LinearValue(this.time, this.value);
}
