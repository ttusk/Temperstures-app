import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temps_app/manual_calls.dart';

import 'admin_home.dart';

class SetManualCall extends StatefulWidget {
  const SetManualCall({Key? key}) : super(key: key);

  @override
  State<SetManualCall> createState() => _SetManualCallState();
}

class _SetManualCallState extends State<SetManualCall> {
  DateTime dateTime = DateTime.now();

  TextEditingController _messageController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Set a manual call"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        leading: BackButton(
          onPressed:  () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return ManualCalls();
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
              Text("Select date and time",
                  style: TextStyle(fontSize: 20)
              ),

              SizedBox(
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


              TextField(
                controller: _messageController,
                minLines: 3,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: "Message",
                  hintText: "Enter message",

                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),



              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("manualCall")
                      .doc()
                      .set({'date and time': dateTime, 'message': _messageController.text.toString()});

                  showDialog(context: context,
                    builder: (context) => AlertDialog(
                      actions: [
                        TextButton(onPressed: () {
                          Navigator.of(context).pop();

                        },
                            child: Text("Ok!")
                        )
                      ],
                      title: Text("Manual Call"),

                      content: Text("Call has been set and will ring 30 mins before $dateTime."),
                    ),
                  );
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
