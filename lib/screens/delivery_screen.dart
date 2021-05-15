import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_order_food_app/data_modal/global_data.dart';

import 'payment_screen.dart';

class DeliveryScreen extends StatefulWidget {
  DeliveryScreen({Key key}) : super(key: key);

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderNameController.clear();
    orderPhoneController.clear();
    orderAddressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E2026),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Delivery To",
          style: TextStyle(
              fontFamily: "Sofia",
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {}
        ),
        backgroundColor: Color(0xFF1E2026),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Color(0xFFF48522),
                  size: 22.0,
                ),
                _circle(),
                Icon(
                  Icons.credit_card,
                  color: Colors.white70,
                  size: 21.0,
                ),
                _circle(),
                Icon(
                  Icons.check_circle,
                  color: Colors.white70,
                  size: 21.0,
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              color: Color(0xFF23252E),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 30.0, bottom: 50.0),
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.white,
                    hintColor: Colors.white.withOpacity(0.1),
                  ),
                  child: Form(
                    key: deliveryKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// name field
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Full Name',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w600),
                            ),
                            TextFormField(
                              style: new TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              controller: orderNameController,
                              autocorrect: false,
                              autofocus: false,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Field Required";
                                }else return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0.0),
                                  filled: true,
                                  fillColor: Colors.transparent,

                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        /// Address field
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Address',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w600),
                            ),
                            TextFormField(
                              style: new TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              controller: orderAddressController,
                              autocorrect: false,
                              autofocus: false,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Field Required";
                                }else return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0.0),
                                filled: true,
                                fillColor: Colors.transparent,

                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        /// phone field
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Phone',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            TextFormField(
                              style: new TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              controller: orderPhoneController,
                              autocorrect: false,
                              autofocus: false,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Field Required";
                                }else return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0.0),
                                filled: true,
                                fillColor: Colors.transparent,

                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 50.0),
                          child: InkWell(
                            onTap: () {
                              if(deliveryKey.currentState.validate()){
                                Navigator.of(context).push(
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ____) =>
                                            PaymentScreen()));
                              }

                            },
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
                                "Continue",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Sofia",
                                    letterSpacing: 0.9),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _circle() {
  return Row(
    children: <Widget>[
      SizedBox(
        width: 18.0,
      ),
      CircleAvatar(
        backgroundColor: Colors.white70,
        radius: 2.0,
      ),
      SizedBox(
        width: 7.0,
      ),
      CircleAvatar(
        backgroundColor: Colors.white70,
        radius: 2.0,
      ),
      SizedBox(
        width: 7.0,
      ),
      CircleAvatar(
        backgroundColor: Colors.white70,
        radius: 2.0,
      ),
      SizedBox(
        width: 7.0,
      ),
      CircleAvatar(
        backgroundColor: Colors.white70,
        radius: 2.0,
      ),
      SizedBox(
        width: 18.0,
      ),
    ],
  );
}
