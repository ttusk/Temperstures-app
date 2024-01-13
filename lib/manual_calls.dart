import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
                    // return TextField.dart("${docs.length}");
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                              icon: Icons.delete,
                            backgroundColor: Colors.red,
                            label: "DELETE",
                            onPressed: (BuildContext context) {
                              FirebaseFirestore.instance
                                  .collection("manualCall")
                                  .doc(docs[index].id)
                                  .delete();

                              showDialog(context: context,
                                  builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                      child: Text("Ok")
                                  )
                                ],
                                title: const Text("Manual alarm deleted"),

                                content: const Text("Manual alarm has been deleted successfully."),
                              ));

                            },

                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(docs[index]['date and time'].toDate().toString()),
                        subtitle: Text(docs[index]['message']),
                        // onTap: () {
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        //     return viewLogs(docs[index].id);
                        //   }));
                        //
                        // },

                      ),

                    );
                  });
            }

        ),

      ),
    );
  }
}
