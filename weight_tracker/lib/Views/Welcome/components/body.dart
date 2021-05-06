import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weight_tracker/Controllers/user.dart';

import 'package:weight_tracker/Views/Home/home.dart';
import 'package:weight_tracker/Views/Welcome/components/background.dart';

import 'package:weight_tracker/services/crud.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> signInAnonymously() async {
      try {
        await FirebaseAuth.instance.signInAnonymously();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);

        Fluttertoast.showToast(msg: "Signed in succesfully");
        saveUser(FirebaseAuth.instance.currentUser!.uid);
        uid = FirebaseAuth.instance.currentUser!.uid;
      } catch (e) {
        print(e.toString());

        Fluttertoast.showToast(msg: e.toString());
      }
    }

    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "WELCOME TO WEIGHT-TRACKER",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: "Josefin"),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.12),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  color: kPrimaryColor,
                  onPressed: signInAnonymously,
                  child: Text(
                    "Log In(Anonymous)",
                    style:
                        TextStyle(color: Colors.white, fontFamily: "Josefin"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
