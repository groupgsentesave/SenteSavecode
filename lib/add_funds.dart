import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class AddFundsPage extends StatefulWidget{
	const AddFundsPage({ Key ? key }) : super(key : key);

  @override
  State<AddFundsPage> createState() => _AddFundsPageRouteState();

}

class _AddFundsPageRouteState extends State<AddFundsPage> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController amountController1 = new TextEditingController();

    progressDialog(BuildContext context){
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 15.0), child: Text("Adding Funds...")),
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
    Future<void> depositFunds() async{
      FocusScope.of(context).requestFocus(FocusNode()); //unfocus all inputs

      final prefs = await SharedPreferences.getInstance();

      final String? sessionID = prefs.getString('generalSessionId');

      progressDialog(context);

      try{
        Map senddata = {
          'addFunds': 'true',
          'amount': amountController1.text,
          'userid': sessionID!,
        };

        http.Response response = await http.post(
          Uri.parse('https://sentesave.000webhostapp.com/api/add_funds.php'),
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
          //progressDialog(context);
          //print(msg);
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if(msg.contains("Success")){
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }

      }catch(e){
        print('Caught error: $e');
      }
    }

    // ------------------------- Valid Inputs ---------------------------------
    Future<void> ValidateInputs() async{
      if(amountController1.text.isNotEmpty){
          depositFunds();
      }else if(amountController1.text.isEmpty){
        return showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Empty Fields'),
              content: Text('Please fill in the amount to deposit.'),
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

    //---------------------- End Of the Top Container Variable -------------

    var AddFundsHomePage = Column(
        children:[

          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Add funds to your savings account so that you can easily make payments.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
            ),
          ), 

          Container(
            padding: const EdgeInsets.only(left:10.0, right:10.0, top:2.0, bottom:5.0),
            child: TextField(
              controller: amountController1,
              keyboardType: TextInputType.number,
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
              child: Text('DEPOSIT', style: TextStyle(fontSize:15.0,color: Colors.white, fontWeight: FontWeight.w600),),
              
              
              onPressed: (){
                ValidateInputs();
              },
            ),
          ),      

        ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Funds"),
        backgroundColor: Colors.teal,
        elevation:1.0,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child:AddFundsHomePage,
      ),
    );

  }
}

