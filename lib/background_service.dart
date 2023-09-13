import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';


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





  void sendLogs(){
    User? user;
    user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    DateTime now = DateTime.now();
    // Map <String, dynamic> data = {"UID": user?.uid.toString(), "Date and time: ": now};
    users.add({"UID": user?.uid.toString(), "Date and time: ": now});

    // Firestore.instance.collection("test").add(data);
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
            isCustomNotification: true,
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
          sendLogs();
          service.stopSelf();
          print("call accepted lol");
          break;

        case Event.actionCallDecline:
          // service.invoke('stopService');
          sendLogs();
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
    DatabaseReference ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
        'https://temps-app-c38b5-default-rtdb.europe-west1.firebasedatabase.app')
        .ref("temp");

      Timer.periodic(const Duration(seconds: 30), (timer) async {
        // user = FirebaseAuth.instance.currentUser;
        // print(user?.uid.toString());

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
            }
          });

          // perform some operations on background which isn't noticeable to the user
          print("background service running");
          service.invoke('update');
      });
  });
}