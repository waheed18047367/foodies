import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:multi_order_food_app/auth_modal/firebase_auth_modal.dart';
import 'package:multi_order_food_app/screens/rider/order_detail_screen.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';

class DeliveryBoyScreen extends StatefulWidget {
  @override
  _DeliveryBoyScreenState createState() => _DeliveryBoyScreenState();
}

class _DeliveryBoyScreenState extends State<DeliveryBoyScreen> {
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    return
        DefaultTabController(
            length: 2,
            child: Scaffold(
              // Use ShiftingTabBar instead of appBar
              appBar: ShiftingTabBar(
                color: Colors.transparent,
                tabs: <ShiftingTab>[
                  ShiftingTab(
                    icon: const Icon(Icons.directions_bike),
                    text: 'Pending',
                  ),
                  ShiftingTab(
                    icon: const Icon(Icons.check_circle_outline),
                    text: 'Complete',
                  ),

                ],
              ),
              body:  TabBarView(
                children: <Widget>[
                  ListView(
                    children: [
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
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
                                      // height: MediaQuery.of(context).size.height*.4,
                                      child: Column(
                                        children: snapshot.data.docs.map((doc) {
                                          return Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Material(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                color: Colors.transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.transparent,
                                                            Color(0xff380607)
                                                          ],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          stops: [0.01, 0.8]),
                                                      borderRadius:
                                                      BorderRadius.circular(10)),
                                                  child: ListTile(
                                                    onTap: () {
                                                      Get.to(OrderDetailRiderScreen(docId: doc.id,));
                                                    },
                                                    leading: Icon(Icons.shopping_cart,size: 30,color: Colors.orangeAccent,),
                                                    title: Text(
                                                      doc.get('customerName'),
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      doc.get('customerPhone'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          .copyWith(fontSize: 12),
                                                    ),
                                                    trailing: Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: Colors.white,
                                                    ),

                                                  ),
                                                )

                                            ),

                                          );

                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
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
                                      // height: MediaQuery.of(context).size.height*.4,
                                      child: Column(
                                        children: snapshot.data.docs.map((doc) {
                                          return Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Material(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                color: Colors.transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.transparent,
                                                            Color(0xff380607)
                                                          ],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          stops: [0.01, 0.8]),
                                                      borderRadius:
                                                      BorderRadius.circular(10)),
                                                  child: ListTile(
                                                    onTap: () {
                                                      Get.to(OrderDetailRiderScreen(docId: doc.id,));
                                                    },
                                                    leading: Icon(Icons.shopping_cart,size: 30,color: Colors.orangeAccent,),
                                                    title: Text(
                                                      doc.get('customerName'),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      doc.get('customerPhone'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          .copyWith(fontSize: 12),
                                                    ),
                                                    trailing: Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: Colors.white,
                                                    ),

                                                  ),
                                                )

                                            ),

                                          );

                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.orangeAccent,
                child: InkWell(
                  onTap: (){
                    firebaseAuthentication.signOut();
                  },
                  child: Icon(Icons.logout,color: Colors.red,)),
              ),
            ),
          );

  }
}
