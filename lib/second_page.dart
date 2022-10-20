import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

import 'dart:convert';

class CardItem{
  final String transactionTitle;
  final String transactionDate;
  final String transactionAmount;
  final String transactionType;

  const CardItem({
    required this.transactionTitle,
    required this.transactionDate,
    required this.transactionAmount,
    required this.transactionType,

  });
}

class Page2 extends StatefulWidget{
	const Page2({ Key ? key }) : super(key : key);

  @override
  State<Page2> createState() => _Page2RouteState();

}

class _Page2RouteState extends State<Page2> {

  Widget buildCard({ required CardItem item }) => Container(
    child: Material(
      child: ListTile(
        leading: Icon(Icons.arrow_circle_down, color: item.transactionType == "deposit" ? Colors.green : Colors.red ),
        minLeadingWidth: 20,
        title: Text(item.transactionTitle),
        subtitle: Text(item.transactionDate),
        trailing: Text(item.transactionType == "deposit" ? "+"+item.transactionAmount : "-"+item.transactionAmount, style: TextStyle(color: item.transactionType == "deposit" ? Colors.green : Colors.red )),
        shape: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
        onTap: (){},
      ),
    ),
  );

  bool _isLoading = true;
  bool _isDataFound = true;

  @override
  void initState(){
    super.initState();
    fetchTransactions();
  }

  List dataItems = [
  ];

  Future<void> fetchTransactions() async{

    final prefs = await SharedPreferences.getInstance();

    final String? sessionID = prefs.getString('generalSessionId');

    dataItems.clear();

    try{
      http.Response response = await http.get(Uri.parse('https://sentesave.000webhostapp.com/api/get_all_transactions.php?userid='+sessionID!));

      List data = jsonDecode(response.body);

      data.forEach((element){
        Map obj = element;

          var transaction_title = obj["description"];
          String transaction_date = obj["datemade"];
          String transaction_amount = obj["amount"];
          String transaction_type = obj["type"];

          CardItem item = CardItem(
            transactionTitle: transaction_title,
            transactionDate: transaction_date,
            transactionAmount: transaction_amount,
            transactionType: transaction_type,
          );

          dataItems.add(item);
          
      });

      setState((){
        _isLoading = false;
        _isDataFound = true;
      });

    }catch(e){
      setState((){
        _isLoading = false;
        _isDataFound = false;
      });
      print('Caught error: $e');
    }
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //---------------------- End Of the Top Container Variable -------------

    var Homebody = Column(
        children:[

          Container(
            height: screenHeight * 0.03,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(1.0),
            padding: EdgeInsets.only(left:20.0),
            child: const Text('A summary of all your transactions'),  
          ),

        	ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataItems.length,
            itemBuilder: (BuildContext context, index) => buildCard(item: dataItems[index])
          ),

        ],
    );

    var bottombody = Column(
        children:[

          Container(
            height: screenHeight * 0.3,
            alignment: Alignment.center,
            child: const Text('No transactions were found.',
            style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),  
          ),

        ],
    );

    return _isLoading ?
     const Center(
      child: CircularProgressIndicator(
        color: Colors.teal,
      ),
    )
    :
    RefreshIndicator(
      onRefresh: (){
        return fetchTransactions();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: _isDataFound ? 
          Column(
            children: <Widget>[
              Homebody,
            ],
          )
          :
          Column(
            children: <Widget>[
              bottombody,
            ],
          )
        ),
    );
  }
}

