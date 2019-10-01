import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  String message;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(user.email);
      }
    } catch (err) {
      print(err);
    }
  }

//  void getDocuments() async {
//    final messages = await _firestore.collection("messages").getDocuments();
//    for (var message in messages.documents) {
//      print(message.data);
//    }
//  }

//  void messagesStream() async {
//    _firestore.collection("messages").snapshots().listen((data) {
//      for (var document in data.documents) {
//        print(document.data);
//      }
//    });
//    print("#################      started     #################");
//    await for (var snapshot in _firestore.collection("messages").snapshots()) {
////      print("#################      got snapshot     ###########################");
//      for (var doc in snapshot.documents) {
//        print(doc.data);
//      }
//    }
//    print("#################      finished      #################");
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
//              messagesStream();
              await _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat '),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("messages").snapshots(),
                builder: (context, snapshot) {
//                  print(snapshot.hasData);
                  if (snapshot.hasData) {
                    final messages = snapshot.data.documents;
                    List<Text> messageWidgets = [];
                    for (var message in messages) {
                      messageWidgets.add(Text(
                          "${message.data["text"]} from ${message.data["sender"]}"));
                    }
                    return Column(
                      children: messageWidgets,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      //Implement send functionality.
                      await _firestore
                          .collection("messages")
                          .add({"text": message, "sender": loggedInUser.email});
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
    );
  }
}
