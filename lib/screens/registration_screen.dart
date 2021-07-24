import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  bool isPassword = true;
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void deposit(){
    super.dispose();
    email = password = null;
    isLoading = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: kEmailInputDecoration,
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: isPassword,
              style: TextStyle(fontSize: 17.0, color: Colors.black),
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: KPasswordInputDecoration,
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    //Implement registration functionality.
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    try {
                      if (user != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    } catch (error) {
                      Fluttertoast.showToast(
                          msg: error.toString(),
                          fontSize: 16.0,
                          backgroundColor: Colors.red,
                          gravity: ToastGravity.BOTTOM);
                      print(error.toString());
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: ConditionalBuilder(
                    condition: !isLoading,
                    builder: (context) =>  Text(
                      'Register',
                    ),
                    fallback: (context) => Center(child: CircularProgressIndicator(backgroundColor: Colors.white,)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
