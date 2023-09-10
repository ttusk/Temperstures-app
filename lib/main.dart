import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
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


  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user?.uid.toString());
    print(user?.email.toString());
    email = user?.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: user != null ? Home() : LoginPage(),
      home: user != null ? userOrAdmin() : LoginPage(),
    );

  }
  Widget userOrAdmin(){
    if(email == 'islam@gmail.com' || email == '' || email == ''){
      return AdminHome();
    }else {
      return Home();
    }
  }


}
