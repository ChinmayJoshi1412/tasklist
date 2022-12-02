import 'package:flutter/material.dart';
import 'package:tasklist/screens/home.dart';
import 'dart:async';
import 'package:page_transition/page_transition.dart';
class Welcome extends StatefulWidget {
  const Welcome({Key key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 4),
        ()=>(Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.fade,child: Home(),duration: Duration(milliseconds: 400))))
    );
    return Scaffold(
      backgroundColor: Colors.redAccent[400],
      body: SafeArea(
        child: Center(
          child: Image(image: AssetImage('assets/symbol.png'),width: 200,height: 200,)
        ),
      ),
    );
  }
}
