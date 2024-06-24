import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'package:flutter/cupertino.dart';


class CallLogs extends StatefulWidget {
  const CallLogs({Key? key}) : super(key: key);

  @override
  State<CallLogs> createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {
  DateTime dateTime = DateTime(2020, 1, 1);


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                child: Text("${dateTime.year.toString()}-${dateTime.month.toString()}-${dateTime.day.toString()}"),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext contex) => SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                        backgroundColor: Colors.white,
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: dateTime,
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            dateTime = newDateTime;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return viewLogs();
                  }));


                },
                child: Text("Search"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.yellow[600],
                ),
              ),

            ],
          )
      ),

    );
  }
  Widget viewLogs(){
    final _logStream = FirebaseFirestore.instance.collection(dateTime.toString()).snapshots();

    // final _logStream = FirebaseFirestore.instance.collection("prevCalls").doc().snapshots();


    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Logs"),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
        leading: BackButton(
          onPressed:  () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return CallLogs();
            }));
          },
        ),

      ),
      body: Container(
        child: StreamBuilder(
            stream: _logStream,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return const Text("Connection Error.");
              }
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading..");
              }

              var docs = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index){
                    var tileColor;
                    if(docs[index]["status"] == "accepted"){
                      tileColor = Colors.green;
                    }
                    else if(docs[index]["status"] == "declined"){
                      tileColor = Colors.red[600];
                    }else {
                      tileColor = Colors.white;
                    }
                    return  ListTile(
                    title: Text(docs[index]["name"]),
                    subtitle: Text(docs[index]["date and time"].toDate().toString()),
                      tileColor: tileColor,
                    );
                  });
            }
        ),
      ),

    );
  }
}
