import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';


String text = "";

class Readings extends StatefulWidget {
  const Readings({Key? key}) : super(key: key);
  @override
  State<Readings> createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {

   // final ref = FirebaseDatabase.instance.ref('temp');
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
      'https://temps-app-c38b5-default-rtdb.europe-west1.firebasedatabase.app')
      .ref("temp");

  // String text = "Stop service";

  // String text = "";

  Future<void> checkText() async {
    final service = FlutterBackgroundService();
    bool isRunning = await service.isRunning();

    if(isRunning){
      text = "Stop Service";
    } else {
      text = "Start Service";
    }
  }

  @override
  void initState() {
    super.initState();
    checkText();
    print("check text");
    setState(() {
      checkText();
    });
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    checkText();
  }

  // final ref = FirebaseDatabase.getInstance("https://temps-app-c38b5-default-rtdb.europe-west1.firebasedatabase.app");

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Readings"),
      ),
      body: Container(
        alignment: Alignment.center,
        color: const Color(0x00d9d9d9),
          padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
                child: FirebaseAnimatedList(
                  query: ref, itemBuilder: (context, DataSnapshot snapshot, animation, index) {
                  String t = snapshot.child('temp').value.toString();
                  double temp = double.parse(t);
                  print(temp);
                  // print(ref.key);

                    return ListTile(
                      title: Text(snapshot.child('temp').value.toString() + "°C"),
                      subtitle: Text(snapshot.child('time').value.toString()),
                      trailing: Text(snapshot.child('date').value.toString()),
                    );
                }
                ),
            ),

            ElevatedButton(onPressed: () {
              FlutterBackgroundService().invoke('setAsBackground');
            }, child: Text("Background service")
            ),

            ElevatedButton(onPressed: () {
              FlutterBackgroundService().invoke('setAsForeground');
            }, child: Text("Foreground service")
            ),

            ElevatedButton(onPressed: () async {
              // checkText();
              final service = FlutterBackgroundService();
              bool isRunning = await service.isRunning();

              if(isRunning) {
                service.invoke('stopService');
              }else {
                service.startService();
              }

              if(!isRunning){
                text = "Stop Service";
              } else {
                text = "Start Service";
              }
              setState(() {});
            }, child: Text("$text"),
            ),
          ],
        ),
      ),
    );
  }
}



