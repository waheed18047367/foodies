import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:multi_order_food_app/data_modal/global_data.dart';

import 'addMenuScreen.dart';

class MenuListScreen extends StatefulWidget {
  MenuListScreen({this.docId});
  final String docId;

  @override
  _MenuListScreenState createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [

          InkWell(
            onTap: (){
              Get.to(AddMenuScreen(docId: widget.docId,));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add_circle_outline,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF1E2026),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: ListView(
              padding: EdgeInsets.all(5.0),
              children: <Widget>[
                SizedBox(height: 10.0),
                StreamBuilder<QuerySnapshot>(
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
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        height: 100,
                                        width: MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Slidable(
                                            actionPane: SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.25,
                                            secondaryActions: <Widget>[
                                              IconSlideAction(
                                                caption: 'Delete',
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                onTap: () {
                                                  var alert = new AlertDialog(
                                                    backgroundColor: Colors.white30,
                                                    elevation: 7.0,
                                                    content:
                                                    Text('Are you sure you want to delete this Menu?',
                                                      style: TextStyle(
                                                        fontFamily: "Sofia",
                                                        fontSize: 16,
                                                        color: Colors.orangeAccent
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          color: Colors.red,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          onPressed: ()async{
                                                            Navigator.pop(context);
                                                            Get.snackbar("Success", "Menu Deleted Successfully",backgroundColor: Colors.grey);
                                                            await FirebaseFirestore.instance
                                                                .collection('hotels').doc(widget.docId)
                                                                .collection('menus').doc(doc.id)
                                                                .delete();
                                                          },
                                                          child: Text(
                                                              'DELETE',
                                                              style: TextStyle(
                                                                  fontFamily: "Sofia",
                                                                  fontSize: 20,
                                                                  color: Colors.white
                                                              ),
                                                          )
                                                      ),
                                                      FlatButton(onPressed: (){
                                                        Navigator.pop(context);
                                                      }, child: Text('CANCEL',
                                                          style: TextStyle(
                                                              fontFamily: "Sofia",
                                                              fontSize: 16,
                                                              color: Colors.orangeAccent
                                                          ),
                                                      ),),
                                                    ],
                                                  );
                                                  showDialog(context: context, builder: (_) => alert);
                                                },
                                              ),
                                            ],
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius:30,
                                                  backgroundColor: Colors.transparent,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(30),
                                                    child: Image.network(
                                                      doc.get('menuImageUrl'),
                                                      fit: BoxFit.cover,
                                                      width: 100,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15,),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        doc.get('menuName'),
                                                        style: TextStyle(
                                                            fontFamily: "Sofia",
                                                            fontSize: 16,
                                                            color: Colors.orangeAccent
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text(
                                                        doc.get('menuDescription'),
                                                        style: TextStyle(
                                                            fontFamily: "Sofia",
                                                            fontSize: 16,
                                                            color: Colors.orangeAccent
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
                                                  child: Text(
                                                    '${$pound} ${doc.get('menuPrice')}',
                                                    style: TextStyle(
                                                        fontFamily: "Sofia",
                                                        fontSize: 16,
                                                        color: Colors.orangeAccent
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
