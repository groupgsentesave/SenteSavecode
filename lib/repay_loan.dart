import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class RepayLoanPage extends StatefulWidget{
	const RepayLoanPage({ Key ? key }) : super(key : key);

  @override
  State<RepayLoanPage> createState() => _RepayLoanPageRouteState();

}

class _RepayLoanPageRouteState extends State<RepayLoanPage> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //---------------------- End Of the Top Container Variable -------------
    TextEditingController amountController1 = new TextEditingController();

    progressDialog(BuildContext context){
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 15.0), child: Text("Sending Request...")),
          ],
        ),
      );

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return alert;
        },
      );
    }

    // ------------------------------------
    Future<void> repayLoan() async{
      FocusScope.of(context).requestFocus(FocusNode()); //unfocus all inputs

      final prefs = await SharedPreferences.getInstance();

      final String? sessionID = prefs.getString('generalSessionId');

      progressDialog(context);

      try{
        Map senddata = {
          'repayLoan': 'true',
          'amount': amountController1.text,
          'userid': sessionID!,
        };

        http.Response response = await http.post(
          Uri.parse('https://sentesave.000webhostapp.com/api/repay_loan.php'),
          body: senddata,
        );

        var data = jsonDecode(response.body);

        String msg = data["message"];

        final snackBar = SnackBar(
          content: Text(msg),
        );

        if(msg.contains("Invalid")){
          //progressDialog(context);
          //print(msg);
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if(msg.contains("Failed")){
          Navigator.of(context, rootNavigator: true).pop();
          return showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Error'),
                content: Text(msg),
                actions: [
                    TextButton(
                      child: Text("Close", style: TextStyle(color: Colors.teal)),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
              );
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if(msg.contains("Success")){
          Navigator.of(context, rootNavigator: true).pop();
          return showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Success'),
                content: Text(msg),
                actions: [
                    TextButton(
                      child: Text("Close", style: TextStyle(color: Colors.teal)),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
              );
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }

      }catch(e){
        print('Caught error: $e');
      }
    }

    // ------------------------- Valid Inputs ---------------------------------
    Future<void> ValidateInputs() async{
      if(amountController1.text.isNotEmpty){
          repayLoan();
      }else if(amountController1.text.isEmpty){
        return showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Empty Fields'),
              content: Text('Please fill in the amount to repay.'),
              actions: [
                  TextButton(
                    child: Text("Close", style: TextStyle(color: Colors.teal)),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ],
            );
          },
        );
      }
    }

    var RepayLoanHomePage = Column(
        children:[

          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Easily repay your loan.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
            ),
          ), 

          Container(
            padding: const EdgeInsets.only(left:10.0, right:10.0, top:2.0, bottom:5.0),
            child: TextField(
              controller: amountController1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
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
              backgroundColor: Colors.teal,),
              child: Text('REPAY', style: TextStyle(fontSize:15.0, color: Colors.white,fontWeight: FontWeight.w600),),
              
              
              onPressed: (){
                ValidateInputs();
              },
            ),
          ),      

        ],
    );

    var mainContent = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          RepayLoanHomePage,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Repay loan"),
        backgroundColor: Colors.teal,
        elevation:1.0,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child:mainContent,
      ),
    );

  }
}

