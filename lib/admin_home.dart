import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temps_app/call_logs.dart';
import 'package:temps_app/login_page.dart';
import 'package:temps_app/manual_calls.dart';
import 'package:temps_app/readings.dart';
import 'package:temps_app/set_manual_call.dart';
import 'package:temps_app/set_threshold.dart';
import 'package:temps_app/test.dart';
import 'package:temps_app/view_all_users.dart';


class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State {
  final service = FlutterBackgroundService();

  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData().then((_) => setState((){}));
  }

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

              Text("Welcome, $name"),

              SizedBox(height: 10),

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




              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return ViewAllUsers();
                }));
              },
                  child: Text("Manage all users"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow[600],
              ),
              ),

              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  // return CallLogs();
                  return Test();
                }));
              },
                child: Text("Call logs"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow[600],
                ),
              ),

              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return ManualCalls();
                }));
              },
                child: Text("Manual calls"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow[600],
                ),
              ),

              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return SetThreshold();
                }));
              },
                child: Text("Set threshold"),
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
                child: Text("Sign out"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow[600],
                ),
              ),

            ],
          )
      ),
    );

  }

  Future<void> getUserData() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name");
  }



}