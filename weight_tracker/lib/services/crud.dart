import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrudMethods {
  Future<void> addData(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString('uid'));
    print(data);
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(preferences.getString('uid'))
          .collection("data")
          .doc()
          .set(data);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
