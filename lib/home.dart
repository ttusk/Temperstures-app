import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temps_app/login_page.dart';
import 'package:temps_app/readings.dart';

import 'components/my_button.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State {
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
        backgroundColor: Colors.grey[600],
        automaticallyImplyLeading: false,
        title: Text("Home"),
      ),
      body: Container(
      alignment: Alignment.center,
    color: const Color(0x00d9d9d9),
    padding: EdgeInsets.all(20.0),
    child: ListView(
      children: [
        // ElevatedButton(
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(builder: (context){
        //         return const Readings();
        //       }));
        //
        //     },
        //   child: Text("Room temprature"),
        //   style: TextButton.styleFrom(
        //     foregroundColor: Colors.yellow[600],
        //
        //   ),
        // ),

        MyButton(onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return const Readings();
          }));
        }, text: 'Room temperatures',
            padding: 15,
            margin: 15),

        const SizedBox(height: 10,),

        MyButton(text: "Sign out",
            onTap: () {
              FirebaseAuth.instance.signOut();
              service.invoke('stopService');
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return LoginPage();
              }));
            }, padding: 15,
            margin: 15),

        // ElevatedButton(
        //   onPressed: () {
        //     FirebaseAuth.instance.signOut();
        //     service.invoke('stopService');
        //     Navigator.of(context).push(MaterialPageRoute(builder: (context){
        //       return LoginPage();
        //     }));
        //   },
        //   child: Text("Sign Out"),
        //   style: TextButton.styleFrom(
        //     foregroundColor: Colors.yellow[600],
        //   ),
        // ),
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