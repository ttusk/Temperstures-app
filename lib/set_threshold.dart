
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temps_app/components/my_button.dart';

import 'admin_home.dart';

class SetThreshold extends StatefulWidget {
  const SetThreshold({Key? key}) : super(key: key);

  @override
  State<SetThreshold> createState() => _SetThresholdState();
}

class _SetThresholdState extends State<SetThreshold> {
  double? threshold;
  double? oldThreshold;


  Future<double?> getCurrentThreshold() async {
    await Future.delayed(const Duration(seconds: 1),
    );

    FirebaseFirestore.instance.collection("tempThreshold").doc("00")
        .get()
        .then((value) async => {
      threshold = value.data()!['threshold'].toDouble(),
  });
    oldThreshold = threshold;
    return threshold;
  }

  void setNewThresholdButton(){
    showDialog(context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(onPressed: () {
            FirebaseFirestore.instance
                .collection("tempThreshold")
                .doc("00")
                .update({'threshold': threshold});

            getCurrentThreshold();
            Navigator.of(context).pop();

          },
              child: Text("YES!")
          )
        ],
        title: Text("Threshold"),

        content: Text("Are you sure you want to change the threshold from $oldThreshold to $threshold?"),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentThreshold().then((_) => setState((){}));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        title: const Text("Set threshold"),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return AdminHome();
            }));
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: const Color(0x00d9d9d9),
        padding: const EdgeInsets.all(20.0),
        child:  FutureBuilder(
            future: getCurrentThreshold(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              if(snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Column(

                  children: [
                    // Text(snapshot.data.toString()),
                    TextField(
                      keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'(^-?\d*\.?\d*)'))
                    ],
                      onChanged: (newValue) {
                        try{
                          double value = double.parse(newValue);
                          threshold = value;
                        }catch (e){
                          print("NO VALUE");

                        }

                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Threshold",
                        hintText: "Enter threshold",
                      ),
                      controller: TextEditingController(
                          text: threshold.toString()),
                    ),

                    SizedBox(height: 20),

                    MyButton(text: "Set new threshold", padding: 15, margin: 20, onTap: setNewThresholdButton,),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     showDialog(context: context,
                    //       builder: (context) => AlertDialog(
                    //         actions: [
                    //           TextButton(onPressed: () {
                    //             FirebaseFirestore.instance
                    //                 .collection("tempThreshold")
                    //                 .doc("00")
                    //                 .update({'threshold': threshold});
                    //
                    //             getCurrentThreshold();
                    //             Navigator.of(context).pop();
                    //
                    //           },
                    //               child: Text("YES!")
                    //           )
                    //         ],
                    //         title: Text("Threshold"),
                    //
                    //         content: Text("Are you sure you want to change the threshold from $oldThreshold to $threshold?"),
                    //       ),
                    //     );
                    //   },
                    //   child: Text("Set new threshold"),
                    //   style: TextButton.styleFrom(
                    //     foregroundColor: Colors.yellow[600],
                    //   ),
                    // ),


                  ],

                );


              }
            }

        ),

      ),
    );

  }









}
