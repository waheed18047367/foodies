import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:multi_order_food_app/data_modal/global_data.dart';
import 'package:multi_order_food_app/screens/delivery_screen.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    super.initState();
    totalCartBill();
  }

  int cartTotalBill = 0;

  void totalCartBill() {
    FirebaseFirestore.instance
        .collection('cart')
        .where('uId', isEqualTo: uId)
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + int.parse(doc.data()['totalBill'].toString()));
      if(mounted){
        setState(() {cartTotalBill = tempTotal;});
      }
      debugPrint(cartTotalBill.toString());
    });
  }

  /// Declare price and value for chart
  int delivery = 4;
  String _payButton = "Pay";
  Color _colorsButton1 = Color(0xFFF48522);
  Color _colorsButton2 = Colors.orangeAccent;
  @override
  var _appBar = AppBar(
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: Color(0xFFF48522)),
    centerTitle: true,
    backgroundColor: Color(0xFF1E2026),
    title: Text(
      "My Cart",
      style: TextStyle(
          fontFamily: "Sofia",
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Colors.white),
    ),
    elevation: 0.0,
  );


  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color(0xFF1E2026),
        appBar: _appBar,

        body: cartTotalBill == 0
            ?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Your \nCart \nis \nEmpty',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.orangeAccent
                ),
              ),
            ),
          ],
        )
            :Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 0.1,
              color: Colors.white70,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 20.0),
                child: Container(
                  color: Color(0xFF23252E),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Items to Order",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Sofia",
                              fontWeight: FontWeight.w600,
                              fontSize: 17.5),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
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
                                    height: MediaQuery.of(context).size.height*.42,
                                    child: ListView(
                                      children: snapshot.data.docs.map((doc) {
                                        return Slidable(
                                          actionPane: new SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          secondaryActions: <Widget>[
                                            new IconSlideAction(
                                              caption: "Item Delete",
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () async{
                                                await FirebaseFirestore.instance.collection('cart').doc(doc.id).delete();
                                              },
                                            ),
                                          ],
                                          child: Padding(
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      DeliveryScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 35.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: _colorsButton1),
                              child: Center(
                                child: Text(
                                  _payButton,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Sofia",
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 5.0, left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Order ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15.5,
                        fontFamily: "Sofia"),
                  ),
                  Text(
                    " ${$pound} " + cartTotalBill.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.5,
                        fontFamily: "Sofia"),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 5.0, left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Delivery ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15.5,
                        fontFamily: "Sofia"),
                  ),
                  Text(
                    " ${$pound} " + delivery.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.5,
                        fontFamily: "Sofia"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 0.1,
              color: Colors.white70,
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total ",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Sofia",
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " ${$pound} ${cartTotalBill+delivery}",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Sofia",
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        )
    );
  }
}
