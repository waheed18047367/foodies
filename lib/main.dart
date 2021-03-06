import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multi_order_food_app/screens/splash_screen.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          primaryColorLight: Colors.black,
          primaryColorBrightness: Brightness.light,
          primaryColor: Colors.black
      ),
    );
  }
}
