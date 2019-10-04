import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    @required this.sender,
    @required this.loggedInUser,
    @required this.text,
  });

  final String sender;
  final FirebaseUser loggedInUser;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: sender == loggedInUser.email
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "from ${sender}",
            style: TextStyle(fontSize: 10),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: sender == loggedInUser.email
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
              color: sender == loggedInUser.email
                  ? Colors.lightBlueAccent
                  : Colors.grey,
            ),
            padding: EdgeInsets.all(10),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
