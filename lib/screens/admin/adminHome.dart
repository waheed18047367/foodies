import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_order_food_app/auth_modal/firebase_auth_modal.dart';
import 'package:multi_order_food_app/screens/admin/addrestuarant.dart';
import 'package:multi_order_food_app/screens/admin/hotelListScreen.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF1E2026),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: 10,
                top: 0,
                child: InkWell(
                  onTap: (){
                    firebaseAuthentication.signOut();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 5.0),
                    child: Container(
                      height: 50.0,
                      width: 80.0,
                      child: Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 100,),
                        Text(
                          'ADMIN',
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 1.5,
                            fontFamily: "Sofia",
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(AddRestaurantPage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: Container(
                        height: 52.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: LinearGradient(colors: [
                            Color(0xFFFEE140),
                            Color(0xFFFA709A),
                          ]),
                        ),
                        child: Center(
                            child: Text(
                              "Add Restaurants",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Sofia",
                                  letterSpacing: 0.9
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(HotelListScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: Container(
                        height: 52.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: LinearGradient(colors: [
                            Color(0xFFFEE140),
                            Color(0xFFFA709A),
                          ]),
                        ),
                        child: Center(
                            child: Text(
                              "View Restaurants",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Sofia",
                                  letterSpacing: 0.9
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
