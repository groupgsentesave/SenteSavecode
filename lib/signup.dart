import 'package:flutter/material.dart';

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
        child:MySignupPage(),
      ),
    );
  }
}

class MySignupPage extends StatefulWidget{
  const MySignupPage({ Key ? key }) : super(key: key );

  @override
  _MySignupPageState createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage>{
  TextEditingController emailController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();

  // Checkbox validation
  bool agree = false;

  void _doSomething(){
    print('Chekbox was actiavted');
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var Signupbody = Column(
        children:[

          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sign up to SenteSave and continue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, color: Colors.teal, fontWeight: FontWeight.w600),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(top:6.0, bottom:10.0, left:10.0, right:10.0),
            margin: EdgeInsets.only(bottom: 10.0),
            child: const Text(
              'Enter your account details below to begin saving and applying for loans on SenteSave',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: Colors.blue, fontWeight: FontWeight.w400),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left:10.0, right:10.0, top:2.0, bottom:5.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full Name',
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left:10.0, right:10.0, top:2.0, bottom:5.0),
            margin: EdgeInsets.only(top:5.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left:10.0, right:10.0, top:2.0, bottom:5.0),
            margin: EdgeInsets.only(top:5.0),
            child: TextField(
              controller: contactController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Contact',
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left:10.0, right:10.0, top:2.0, bottom:5.0),
            margin: EdgeInsets.only(top:5.0),
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
            padding: const EdgeInsets.only(left:10.0, right:10.0, top:2.0, bottom:5.0),
            margin: EdgeInsets.only(top:5.0),
            child: Row(
              children: [
                Material(
                  child: Checkbox(
                    value: agree,
                    onChanged: (value){
                      setState((){
                        agree = value ?? false;
                      });
                    }
                  ),
                ),
                Flexible(
                  child: const Text(
                    'I have read and accept terms and conditons'
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: screenWidth * 1.0,
            padding: EdgeInsets.only(left:10.0, right:10.0),
            margin: EdgeInsets.only(top:10.0),
            child:  ElevatedButton(
              style: ElevatedButton.styleFrom(
              padding:  EdgeInsets.only(top:15.0, bottom:15.0),
              backgroundColor: Colors.teal,
              ),
              child: Text('SIGNUP', style: TextStyle(fontSize:15.0,color: Colors.white, fontWeight: FontWeight.w600),),
              
              
            
              
              onPressed: (){
                print(emailController);
              },
            ),
          ),

          Row(

            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(top: 17, left:10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Already have an account?', style: TextStyle(fontSize:15.0, fontWeight: FontWeight.w700),),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 17, left:10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                     style: TextButton.styleFrom(

                     padding: EdgeInsets.all(0.0),
                     backgroundColor: Colors.white,),
                    child: Text('Sign In', style: TextStyle(fontSize:15.0, color: Colors.blue,fontWeight: FontWeight.w700), textAlign: TextAlign.right),
                    
                    
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
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