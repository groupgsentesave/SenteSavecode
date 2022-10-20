import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class WithdrawFundsPage extends StatefulWidget{
	const WithdrawFundsPage({ Key ? key }) : super(key : key);

  @override
  State<WithdrawFundsPage> createState() => _WithdrawFundsPageRouteState();

}

class _WithdrawFundsPageRouteState extends State<WithdrawFundsPage> {

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TextEditingController amountController1 = new TextEditingController();
    TextEditingController contactController1 = new TextEditingController();

    progressDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 15.0), child: Text("Withdrawing Funds...")),
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
  Future<void> withdrawFunds() async{
    FocusScope.of(context).requestFocus(FocusNode()); //unfocus all inputs

    final prefs = await SharedPreferences.getInstance();

    final String? sessionID = prefs.getString('generalSessionId');

    progressDialog(context);

    try{
      Map senddata = {
        'withdrawFunds': 'true',
        'amount': amountController1.text,
        'userid': sessionID!,
        'contact': contactController1.text,
      };

      http.Response response = await http.post(
        Uri.parse('https://sentesave.000webhostapp.com/api/withdraw_funds.php'),
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
              title: Text('Insufficient Balance'),
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
    if(amountController1.text.isNotEmpty || contactController1.text.isNotEmpty){
        withdrawFunds();
    }else if(amountController1.text.isEmpty || contactController1.text.isEmpty){
      return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Empty Fields'),
            content: Text('Please fill in the amount to withdraw.'),
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

    var WithdrawFundsHomePage = Column(
        children:[

          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Withdraw funds to your mobile money account',
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
            padding: const EdgeInsets.only(left:10.0, right:10.0, top:2.0, bottom:5.0),
            child: TextField(
              controller: contactController1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mobile Contact',
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
              child: Text('WITHDRAW', style: TextStyle(fontSize:15.0,color: Colors.white, fontWeight: FontWeight.w600),),
              
              
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
          WithdrawFundsHomePage,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Widthdraw Funds"),
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

