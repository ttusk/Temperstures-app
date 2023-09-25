import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';


// DatabaseReference ref = FirebaseDatabase.instanceFor(
//     app: Firebase.app(),
//     databaseURL:
//     'https://temps-app-c38b5-default-rtdb.europe-west1.firebasedatabase.app')
//     .ref("temp");


Future<void> initializeService() async{
  final service = FlutterBackgroundService();
  await service.configure(iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async{
  DartPluginRegistrant.ensureInitialized();
  if(service is AndroidServiceInstance){
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();

  });


  String? id;
  String? name;

  Future<void> getUserID() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id");
  }


  Future<void> getName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name");
  }


  List<String> items = [];
  getManualCallsList() async {
    var collection = FirebaseFirestore.instance.collection("manualCall");
    var data = await collection.get();
    data.docs.forEach((element) {
      items.add(element.data()["date and time"].toDate().toString());
    });

  }




  void sendLogs(String status){
    getName();
    print(name);
    DateTime now = DateTime.now();
    DateTime date =  DateTime(now.year, now.month, now.day);

    // User? user;
    // user = FirebaseAuth.instance.currentUser;
    // CollectionReference users = FirebaseFirestore.instance.collection(date.toString());
    //
    //
    // FirebaseFirestore.instance
    //     .collection(date.toString())
    //     .doc(id)
    //     .set({'name': name, 'date and time': now, 'id': id, 'status': status});


    //testing this bit

    String timestmap = now.year.toString() + "-" + now.month.toString() + "-" + now.day.toString();

    FirebaseFirestore.instance.collection("prevCalls").doc(timestmap).set({"uhm": "uhm"});
    
    FirebaseFirestore.instance.collection("prevCalls")
        .doc(timestmap)
        .collection("names")
        .doc(id)
        .set({'name': name, 'date and time': now, 'id': id, 'status': status});


  }





  void call() async{
    print("MORE");
    await (() async {
      CallKitParams params = const CallKitParams(
        id: "21232dgfgbcbgb",
        nameCaller: "TEMPERATURE IS ABOVE 30",
        appName: "Temperature App",
        avatar: "https://i.pravata.cc/100",
        handle: "",
        type: 0,
        textAccept: "Accept",
        textDecline: "Decline",
        // textMissedCall: "Missed call",
        // textCallback: "Call back",
        duration: 30000,
        extra: {'userId':"sdhsjjfhuwhf"},
        android: AndroidParams(
            isCustomNotification: false,
            isShowLogo: false,
            // isShowCallback: false,
            // isShowMissedCallNotification: true,
            ringtonePath: 'system_ringtone_default',
            backgroundColor: "#0955fa",
            backgroundUrl: "https://i.pravata.cc/500",
            actionColor: "#4CAF50",
            incomingCallNotificationChannelName: "Incoming call",
            missedCallNotificationChannelName: "Missed call",

        ),
      );
      await FlutterCallkitIncoming.showCallkitIncoming(params);

    })();

    FlutterCallkitIncoming.onEvent.listen((params){
      switch (params!.event){
        case Event.actionCallAccept:
          // service.invoke('stopService');
          sendLogs("accepted");
          service.stopSelf();
          print("call accepted lol");
          SystemNavigator.pop();
          break;

        case Event.actionCallDecline:
          // service.invoke('stopService');
          sendLogs("declined");
          service.stopSelf();
          print("call declined lol");
          break;
      }

    }  );

  }



  // Timer.periodic(const Duration(seconds: 1), (timer) async {
  //   // user = FirebaseAuth.instance.currentUser;
  //   // print(user?.uid.toString());
  //
  //
  //     if (service is AndroidServiceInstance) {
  //       if (await service.isForegroundService()) {
  //         service.setForegroundNotificationInfo(
  //             title: "Room Temperature", content: "°C");
  //       }
  //     }
  //
  //
  //
  //   // perform some operations on background which isn't noticeable to the user
  //   print("background service running");
  //   service.invoke('update');
  // });

  Firebase.initializeApp().then((_value) {
    getName();
    getUserID();
    getManualCallsList();

    DatabaseReference ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
        'https://temps-app-c38b5-default-rtdb.europe-west1.firebasedatabase.app')
        .ref("temp");


    var db = FirebaseFirestore.instance;
    final docCall = db.collection("manualCall").doc("00");


      Timer.periodic(const Duration(seconds: 1), (timer) async {
        // user = FirebaseAuth.instance.currentUser;
        // print(user?.uid.toString());



        for(int i = 0; i < items.length; i++){
          DateTime manualCall = DateTime.parse(items[i]).subtract(const Duration(minutes: 30));
          print(manualCall);
          var window = manualCall.difference(DateTime.now()).inMinutes;
          print(window);
          if(window > 2 && window < 0){
            call();
          }

        }

        DateTime? date;

        docCall.get().then((value) async => {
        // manualCall = value.data()!['date and time'].toDate(),
        //   date = value.data()!['date and time'].toDate(),
          // print(date),

        db.collection("manualCall").count().get().then(
        (res) => {
          // res.query.where("date and time", ),
          // print(res.count)
        }
        ),

        // db.collection("manualCall").where("date and time", isGreaterThan: 10).count().get().then(
        // (res) => print(res.count),
        // onError: (e) => print("Error completing: $e"),
        // )

        });

          ref.get().then((value) async {
            final temp = value
                .child('readings/temp')
                .value;

            if (service is AndroidServiceInstance) {
              print("Hello");
              if (await service.isForegroundService()) {

                service.setForegroundNotificationInfo(
                    title: "Room Temperature", content: "$temp°C");

              }
            }

            if (temp != null && temp is num && temp >= 30) {
              call();
              sendLogs("null");
            }
          });

          // perform some operations on background which isn't noticeable to the user
          print("background service running");
          service.invoke('update');
      });
  });
}