import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SenteSave',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage1(title: 'SenteSave'),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage1> createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  
  String _isChecking = "neutral";

  @override
  void initState(){
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async{

    final prefs = await SharedPreferences.getInstance();

    if(prefs.containsKey("generalSessionId")){
      setState((){
        _isChecking = "true";
      });
    }else{
      setState((){
        _isChecking = "false";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    if(_isChecking == "neutral"){
      return Scaffold(
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
          ),
        ),
      );
    }else if(_isChecking == "true"){
      return Scaffold(
        body: MyHomePage(),
      );
    }else{
      return Scaffold(
        body: LoginPage(),
      );
    }

  }
}
