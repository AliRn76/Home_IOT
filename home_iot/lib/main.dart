import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homeiot/screens/home_screen.dart';

import 'package:homeiot/providers/requests_provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RequestProvider>.value(value: RequestProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
