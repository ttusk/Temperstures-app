import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temps_app/view_all_users.dart';

import 'login_page.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool? isAdmin = false;

  void addNewUser(String id, String name, String password, bool admin){
    FirebaseFirestore.instance
        .collection('appUsers')
        .doc(id)
        .set({'name': name, 'password': password, 'admin': admin});



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,

        leading: BackButton(
          onPressed:  () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return ViewAllUsers();
            }));
          },
        ),
        title: Text("Add user"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Container(
        alignment: Alignment.center,
        color: const Color(0x00d9d9d9),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 30.0),

            Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Employee ID",
                        hintText: "Enter Employee ID",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 30.0),

                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        hintText: "Enter Name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 30.0),

                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      // obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter Password",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Admin",
                          style: TextStyle(fontSize: 20),
                        ),

                        Checkbox(
                            value: isAdmin,
                            onChanged: (newBool) {
                              setState(() {
                                isAdmin = newBool;
                              });
                            }
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0),

                    ElevatedButton(
                      onPressed: () {
                       try{
                         // showError("Loading", context);
                         if(_idController.text.isEmpty || _nameController.text.isEmpty || _passwordController.text.isEmpty){
                           showError("Please enter all credentials.", context);
                           return;
                         }
                         String? name = _nameController.text;
                         addNewUser(_idController.text, _nameController.text, _passwordController.text, isAdmin!);
                         showDialog(context: context,
                             builder: (context) => AlertDialog(
                               actions: [
                                 TextButton(onPressed: () {
                                   Navigator.of(context).pop();

                                   Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                     return ViewAllUsers();
                                   }));
                                 },
                                     child: Text("Ok!")
                                 )
                               ],
                               title: Text("New user"),

                               content: Text("$name added to database."),
                             ),
                         );
                         
                       }catch(e){
                         showError("Can't connect, please try later", context);
                         
                       }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.yellow[600],
                      ),
                      child: Text("Add user"),
                    ),


                  ],
                )
            ),

            SizedBox(height: 15.0),

          ],
        ),
      ),
    );
  }
}
