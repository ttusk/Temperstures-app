import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temps_app/add_user.dart';

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
        alignment: Alignment.center,
        color: const Color(0x00d9d9d9),
        padding: EdgeInsets.all(20.0),
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
                return ListTile(
                  title: Text(docs[index]["name"]),
                  subtitle: Text(docs[index].id),

                );


                });
          }
        )
      ),
    );
  }
}
