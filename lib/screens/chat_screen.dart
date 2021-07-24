import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _firestore = FirebaseFirestore.instance;
var loggedUser;

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textMassageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String massage;

  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser.email);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }

  void getMassages() async {
    await for (var snapshots in _firestore.collection('massages').snapshots()) {
      for (var massage in snapshots.docs) {
        print(massage.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MassageStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textMassageController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (String value) {
                          massage = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        //Implement send functionality.
                        await _firestore.collection('massages').doc().set({
                          'sender': loggedUser.email,
                          'massage': massage,
                        });
                        textMassageController.clear();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MassageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('massages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<BubbleMassage> massagesText = [];
          final massages = snapshot.data.docs.reversed;
          for (var massage in massages) {
            final String massageText = massage['massage'];
            final String massageSender = massage['sender'];
            final String currentUser = FirebaseAuth.instance.currentUser.email;
            final massageBubble = BubbleMassage(
                massageText: massageText, massageSender: massageSender, isMe: currentUser == massageSender,);
            massagesText.add(massageBubble);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              children: massagesText,
            ),
          );
        });
  }
}

class BubbleMassage extends StatelessWidget {
   BubbleMassage({
      Key key,
      @required this.massageText,
      @required this.massageSender,
      @required this.isMe,
  }) : super(key: key);

  final String massageText;
  final String massageSender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.start: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '$massageSender',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          Material(
            elevation: 10.0,
            borderRadius: isMe? BorderRadius.only(topRight: Radius.circular(30.0), bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)) : BorderRadius.only(topLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)) ,
            color: isMe? Colors.lightBlue : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$massageText',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
