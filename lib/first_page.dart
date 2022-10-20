import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'savings.dart';
import 'loans.dart';

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

class Page1 extends StatefulWidget{
	const Page1({ Key ? key }) : super(key : key);

  @override
  State<Page1> createState() => _Page1RouteState();

}

class _Page1RouteState extends State<Page1> {

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

  String totalAmount = "UGX ---";
  String savingsAmount = "UGX ---";
  String loansAmount = "UGX ---";

  @override
  void initState(){
    super.initState();
    fetchRecentTransactions();
  }

  List dataItems = [];

  // --------------------------------- Fetch Recent Transactions ----------------------------- 

  Future<void> fetchRecentTransactions() async{
    fetchThreeValues();

    final prefs = await SharedPreferences.getInstance();

    final String? sessionID = prefs.getString('generalSessionId');

    dataItems.clear();

    try{
      http.Response response = await http.get(Uri.parse('https://sentesave.000webhostapp.com/api/get_recent_transactions.php?userid='+sessionID!));

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

  // --------------------------------- Fetch Three Transaction Values -----------------------------
  Future<void> fetchThreeValues() async{

    final prefs = await SharedPreferences.getInstance();

    final String? sessionID = prefs.getString('generalSessionId');

    try{

      http.Response response = await http.get(Uri.parse('https://sentesave.000webhostapp.com/api/get_all_three_transactions.php?userid='+sessionID!));

      var data = jsonDecode(response.body);

      String msg = data["message"];

      if(msg.contains("Success")){

        final String? totalValue = data["total"];
        final String? savingsValue = data["savings"];
        final String? loansValue = data["loans"];

        setState((){
          totalAmount = totalValue!; 
          savingsAmount = savingsValue!;
          loansAmount = loansValue!;
        });
      }

    }catch(e){
      print('Caught three values error: $e');
    }
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
                    
                    Text(
                      'Actual balance',
                      style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      totalAmount,
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
                    ),

                  ],
                ),
              ),
            ),
          ),
        	

          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Material(
                  elevation: 5.0,
                  child: InkWell(
                    child: Container(
                      height: 100,
                      width: screenWidth * 0.45,
                      color: Colors.white,
                      child : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                          Text(
                            'Savings',
                            style: TextStyle( fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height:5.0),
                          Text(
                            savingsAmount,
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),

                        ],
                      ),
                    ),
                    onTap:(){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SavingsPage()),
                      );
                    },
                  ),
                ),
                Spacer(),
                Material(
                  elevation: 5.0,
                  child: InkWell(
                    child: Container(
                      height: 100,
                      width: screenWidth * 0.45,
                      color: Colors.white,
                      child : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                          Text(
                            'Loans',
                            style: TextStyle( fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height:5.0),
                          Text(
                            loansAmount,
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),

                        ],
                      ),
                    ),
                    onTap:(){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoansPage()),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),


          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
            ),
          ),         

        ],
    );

    var transactionsBody = Column(
      children: [

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

          _isLoading ?
          Container(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          )
          :
          Container(
            height: screenHeight * 0.3,
            alignment: Alignment.center,
            child: const Text('No transactions were found.',
            style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),  
          ),

        ],
    );

    return RefreshIndicator(
      onRefresh: (){
        return fetchRecentTransactions();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: _isDataFound ? 
          Column(
            children: <Widget>[
              Homebody,
              transactionsBody,
            ],
          )
          :
          Column(
            children: <Widget>[
              Homebody,
              bottombody,
            ],
          )
        ),
    );
  }
}

