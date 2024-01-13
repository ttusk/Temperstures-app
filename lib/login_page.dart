import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temps_app/admin_home.dart';
import 'package:temps_app/auth.dart';
import 'package:temps_app/components/my_button.dart';
import 'package:temps_app/components/my_text_field.dart';
import 'package:temps_app/home.dart';
import 'package:temps_app/auth.dart';

import 'background_service.dart';

void showError (msg, context){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg, style: const TextStyle(
              fontWeight: FontWeight.bold
          ),),
        );
      }
  );
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State {

  final Auth _auth = Auth();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: TextField.dart("Login"),
      //   centerTitle: true,
      //   backgroundColor: Colors.red[600],
      // ),
      body: Container(
        alignment: Alignment.center,
        color: const Color(0x00d9d9d9),
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            Container(

              height: 200,
              width: 200,
              child: Image.asset('assets/AAST_logo.png'),
            ),

            const SizedBox(height: 30.0),

            Form(
                child: Column(
                  children: [
                    MyTextField(controller: _emailController,
                        hintText: "Enter employee ID",
                        obscureText: false),

                    const SizedBox(height: 30.0),

                    MyTextField(controller: _passwordController,
                        hintText: "Enter password",
                        obscureText: true),
                  ],
                )
            ),

            const SizedBox(height: 30),

            MyButton(
              text: "Login",
              onTap: _signIn, padding: 25, margin: 25,
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     _signIn();
            //   },
            //   style: TextButton.styleFrom(
            //     foregroundColor: Colors.yellow[600],
            //   ),
            //   child: Text("Log in"),
            // ),
          ],
        ),
      ),
    );
  }

  void _signIn() {

    var db = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection(
        'appUsers');

    String id = _emailController.text.trim();
    String password = _passwordController.text;


    if (id.isEmpty || password.isEmpty) {
      showError("Enter id and password!", context);
      return;
    }

    final docUser = db.collection("appUsers").doc(id);

    try {
      bool admin;
      String name;
      showError("Loading", context);
      docUser.get().then((value) async =>
      {
        // Navigator.of(context, rootNavigator: true).pop(),

        if(value.exists){

          if(value.data()!['password'] == password){
            name = value.data()!['name'],

            if(value.data()!['admin'] == true){

               admin = value.data()!['admin'],
              saveUserData(id, admin, name),
              await _auth.signInAnon(),

              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return AdminHome();
              })),

              await initializeService()

            }else {
              admin = value.data()!['admin'],
              saveUserData(id, admin, name),
              await _auth.signInAnon(),

              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return Home();
              })),

              await initializeService()

            }
          }
          else{
            showError("Incorrect password", context)
          }
        }
        else
          {
            showError("Id doesn't exist", context)
          }
      }
      );
    } catch (e) {
      showError("Can't connect, please try later", context);
    }
  }


  Future<void> saveUserData(id, admin, name) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("id", id);
    pref.setString("name", name);
    pref.setBool("admin", admin);
  }




  // void _signIn() async {
  //   String email = _emailController.text.trim();
  //   String password = _passwordController.text;
  //
  //   User? user = await _auth.signInWithEmailAndPassword(email, password);
  //
  //
  //
  //   if(user != null){
  //     print("User is signed in");
  //     print(user);
  //
  //     if(email == 'islam@gmail.com' || email == '' || email == ''){
  //       print("navigate admin to admin home");
  //       Navigator.of(context).push(MaterialPageRoute(builder: (context){
  //         return AdminHome();
  //       }));
  //     }else {
  //       Navigator.of(context).push(MaterialPageRoute(builder: (context){
  //         return Home();
  //       }));
  //
  //     }
  //   } else {
  //     print("some error happened");
  //   }
  //
  // }




}



