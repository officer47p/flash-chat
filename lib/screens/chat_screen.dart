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
  TextEditingController controller = TextEditingController();

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
                stream: _firestore
                    .collection("messages")
//                    .orderBy("_timeStampUTC", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
//                  print(snapshot.hasData);
                  if (snapshot.hasData) {
                    final messages = snapshot.data.documents;
                    List<Widget> messageWidgets = [];
                    for (var message in messages) {
                      messageWidgets.add(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment:
                                loggedInUser.email == message.data["sender"]
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                " from ${message.data["sender"]}",
                                style: TextStyle(fontSize: 10),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: loggedInUser.email ==
                                          message.data["sender"]
                                      ? Colors.lightBlueAccent
                                      : Colors.grey,
                                ),
                                child: Text(
                                  "${message.data["text"]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        children: messageWidgets,
                      ),
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
                      controller: controller,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      //Implement send functionality.
                      controller.clear();
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
