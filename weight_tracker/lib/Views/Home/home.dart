import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/Controllers/user.dart';

import 'package:weight_tracker/Models/weightList.dart';
import 'package:weight_tracker/Views/Form/entries.dart';
import 'package:weight_tracker/Views/Welcome/welcome_screen.dart';

import 'package:weight_tracker/constants.dart';
import 'package:weight_tracker/splash.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController sc = ScrollController();
  _addWeight() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return AddEntryDialog(
        documentId: "",
        d: '', // d: datetime
        edit: false,
        w: 0, // w: weight
        n: '', // n: note(if any)
      );
    }));
  }

  retrieveId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.getString('uid')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(uid);
    retrieveId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text('Weight Tracker', style: TextStyle(color: Colors.white)),
        // centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              // since the app is based on anonamous authentification , the user if logged out will never be able to login again i.e it will not persist as the Firebase delets the user.

              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Text('Are you sure?'),
                            ),
                          ],
                        ),
                        content: Text(
                          'All your entries would be lost. You can start tracking by logging again.',
                        ),
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.5000000286102295,
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    print(uid);
                                    Navigator.pop(context);

                                    try {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(uid)
                                          .delete();
                                      FirebaseAuth.instance.signOut();
                                    } catch (e) {
                                      print(e.toString());
                                    }

                                    SharedPreferences.getInstance()
                                        .then((value) {
                                      value.clear();
                                    });
                                    print(uid);
                                    Fluttertoast.showToast(
                                        msg: "Logged out successfully");
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WelcomeScreen()));
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.5000000286102295,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ));
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 11,
                ),
                Text(
                  "History",
                  style: TextStyle(fontSize: 25, fontFamily: "Quicksand"),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("data")
                        .orderBy("datetime", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.docs.length != 0
                            ? ListView.builder(
                                controller: sc,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  double difference;
                                  bool lastindex =
                                      index + 1 == snapshot.data!.docs.length
                                          ? true
                                          : false;
                                  if (!lastindex) {
                                    double weightSave = snapshot
                                        .data!.docs[index + 1]["weight"];

                                    double currentWeight =
                                        snapshot.data!.docs[index]["weight"];

                                    difference = currentWeight - weightSave;
                                  } else {
                                    difference = 0;
                                  }

                                  return Dismissible(
                                      background: slideLeftBackground(),
                                      onDismissed: (right) {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(uid)
                                            .collection("data")
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();
                                        Fluttertoast.showToast(
                                            msg: "Entry removed successfully");
                                      },
                                      key: Key(snapshot.data!.docs[index].id),
                                      child: GestureDetector(
                                        onLongPress: () {
                                          Fluttertoast.showToast(
                                              msg: "Edit mode");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddEntryDialog(
                                                          edit: true,
                                                          d: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ["datetime"]
                                                              .toDate(),
                                                          n: snapshot.data!
                                                                  .docs[index]
                                                              ["note"],
                                                          documentId: snapshot
                                                              .data!
                                                              .docs[index]
                                                              .id,
                                                          w: snapshot.data!
                                                                  .docs[index]
                                                              ["weight"])));
                                        },
                                        child: WeightListItem(
                                          snapshot.data!.docs[index]["datetime"]
                                              .toDate(),
                                          difference,
                                          snapshot.data!.docs[index]["weight"],
                                          snapshot.data!.docs[index]["note"],
                                        ),
                                      ));
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 21),
                                child: Text("No past entries available"),
                              );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 51),
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          ),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add entry"),
        backgroundColor: kPrimaryColor,
        onPressed: _addWeight,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "X",
                  style: TextStyle(color: Colors.white),
                )),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
