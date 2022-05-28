// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rechner_begrenztes_wachstum/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class AppInfo {
  String title;
  String version;
  AppInfo({required this.title, required this.version});
}

AppInfo appInfo = AppInfo(title: "Rechner für begrenztes Wachstum", version: "V1.1.1");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appInfo.title,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
