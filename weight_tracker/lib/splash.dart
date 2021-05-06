import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/user.dart';
import 'Views/Home/home.dart';
import 'Views/Welcome/welcome_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString('uid') != null) {
      // checking the persistence if the previous user is still there.
      uid = pref.getString('uid')!;
      print(uid);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WelcomeScreen()), // This is the case that user is newly logging in.
          (route) => false);
    }
  }

  startTime() {
    return Timer(Duration(seconds: 1), getUser);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          "assets/images/weighing-machine.svg",
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      ),
    );
  }
}
