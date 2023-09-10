import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:temps_app/login_page.dart';
import 'package:temps_app/readings.dart';


class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State {
  final service = FlutterBackgroundService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Admin"),
      ),
      body: Container(
          alignment: Alignment.center,
          color: const Color(0x00d9d9d9),
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const Readings();
                  }));

                },
                child: Text("Room temprature"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow[600],

                ),
              ),


              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  service.invoke('stopService');
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return LoginPage();
                  }));
                },
                child: Text("Sign Out"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow[600],
                ),
              ),

              ElevatedButton(onPressed: (){},
                  child: Text("hmmmmm"))
            ],
          )
      ),
    );

  }



}