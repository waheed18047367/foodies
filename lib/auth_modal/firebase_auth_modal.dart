import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multi_order_food_app/screens/admin/addrestuarant.dart';
import 'package:multi_order_food_app/screens/admin/adminHome.dart';
import 'package:multi_order_food_app/screens/home_screen.dart';
import 'package:multi_order_food_app/screens/sign_in_screens.dart';
import 'package:multi_order_food_app/screens/rider/delivery_boy_screen.dart';

GetStorage box = GetStorage();

class FirebaseAuthentication{

  void signInWithEmailAndPassword(method, String email, String password) async {

    try{
      final User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;

      method();
      if (user != null) {
        if(user.email == 'foodadmin@admin.com'){
          print('admin exist');
          box.write('session', 'adminActive');
          Get.offAll(AdminHome());
        }else if(user.email == 'rider@food.com'){
          print('rider exist');
          box.write('session', 'riderActive');
          Get.offAll(DeliveryBoyScreen());
        }else{
          print('user exist');
          box.write('session', 'active');
          Get.offAll(HomeScreenT1());
        }
      } else {
        print('user not found');
        box.write('session', 'inActive');
      }}on FirebaseAuthException catch (e){
      method();
      Get.snackbar('${e.code}', '',);
    }

  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> signUp(method,
      String name,
      String phone,
      String email,
      String password,)async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((user){
        _firestore.collection('users').add({
          'name':name,
          'email':email,
          'phone':phone,
          'uid':user.user.uid,
        });
      });
      method();
      box.write('session', 'active');
      Get.offAll(HomeScreenT1());
      return true;
    }on FirebaseAuthException catch(e){
      method();
      Get.snackbar('${e.code}', '',);
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    await FirebaseAuth.instance.signOut();
    box.write('session', 'inActive');
    Get.offAll(SignInScreen());
  }
}