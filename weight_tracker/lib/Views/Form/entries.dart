import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weight_tracker/Controllers/user.dart';

import 'package:weight_tracker/Models/date.dart';

import 'package:weight_tracker/constants.dart';
import 'package:weight_tracker/services/crud.dart';

class AddEntryDialog extends StatefulWidget {
  bool edit;
  double w;
  var d, n;
  String documentId;
  AddEntryDialog(
      {required this.edit,
      required this.d,
      required this.n,
      required this.w,
      required this.documentId});
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {
  TextEditingController note = TextEditingController();
  TextEditingController weight = TextEditingController();
  double _weight = 1.0;
  bool weightAdded = false;
  DateTime _dateTime = new DateTime.now();
  String _note = '';

  void _saveButtonClk() {
    Map<String, dynamic> data = {
      "datetime": _dateTime,
      "weight": _weight,
      "note": _note
    };

    CrudMethods().addData(data);
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Entry Added Successfully");
  }

  updateButtonClk() {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("data")
          .doc(widget.documentId)
          .update({
        "datetime": _dateTime,
        "weight": double.parse(weight.text),
        "note": note.text
      });

      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Entry updated successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.edit) {
      weight.text = widget.w.toString();
      note.text = widget.n;
      _dateTime = widget.d;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: new AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(widget.edit ? 'Update Entry' : 'New Entry',
              style: TextStyle(color: Colors.white)),
          actions: [
            new TextButton(
                onPressed: widget.edit ? updateButtonClk : _saveButtonClk,
                child: new Text(widget.edit ? 'done' : 'save',
                    style: TextStyle(color: Colors.white))),
          ],
        ),
        body: Column(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.today, color: Colors.grey[500]),
              title: new DateTimeItem(
                key: ValueKey('1'),
                dateTime: _dateTime,
                onChanged: (dateTime) => setState(() => _dateTime = dateTime),
              ),
            ),
            new ListTile(
                leading: Icon(Icons.airplay),
                title: TextField(
                    cursorColor: kPrimaryColor,
                    keyboardType: TextInputType.number,
                    maxLength: 7,
                    decoration: new InputDecoration(
                      counterText: "",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid, color: kPrimaryColor),
                      ),
                      hintText: 'Enter your weight(in kg)',
                    ),
                    controller: weight,
                    onChanged: (value) => _weight = double.parse(value))),
            new ListTile(
              leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
              title: new TextField(
                cursorColor: kPrimaryColor,
                decoration: new InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: kPrimaryColor),
                  ),
                  hintText: 'Optional note',
                ),
                controller: note,
                onChanged: (value) => _note = value,
              ),
              // trailing: note.text.isNotEmpty
              //     ? InkWell(
              //         onTap: () {
              //           note.clear();
              //         },
              //         child: Text("Clear"))
              //     : SizedBox(),
            ),
          ],
        ),
      );
}
