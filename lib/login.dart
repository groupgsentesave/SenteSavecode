import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'signup.dart';
import 'home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MyLoginPage(),
      ),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextEditingController emailController1 = new TextEditingController();
  TextEditingController pinController1 = new TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    progressDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(left: 15.0), child: Text("Loading...")),
          ],
        ),
      );

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    // ------------------------------------
    Future<void> loginUser() async {
      FocusScope.of(context).requestFocus(FocusNode()); //unfocus all inputs

      final prefs = await SharedPreferences.getInstance();

      if (isLoading) {
        progressDialog(context);
      }

      setState(() {
        isLoading = true;
      });
      try {
        Map senddata = {
          'loginAccount': 'true',
          'email': emailController1.text,
          'pincode': pinController1.text
        };

        http.Response response = await http.post(
          Uri.parse(
              'https://sentesave.000webhostapp.com/api/login_account.php'),
          body: senddata,
        );

        var data = jsonDecode(response.body);

        String msg = data["message"];
        print(msg);

        final snackBar = SnackBar(
          content: Text(msg),
        );

        if (msg.contains("Invalid")) {
          //progressDialog(context);
          //print(msg);
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (msg.contains("Failed")) {
          //progressDialog(context);
          //print(msg);
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (msg.contains("Success")) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          String userID = data["userId"];
          String userEmail = data["userEmail"];
          String userContact = data["userContact"];
          String userName = data["userName"];

          await prefs.setString('generalSessionId', userID);
          await prefs.setString('generalUserEmail', userEmail);
          await prefs.setString('generalUserContact', userContact);
          await prefs.setString('generalUserName', userName);

          Timer timer = Timer(Duration(milliseconds: 400), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (route) => false,
            );
          });
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Caught error: $e');
      }

      setState(() {
        isLoading = false;
      });
    }

    // ------------------------- Valid Inputs ---------------------------------
    Future<void> ValidateInputs() async {
      if (emailController1.text.isNotEmpty && pinController1.text.isNotEmpty) {
        loginUser();
      } else if (emailController1.text.isEmpty || pinController1.text.isEmpty) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Empty Fields'),
              content: Text('Please fill in all fields.'),
              actions: [
                TextButton(
                  child: Text("Close", style: TextStyle(color: Colors.teal)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    var loginbody = Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 50.0),
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              'SenteSave',
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w800,
                  fontSize: 30.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 15.0),
          child: Image.asset(
            'assets/images/loginimage.jpg',
            width: screenWidth * 0.7,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 14.0),
          child: const Text(
            'Welcome Back, Please Login',
            style: TextStyle(
                fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
          child: TextField(
            controller: emailController1,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
          margin: EdgeInsets.only(top: 8.0),
          child: TextField(
            controller: pinController1,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Pincode',
            ),
          ),
        ),
        Container(
          width: screenWidth * 1.0,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          margin: EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              backgroundColor: Colors.teal,
            ),
            child: Text(
              'LOGIN',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              ValidateInputs();
            },
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 17, left: 10),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Have no account',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 17, left: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(0.0),
                      backgroundColor: Colors.white,
                    ),
                    child: Text('Sign Up',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.right),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            loginbody,
          ],
        ),
      ),
    );
  }
}
