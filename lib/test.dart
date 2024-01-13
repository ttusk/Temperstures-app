
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'admin_home.dart';
import 'call_logs.dart';


class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final _logStream = FirebaseFirestore.instance.collection('prevCalls').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Call logs"),
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

      body: Container(
          alignment: Alignment.center,
          color: const Color(0x00d9d9d9),
          // padding: EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: _logStream,
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
                    return ListTile(
                      title: Text(docs[index].id.toString()),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return viewLogs(docs[index].id);
                        }));

                      },

                    );
                  });
            }


          ),
      ),

    );
  }
  }


  Widget viewLogs(var docID) {
    final _logs = FirebaseFirestore.instance
        .collection("prevCalls")
        .doc(docID)
        .collection("names")
        .snapshots();


    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Logs"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
    //     leading: BackButton(
    //       onPressed:  () {
    //         Navigator.of(context).push(MaterialPageRoute(builder: (context){
    //           return CallLogs();
    // }));
    //
    //       },
    //     ),

      ),

      body: Container(
       child: StreamBuilder(stream: _logs,
      builder: (context, snapshot) {

        if(snapshot.hasError){
          return const Text("Connection Error.");
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

    var names = snapshot.data!.docs;

    return ListView.builder(
    itemCount: names.length,
    itemBuilder: (context, index) {
      var tileColor;

      if(names[index]["status"] == "accepted"){
        tileColor = Colors.green;
      }
      else if(names[index]["status"] == "declined"){
        tileColor = Colors.red[600];
      }else {
        tileColor = Colors.white;
      }

    return ListTile(
      tileColor: tileColor,
    title: Text(names[index]["name"]),
    subtitle: Text(names[index].id),
    );
    });
    }
    )

      ),
    );

  }







  // Widget viewLogs(){
  //   final _logStream = FirebaseFirestore.instance.collection(dateTime.toString()).snapshots();
  //
  //   // final _logStream = FirebaseFirestore.instance.collection("prevCalls").doc().snapshots();
  //
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       // automaticallyImplyLeading: false,
  //       title: TextField.dart("Logs"),
  //       centerTitle: true,
  //       backgroundColor: Colors.red[600],
  //       leading: BackButton(
  //         onPressed:  () {
  //           Navigator.of(context).push(MaterialPageRoute(builder: (context){
  //             return CallLogs();
  //           }));
  //         },
  //       ),
  //
  //     ),
  //     body: Container(
  //       child: StreamBuilder(
  //           stream: _logStream,
  //           builder: (context, snapshot) {
  //             if(snapshot.hasError){
  //               return const TextField.dart("Connection Error.");
  //             }
  //             if(snapshot.connectionState == ConnectionState.waiting) {
  //               return const TextField.dart("Loading..");
  //             }
  //
  //             var docs = snapshot.data!.docs;
  //
  //             return ListView.builder(
  //                 itemCount: docs.length,
  //                 itemBuilder: (context, index){
  //                   var tileColor;
  //                   if(docs[index]["status"] == "accepted"){
  //                     tileColor = Colors.green;
  //                   }
  //                   else if(docs[index]["status"] == "declined"){
  //                     tileColor = Colors.red[600];
  //                   }else {
  //                     tileColor = Colors.white;
  //                   }
  //                   return  ListTile(
  //                     title: TextField.dart(docs[index]["name"]),
  //                     subtitle: TextField.dart(docs[index]["date and time"].toDate().toString()),
  //                     tileColor: tileColor,
  //                   );
  //                 });
  //           }
  //       ),
  //     ),
  //
  //   );
  // }
// }
