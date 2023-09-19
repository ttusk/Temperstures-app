import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'admin_home.dart';

class SetManualCall extends StatefulWidget {
  const SetManualCall({Key? key}) : super(key: key);

  @override
  State<SetManualCall> createState() => _SetManualCallState();
}

class _SetManualCallState extends State<SetManualCall> {
  DateTime dateTime = DateTime.now();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Manual calls"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        leading: BackButton(
          onPressed:  () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return AdminHome();
            }));
          },
        ),

      ),

      body: Container(
          alignment: Alignment.center,
          color: const Color(0x00d9d9d9),
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                // child: Text("${dateTime.year.toString()}-${dateTime.month.toString()}-${dateTime.day.toString()}"),
                child: Text("$dateTime"),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext contex) => SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                        backgroundColor: Colors.white,
                        initialDateTime: dateTime,
                        use24hFormat: false,
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            dateTime = newDateTime;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),

              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("manualCall")
                      .doc("00")
                      .set({'date and time': dateTime,});
                },
                child: Text("Set call"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow[600],
                ),
              ),

            ],
          )
      ),

    );
  }
}
