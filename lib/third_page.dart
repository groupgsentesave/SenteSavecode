import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'login.dart';

class Page3 extends StatefulWidget{
	const Page3({ Key ? key }) : super(key : key);

  @override
  State<Page3> createState() => _Page3RouteState();

}

class _Page3RouteState extends State<Page3> {

  String profileName = "";
  String profileEmail = "";
  String profileContact = "";

  @override
  void initState(){
    super.initState();
    fetchProfileDetails();
  }

  Future<void> logoutUser() async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> fetchProfileDetails() async{

    final prefs = await SharedPreferences.getInstance();

    final String? userID = prefs.getString('generalSessionId');
    final String? profile_email = prefs.getString('generalUserEmail');
    final String? profile_contact = prefs.getString('generalUserContact');
    final String? profile_name = prefs.getString('generalUserName');

    setState((){
      profileContact = profile_contact!; 
      profileEmail = profile_email!;
      profileName = profile_name!;
    });

  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //---------------------- End Of the Top Container Variable -------------

    var Homebody = Column(
        children:[

        	Material(
            elevation: 10.0,
            child: Container(
              color: Colors.teal[800],
              height: screenHeight * 0.3,
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset('assets/images/simple.jpg', width:screenWidth*0.36), 
                      ),
                    ),
                    const SizedBox(height:10),
                    Text(
                      profileName,
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white),
                    ),

                  ],
                ),
              ),
            ),
          ),


          Material(
            elevation: 1.0,
            child: Container(
              padding: EdgeInsets.all(15.0),
              width: screenWidth * 1.0,
              height: 70.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height:5.0),
                  Text(
                    profileEmail,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ]
              ),
            ),
          ),
          Material(
            elevation: 1.0,
            child: Container(
              padding: EdgeInsets.all(15.0),
              width: screenWidth * 1.0,
              height: 70.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile Contact',
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height:5.0),
                  Text(
                    profileContact,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ]
              ),
            ),
          ),

          Container(
            width: screenWidth * 1.0,
            padding: EdgeInsets.only(left:10.0, right:10.0),
            margin: EdgeInsets.only(top:10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(top:15.0, bottom:15.0),
              backgroundColor: Colors.red,),
              child: Text('LOGOUT', style: TextStyle(fontSize:15.0, color: Colors.white, fontWeight: FontWeight.w600),),
              
             
              onPressed: (){
                logoutUser();
              },
            ),
          ),
          


        ],
    );

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Homebody,

        ],
      ),
    );
  }
}

