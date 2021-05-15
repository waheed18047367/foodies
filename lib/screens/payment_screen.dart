import 'package:credit_card/credit_card_model.dart';
import 'package:flutter/material.dart';
import 'package:credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:multi_order_food_app/screens/delivery_screen.dart';

import 'package:multi_order_food_app/data_modal/global_data.dart';

import 'confirm_screen.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cardHolderName = '';
    cardNumber = '';
    cardCode = '';
    cardExpiryDate = '';
  }


  @override
  bool isCvvFocused = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E2026),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Payment",
          style: TextStyle(
              fontFamily: "Sofia",
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => DeliveryScreen())),
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
                _circleWhite(),
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
              color: Color(0xFF23252E).withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 50.0),
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.white,
                    hintColor: Colors.white.withOpacity(0.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CreditCardWidget(
                        cardNumber: cardNumber,
                        expiryDate: cardExpiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cardCode,
                        showBackView:
                            isCvvFocused, //true when you want to show cvv(back) view
                      ),
                      SingleChildScrollView(
                        child: Container(
                          color: Color(0xFF23252E).withOpacity(0.7),
                          child: Theme(
                            data: ThemeData(
                              primaryColor: Colors.white,
                              hintColor: Colors.white.withOpacity(0.1),
                            ),
                            child: CreditCardForm(
                              themeColor: Colors.white,
                              textColor: Colors.white,
                              cursorColor: Colors.white,
                              onCreditCardModelChange: onCreditCardModelChange,
                              cardHolderName: cardHolderName,
                              cardNumber: cardNumber,
                              cvvCode: cardCode,
                              expiryDate: cardExpiryDate,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 50.0),
                        child: InkWell(
                          onTap: () {
                            if(
                            cardHolderName != ''&&
                            cardNumber != ''&&
                            cardCode != ''&&
                            cardExpiryDate != ''
                            ){
                              Navigator.of(context).push(
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ____) =>
                                          ConfirmScreen()));
                            }else{
                              Get.snackbar('Error', 'Please Fill Complete Form',colorText: Colors.black,backgroundColor: Colors.grey);

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
            )
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      cardExpiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cardCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
      print('cardNumber $cardNumber');
      print('cardExpiryDate $cardExpiryDate');
      print('cardHolderName $cardHolderName');
      print('cardCode $cardCode');
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
