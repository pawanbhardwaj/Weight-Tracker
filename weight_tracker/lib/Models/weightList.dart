import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightListItem extends StatelessWidget {
  final DateTime time;
  var weightDifference;
  double weight;
  String note;

  WeightListItem(this.time, this.weightDifference, this.weight, this.note);

  @override
  Widget build(BuildContext context) => Padding(
        padding: new EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Row(children: [
              new Expanded(
                  child: new Column(children: [
                new Text(
                  new DateFormat.yMMMMd().format(time),
                  textScaleFactor: 0.9,
                  textAlign: TextAlign.left,
                ),
                new Text(
                  new DateFormat.EEEE().format(time),
                  textScaleFactor: 0.8,
                  textAlign: TextAlign.right,
                  style: new TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ], crossAxisAlignment: CrossAxisAlignment.start)),
              new Expanded(
                  child: new Text(
                weight.toString() + " Kg",
                textScaleFactor: 2.0,
                textAlign: TextAlign.center,
              )),
              new Expanded(
                  child: new Text(
                weightDifference.toString(),
                textScaleFactor: 1.6,
                textAlign: TextAlign.right,
              )),
            ]),
            note != '' ? Divider() : SizedBox(),
            // SizedBox(
            //   height: 11,
            // ),
            note != '' ? Text("Note: " + '$note') : SizedBox()
          ],
        ),
      );
}
