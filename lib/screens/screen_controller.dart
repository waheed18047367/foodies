import 'package:flutter/material.dart';
import 'package:multi_order_food_app/auth_modal/firebase_auth_modal.dart';
import 'package:multi_order_food_app/screens/admin/adminHome.dart';
import 'package:multi_order_food_app/screens/home_screen.dart';
import 'package:multi_order_food_app/screens/rider/delivery_boy_screen.dart';
import 'package:multi_order_food_app/screens/sign_in_screens.dart';

class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    switch(box.read('session')){
      case 'inActive':
        return SignInScreen();
      case 'active':
        return HomeScreenT1();
      case 'adminActive':
        return AdminHome();
      case 'riderActive':
        return DeliveryBoyScreen();
      default: return SignInScreen();
    }
  }
}