import 'package:multi_order_food_app/data_modal/global_data.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:multi_order_food_app/screens/detail_food_screen.dart';
class MenuDisplayScreen extends StatefulWidget {
  MenuDisplayScreen({this.docId,this.hotelMap});

  QueryDocumentSnapshot hotelMap;
  final String docId;
  @override
  _MenuDisplayScreenState createState() => _MenuDisplayScreenState();
}
class _MenuDisplayScreenState extends State<MenuDisplayScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.hotelMap == null){
      FirebaseFirestore.instance
          .collection('hotels')
          .snapshots()
          .listen((snapshot) {
            snapshot.docs.forEach((element) {
              if(element.id == widget.docId){
                if(mounted){
                  setState(() {
                    widget.hotelMap = element;
                  });
                  debugPrint(widget.hotelMap.get('hotelName').toString());
                }
              }
            });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E2026),
      appBar: AppBar(
        backgroundColor: Color(0xff2f2f2f),
        elevation: 3,
        centerTitle: true,
        title: Text(
          "All Menus",
          style: TextStyle(
            color: Colors.orangeAccent,
            fontFamily: "Sofia",
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('hotels').doc(widget.docId).collection('menus').snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                              )
                          ),
                        ],
                      );
                    }
                    else if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height*.02,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*.8,
                            child: ListView(
                              children: snapshot.data.docs.map((doc) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      Get.to(DetailFoodScreen(hotelId: widget.docId,menuMap: doc,hotelMap: widget.hotelMap,));
                                    },
                                    child: Container(
                                      height: 120,
                                      // width: MediaQuery.of(context).size.width*.85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(colors: [
                                          Color(0xFF1E2026),
                                          Color(0xFF23252E),
                                        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                        boxShadow: [
                                          BoxShadow(blurRadius: 0.0, color: Colors.black87)
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 120,
                                            width: 100,
                                            child: Image.network('${doc.get('menuImageUrl')}'),
                                          ),
                                          SizedBox(width: 5,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  doc.get('menuName'),
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 18,color: Colors.white),
                                                ),
                                                SizedBox(height: 5,),
                                                AutoSizeText(
                                                  doc.get('menuDescription'),
                                                  style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 12,color: Colors.white),
                                                ),
                                                SizedBox(height: 25,),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          "${$pound} ${doc.get('menuPrice')}",
                                                          style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 18,color: Colors.grey),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.info,
                                                        size: 15,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              }).toList(),
                            ),
                          ),
                          // Container(
                          //   height: MediaQuery.of(context).size.height*.02,
                          // ),
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
            ),
          ],
        ),
      ),
    );

  }
}
