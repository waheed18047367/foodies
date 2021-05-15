
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_order_food_app/screens/payment_screen.dart';
import 'package:multi_order_food_app/screens/home_screen.dart';
import 'package:multi_order_food_app/data_modal/global_data.dart';


class ConfirmScreen extends StatefulWidget {
  ConfirmScreen({Key key}) : super(key: key);

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalCartBill();
  }
  void totalCartBill() {
    FirebaseFirestore.instance
        .collection('cart')
        .where('uId', isEqualTo: uId)
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + int.parse(doc.data()['totalBill'].toString()));
      setState(() {cartTotalBill = tempTotal;});
      debugPrint(cartTotalBill.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF1E2026),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Confirm Order",
          style: TextStyle(
              fontFamily: "Sofia",
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacement(
              PageRouteBuilder(pageBuilder: (_, __, ___) => PaymentScreen())),
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
                _circleOrange(),
                Icon(
                  Icons.credit_card,
                  color: Color(0xFFF48522),
                  size: 21.0,
                ),
                _circleOrange(),
                Icon(
                  Icons.check_circle,
                  color: Color(0xFFF48522),
                  size: 21.0,
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              width: double.infinity,
              color: Color(0xFF23252E),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Detail Informasion Order",
                      style: TextStyle(
                          fontFamily: "Sofia",
                          color: Colors.white,
                          fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
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
                                  height: MediaQuery.of(context).size.height*.44,
                                  child: ListView(
                                    children: snapshot.data.docs.map((doc) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0,
                                            left: 13.0,
                                            right: 13.0,
                                            bottom: 10.0),

                                        /// Background Constructor for card
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.all(10.0),

                                                    /// Image item
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(0.1),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.black12
                                                                      .withOpacity(0.1),
                                                                  blurRadius: 0.5,
                                                                  spreadRadius: 0.1)
                                                            ]),
                                                        child: Image.network(
                                                          doc.get('menuImageUrl'),
                                                          height: 90.0,
                                                          width: 90.0,
                                                          fit: BoxFit.cover,
                                                        )
                                                    )
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 5.0,
                                                        left: 10.0,
                                                        right: 5.0),
                                                    child: Column(
                                                      /// Text Information Item
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 200.0,
                                                          child: Text(
                                                            doc.get('menuName'),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                fontFamily: "Sans",
                                                                color: Colors.white,
                                                                fontSize: 17.0),
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        Text(
                                                          doc.get('hotelName'),
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w200,
                                                            fontFamily: "Sofia",
                                                            color: Colors.white,
                                                          ),
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  top: 15.0),
                                                              child: Text(
                                                                "${doc.get('Quantity')} * ${$pound}${doc.get('menuPrice')} = "
                                                                    "${$pound}" + doc.get('totalBill').toString(),
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontFamily: "Sofia",
                                                                    fontSize: 17.0,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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

                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              child: InkWell(
                onTap: () {
                  confirmOrder();
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
                    "Checkout",
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
    );
  }

  int cartTotalBill = 0;

  List<QueryDocumentSnapshot> cartList = [];
  void confirmOrder() async{

    FirebaseFirestore.instance
        .collection('cart')
        .where('uId',isEqualTo: uId)
        .snapshots()
        .listen((snapshot) {
      List<QueryDocumentSnapshot> tempTotal = snapshot.docs.fold([], (tot, doc) => tot +
          [
            doc
          ]);
      setState(() {cartList = tempTotal;});
      debugPrint(cartList.toString());
    });

    await FirebaseFirestore.instance
        .collection('orders')
        .add({
      "uId":  uId,
      "customerName":  orderNameController.text,
      "customerAddress":  orderAddressController.text,
      "customerPhone":  orderPhoneController.text,
      "totalBill": cartTotalBill,
    }).then((value) {
      cartList.forEach((element) {
        FirebaseFirestore.instance
            .collection('orders').doc(value.id)
            .collection('orderDetails')
            .add({
          "hotelName":  element.get('hotelName'),
          "hotelLat": element.get('hotelLat'),
          "hotelLong": element.get('hotelLong'),
          "hotelAddress": element.get('hotelAddress'),
          "hotelImageUrl": element.get('hotelImageUrl'),
          "menuImageUrl": element.get('menuImageUrl'),
          "menuName": element.get('menuName'),
          "menuPrice": element.get('menuPrice'),
          "Quantity": element.get('Quantity'),
        });
      });
    });
    Get.offAll(HomeScreenT1());
    Get.snackbar(
        'Confirm',
        'Successfully Order Placed',
        colorText: Colors.black,
        backgroundColor: Colors.grey
    );
    FirebaseFirestore.instance.collection('cart').where('uId', isEqualTo: uId).get().then((snapshot){
      for(DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }

}

Widget _circleWhite() {
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

Widget _circleOrange() {
  return Row(
    children: <Widget>[
      SizedBox(
        width: 18.0,
      ),
      CircleAvatar(
        backgroundColor: Color(0xFFF48522),
        radius: 2.0,
      ),
      SizedBox(
        width: 7.0,
      ),
      CircleAvatar(
        backgroundColor: Color(0xFFF48522),
        radius: 2.0,
      ),
      SizedBox(
        width: 7.0,
      ),
      CircleAvatar(
        backgroundColor: Color(0xFFF48522),
        radius: 2.0,
      ),
      SizedBox(
        width: 7.0,
      ),
      CircleAvatar(
        backgroundColor: Color(0xFFF48522),
        radius: 2.0,
      ),
      SizedBox(
        width: 18.0,
      ),
    ],
  );
}
