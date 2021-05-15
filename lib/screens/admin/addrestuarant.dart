import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class AddRestaurantPage extends StatefulWidget {
  AddRestaurantPage({Key key}) : super(key: key);
  @override
  _AddRestaurantPageState createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController hotelNameController = TextEditingController();
  TextEditingController hotelDescriptionController = TextEditingController();
  TextEditingController hotelAddressController = TextEditingController();
  TextEditingController hotelLongController = TextEditingController();
  TextEditingController hotelLatController = TextEditingController();

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;

  File _image1;
  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
      ),
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Color(0xff252525),
        appBar: AppBar(
          backgroundColor: Color(0xff2f2f2f),
          elevation: 3,
          centerTitle: true,
          title: Text(
            "Add Restaurants",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontFamily: "Sofia",
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   if(_image1 == null)
                     Container(
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(
                           width: 120,
                           child: FlatButton(
                               onPressed: () {
                                 _selectImage(
                                   ImagePicker.pickImage(
                                       source: ImageSource.gallery
                                   ),
                                 );
                                 },
                               child: Image.asset(
                                 'assets/image_picker.png',
                                 color: Colors.orangeAccent,
                               )
                           ),
                         ),
                       ),
                     ),
                   if(_image1 != null)
                   Container(
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                         width: 120,
                         child: FlatButton(
                             onPressed: () {
                               _selectImage(
                                 ImagePicker.pickImage(
                                     source: ImageSource.gallery
                                 ),
                               );
                             },
                             child: _displayChild1()
                         ),
                       ),
                     ),
                   ),

                 ],
               ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: hotelNameController,
                    style: new TextStyle(color: Colors.white,fontFamily: "Sofia",),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xff2f2f2f),
                      filled: true,
                      labelText: "Restaurants Name",
                      labelStyle: TextStyle(color: Colors.orangeAccent,fontFamily: "Sofia",),),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must Fill the Field';
                      } else return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: hotelDescriptionController,
                    style: new TextStyle(color: Colors.white,fontFamily: "Sofia",),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xff2f2f2f),
                      filled: true,
                      labelText: "Restaurants Description",
                      labelStyle: TextStyle(color: Colors.orangeAccent,fontFamily: "Sofia",),),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must Fill the Field';
                      } else return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: hotelAddressController,
                    style: new TextStyle(color: Colors.white,fontFamily: "Sofia",),
                    decoration: InputDecoration(
                      labelText: "Address",
                      labelStyle: TextStyle(color: Colors.orangeAccent,fontFamily: "Sofia",),
                      border: InputBorder.none,
                      fillColor: Color(0xff2f2f2f),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must Fill the Field';
                      } else if (value.length > 100) {
                        return 'Product name cant have more than 100 letters';
                      }else return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: hotelLatController,
                    keyboardType: TextInputType.number,
                    style: new TextStyle(color: Colors.white,fontFamily: "Sofia",),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xff2f2f2f),
                      filled: true,
                      labelText: 'Latitude',
                      labelStyle: TextStyle(color: Colors.orangeAccent,fontFamily: "Sofia",),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must Fill the Field';
                      }else return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: hotelLongController,
                    keyboardType: TextInputType.number,
                    style: new TextStyle(color: Colors.white,fontFamily: "Sofia",),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xff2f2f2f),
                      filled: true,
                      labelText: "Longitude",
                      labelStyle: TextStyle(color: Colors.orangeAccent,fontFamily: "Sofia",),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must Fill the Field';
                      }else return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: (){
                      validateAndUpload();
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
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Sofia",
                                letterSpacing: 0.9),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _selectImage(Future<File> pickImage) async {
    File tempImg = await pickImage;
    setState(() => _image1 = tempImg);
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      print('ok--1---');
     if (_image1 != null) {
       print('ok--2---');
         String imageUrl1;

         final FirebaseStorage storage = FirebaseStorage.instance;
         final String picture1 =
             "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

         firebase_storage.UploadTask task1 =
         storage.ref().child(picture1).putFile(_image1);

         firebase_storage.TaskSnapshot snapshot1 =
         await storage.ref().child(picture1).putFile(_image1);

         imageUrl1 = await snapshot1.ref.getDownloadURL();

         print('URL------>> $imageUrl1');

         await FirebaseFirestore.instance
             .collection("hotels")
             .add({
               "hotelImageUrl": imageUrl1,
               "hotelName": hotelNameController.text,
               "hotelDescription": hotelDescriptionController.text,
               "hotelAddress": hotelAddressController.text,
               "hotelLatitude": hotelLatController.text,
               "hotelLongitude": hotelLongController.text,
             });

      _formKey.currentState.reset();
      setState(() => isLoading = false);
      hotelNameController.clear();
      hotelAddressController.clear();
      hotelLatController.clear();
      hotelLongController.clear();
      hotelDescriptionController.clear();

      Get.snackbar(
          'Success',
          'Restaurants Added Successfully',
          colorText: Colors.black,
          backgroundColor: Colors.white
      );
     } else {
       Get.snackbar(
           'Error',
           'Add Image Please',
           colorText: Colors.black,
           backgroundColor: Colors.white
       );
       setState(() => isLoading = false);
     }
    }
  }






}

