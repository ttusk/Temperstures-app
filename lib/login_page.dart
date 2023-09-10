import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temps_app/admin_home.dart';
import 'package:temps_app/auth.dart';
import 'package:temps_app/home.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State {

  final Auth _auth = Auth();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Container(
        alignment: Alignment.center,
        color: const Color(0x00d9d9d9),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 15.0),
            Container(

              height: 150.0,
              width: 150.0,
              child: Image.asset('assets/AAST_logo.png'),
            ),

            SizedBox(height: 30.0),

            Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Employee ID",
                        hintText: "Enter Employee ID",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 30.0),

                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                )
            ),

            SizedBox(height: 15.0),

            ElevatedButton(
              onPressed: () {
                _signIn();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.yellow[600],
              ),
              child: Text("Log in"),
            ),
          ],
        ),
      ),
    );
  }
  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if(user != null){
      print("User is signed in");
      print(user);

      if(email == 'islam@gmail.com' || email == '' || email == ''){
        print("navigate admin to admin home");
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return AdminHome();
        }));
      }else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return Home();
        }));

      }


    } else {
      print("some error happened");
    }

  }
}

