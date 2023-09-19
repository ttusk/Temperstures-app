import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:temps_app/add_user.dart';
import 'package:temps_app/admin_home.dart';

class ViewAllUsers extends StatefulWidget {
  const ViewAllUsers({Key? key}) : super(key: key);

  @override
  State<ViewAllUsers> createState() => _ViewAllUsersState();
}

class _ViewAllUsersState extends State<ViewAllUsers> {
  final _userStream = FirebaseFirestore.instance.collection("appUsers").snapshots();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("All Users"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        leading: BackButton(
          onPressed:  () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return AdminHome();
            }));
          },
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return AddUser();
          }));

        },
        child: Icon(Icons.add),

      ),
      body: Container(
        // alignment: Alignment.center,
        color: const Color(0x00d9d9d9),
        // padding: EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: _userStream,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return const Text("Connection Error.");
            }
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading..");
            }
            var docs = snapshot.data!.docs;

            // return Text("${docs.length}");
            return ListView.builder(

                itemCount: docs.length,
                itemBuilder: (context, index){
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          label: "DELETE",
                          onPressed: (BuildContext context) {
                            String? name = docs[index]["name"];
                            showDialog(context: context,
                              builder: (context) => AlertDialog(
                                actions: [
                                  // Yes button -> deleting user from db.
                                  TextButton(onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("appUsers")
                                        .doc(docs[index].id)
                                        .delete();

                                    Navigator.of(context).pop();

                                    // another alert message stating that user has been deleted successfully.
                                    showDialog(context: context,
                                      builder: (context) => AlertDialog(
                                        actions: [
                                          TextButton(onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                              child: Text("Ok!")
                                          )
                                        ],
                                        title: Text("User deleted!"),

                                        content: Text("$name has been deleted from the database."),
                                      ),
                                    );


                                  },
                                      child: Text("Yes!")
                                  ),

                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop();

                                  },
                                      child: Text("No")
                                  )

                                ],
                                title: Text("Delete user"),
                                content: Text("Are you sure you want to delete $name from the database?"),
                              ),
                            );
                            print(docs[index].id);

                          },
                        )

                        
                      ],
                    ),
                      child: ListTile(
                        title: Text(docs[index]["name"]),
                        subtitle: Text(docs[index].id),
                  )
                  );



                });
          }
        )
      ),
    );
  }
}
