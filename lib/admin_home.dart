import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temps_app/call_logs.dart';
import 'package:temps_app/components/my_button.dart';
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        automaticallyImplyLeading: false,
        title: Text("Welcome, $name"),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // Text("Welcome, $name",
              // style: const TextStyle(
              //   fontSize: 15,
              //   fontWeight: FontWeight.bold,
              // )),

              const SizedBox(height: 10),

              MyButton(onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return const Readings();
                }));
              }, text: 'Room temperatures',
                padding: 15,
                margin: 15),

              const SizedBox(height: 10),

              MyButton(onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return const ViewAllUsers();
                }));
              }, text: 'Manage users',
                padding: 15,
                margin: 15),

              const SizedBox(height: 10),

              MyButton(text: "Call logs",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  // return CallLogs();
                  return const Test();
                }));
              }, padding: 15,
                  margin: 15),

              const SizedBox(height: 10),

              MyButton(text: "Manual calls",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      // return CallLogs();
                      return const ManualCalls();
                    }));
                  }, padding: 15,
                  margin: 15),

              const SizedBox(height: 10),

              MyButton(text: "Set threshold",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      // return CallLogs();
                      return const SetThreshold();
                    }));
                  }, padding: 15,
                  margin: 15),

              const SizedBox(height: 10),

              MyButton(text: "Sign out",
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    service.invoke('stopService');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return LoginPage();
                    }));
                  }, padding: 15,
                  margin: 15),

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