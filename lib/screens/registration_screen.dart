import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registration";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showLoading = false;
  bool hasSubmittedForm = false;
  AnimationController controller;

  AnimationController createController() {
    var cont = AnimationController(
        duration: Duration(milliseconds: 200), vsync: this, upperBound: 0.9);
    cont.addListener(() {
      setState(() {});
    });
    return cont;
  }

  void getCurrentUser() async {
    print("from registration ${(await _auth.currentUser()).email}");
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: "logo",
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
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your email",
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password",
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  color: Colors.blueAccent,
                  text: "Register",
                  onPressed: () async {
                    if (!hasSubmittedForm) {
                      hasSubmittedForm = true;
                      try {
                        setState(() {
                          controller = createController();
                          controller.forward();
                          showLoading = true;
                        });
                        AuthResult authResult =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        await Navigator.pushNamed(context, ChatScreen.id);
                        setState(() {
                          hasSubmittedForm = false;
                          showLoading = false;
                          controller.dispose();
                          controller = null;
                        });
                      } catch (err) {
                        print("error");
                        print(err);
                        setState(() {
                          hasSubmittedForm = false;
                          showLoading = false;
                          controller.dispose();
                          controller = null;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          showLoading
              ? Container(
                  color: Colors.black.withOpacity(controller.value),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SpinKitDoubleBounce(
                        color: Colors.red,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Registering User",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                          ),
                          TypewriterAnimatedTextKit(
                            text: ['...'],
                            duration: Duration(milliseconds: 3000),
                            textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
