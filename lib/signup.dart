import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'login.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MySignupPage(),
      ),
    );
  }
}

class MySignupPage extends StatefulWidget {
  const MySignupPage({Key? key}) : super(key: key);

  @override
  _MySignupPageState createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();

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
    Future<void> signupUser() async {
      FocusScope.of(context).requestFocus(FocusNode()); //unfocus all inputs

      final prefs = await SharedPreferences.getInstance();

      progressDialog(context);

      try {
        Map senddata = {
          'createAccount': 'true',
          'email': emailController.text,
          'pincode': pinController.text,
          'name': nameController.text,
          'contact': contactController.text,
        };

        http.Response response = await http.post(
          Uri.parse(
              'https://sentesave.000webhostapp.com/api/create_account.php'),
          body: senddata,
        );

        var data = jsonDecode(response.body);

        String msg = data["message"];

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

          Timer timer = Timer(Duration(milliseconds: 200), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          });
        }
      } catch (e) {
        print('Caught error: $e');
      }
    }

    // ------------------------- Valid Inputs ---------------------------------
    Future<void> ValidateInputs() async {
      if (emailController.text.isNotEmpty ||
          pinController.text.isNotEmpty ||
          nameController.text.isNotEmpty ||
          contactController.text.isNotEmpty) {
        signupUser();
      } else if (emailController.text.isEmpty ||
          pinController.text.isEmpty ||
          nameController.text.isEmpty ||
          contactController.text.isEmpty) {
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

    var Signupbody = Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Sign up to SenteSave and continue',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25, color: Colors.teal, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              top: 6.0, bottom: 10.0, left: 10.0, right: 10.0),
          margin: EdgeInsets.only(bottom: 10.0),
          child: const Text(
            'Enter your account details below to begin saving and applying for loans on SenteSave',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17, color: Colors.blue, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Full Name',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
          margin: EdgeInsets.only(top: 5.0),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
          margin: EdgeInsets.only(top: 5.0),
          child: TextField(
            controller: contactController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phone Contact',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
          margin: EdgeInsets.only(top: 5.0),
          child: TextField(
            controller: pinController,
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
              'SIGNUP',
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
                  'Already have an account?',
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
                    child: Text('Sign In',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.right),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
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
            Signupbody,
          ],
        ),
      ),
    );
  }
}
