import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temps_app/admin_home.dart';
import 'package:temps_app/background_service.dart';
import 'package:temps_app/home.dart';
import 'package:temps_app/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );

  final service = FlutterBackgroundService();
  bool isRunning = await service.isRunning();

  User? user;
  user = FirebaseAuth.instance.currentUser;

  if (isRunning && user != null) {
    await initializeService();
  } else {}

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});



  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  String? email;

  String? id;
  bool? admin;
  bool? adminOrNot;



  @override
  void initState() {
    getUserData().then((_) => setState((){}));
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user?.uid.toString());
    // print(user?.email.toString());
    // email = user?.email.toString();
    // UID = user?.uid.toString();

    // adminOrNot = isAdmin() as bool?;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: user != null ? Home() : LoginPage(),
      // home: user != null ? userOrAdmin() : LoginPage(),
      home: navigator(),

    );
  }

  Widget navigator()  {
    print("$admin haha");
    if(user != null){
      if(admin == true){
        return AdminHome();
      }
      else{
        return Home();
      }
    }
    return LoginPage();
  }


  // Widget userOrAdmin() {
  //   if(isAdmin() as bool){
  //     return AdminHome();
  //   }else  {
  //     return Home();
  //   }
  // }
  //
  Future<bool> isAdmin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    admin = pref.getBool("admin");
    if(admin == true){
      return true;
    }else  {
      return false;
    }
  }



  Future<void> getUserData() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString("id");
    admin = pref.getBool("admin");

    print(id);
    print(admin);
  }


}
