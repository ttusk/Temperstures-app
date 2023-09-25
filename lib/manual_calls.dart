import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temps_app/set_manual_call.dart';

import 'admin_home.dart';

class ManualCalls extends StatefulWidget {
  const ManualCalls({Key? key}) : super(key: key);

  @override
  State<ManualCalls> createState() => _ManualCallsState();
}

class _ManualCallsState extends State<ManualCalls> {
  final _manualCalls = FirebaseFirestore.instance.collection('manualCall').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Manual calls"),
    centerTitle: true,
    backgroundColor: Colors.red[600],
    leading: BackButton(
    onPressed:  () {
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
    return AdminHome();
    }
    )
    );
    },
    ),
    ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return SetManualCall();
          }));
        },

      ),

      body: Container(
        alignment: Alignment.center,
        color: const Color(0x00d9d9d9),
        child: StreamBuilder(
          stream: _manualCalls,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Connection Error.");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading..");
              }

              var docs = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // return Text("${docs.length}");
                    return ListTile(
                      title: Text(docs[index]['date and time'].toDate().toString()),
                      // onTap: () {
                      //   Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      //     return viewLogs(docs[index].id);
                      //   }));
                      //
                      // },

                    );
                  });
            }

        ),

      ),
    );
  }
}
