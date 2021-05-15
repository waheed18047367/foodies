import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:multi_order_food_app/data_modal/global_data.dart';

class DetailFoodScreen extends StatefulWidget {
  String hotelId;
  QueryDocumentSnapshot menuMap;
  QueryDocumentSnapshot hotelMap;
  DetailFoodScreen({this.hotelId,this.menuMap,this.hotelMap});

  @override
  _DetailFoodScreenState createState() => _DetailFoodScreenState();
}

class _DetailFoodScreenState extends State<DetailFoodScreen> {

  int itemCounter = 1;
  @override
  void initState() {
    super.initState();
    getCartLatLong();
  }

  bool distanceCheck = false;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  List<Map<String,dynamic>> checkDistanceList = [];
  void getCartLatLong() {
    FirebaseFirestore.instance
        .collection('cart')
        .where('uId', isEqualTo: uId)
        .snapshots()
        .listen((snapshot) {
      List<Map<String,dynamic>> tempTotal = snapshot.docs.fold([], (tot, doc) => tot +
          [
            {
              "lat":double.parse(doc.get('hotelLat')),
              "long":double.parse(doc.get('hotelLong')),
            }
          ]);
      if(mounted){
        setState(() {checkDistanceList = tempTotal;});
      }
      debugPrint('------->>  ${checkDistanceList.toString()}');
      distanceCheckFun();
    });

  }
  distanceCheckFun(){
    print('fadi');
    checkDistanceList.forEach((element) async{
      double distance = await geolocator.distanceBetween(
          element['lat'],
          element['long'],
          double.parse(widget.hotelMap.get('hotelLatitude')),
          double.parse(widget.hotelMap.get('hotelLongitude'))
      )/1000;
      print('distance->> ${distance.toString()}');
      if(distance > 2){
        if(mounted){
          setState(() {
            distanceCheck = true;
          });
        }

      }
    });
  }


  Widget build(BuildContext context) {

    var _background = Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.94,
          child: Image(
            image: AssetImage('assets/profileBackground.png'),
            height: 400.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 400.0,
          margin: EdgeInsets.only(top: 0.0, bottom: 105.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(0.0, 1.0),
              colors: <Color>[
                Color(0xFF1E2026).withOpacity(0.1),
                Color(0xFF1E2026).withOpacity(0.3),
                Color(0xFF1E2026),
              ],
            ),
          ),
        ),
      ],
    );
    var _headerImage = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        SizedBox(
          height: 20.0,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 240.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage('${widget.menuMap.get('menuImageUrl')}')),
                  ),
                ),
              )),
        ),
      ],
    );
    var _title = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 50.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.menuMap.get('menuName'),
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 24.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "${$pound}${widget.menuMap.get('menuPrice')}",
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 23.5,
                      color: Color(0xFFFF975D),
                      fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Color(0xFF1E2026),
      body: Stack(
        children: <Widget>[
          _background,
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// For image
                _headerImage,

                /// For title
                _title,

                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        if(itemCounter > 1){
                          setState(() {
                            itemCounter-=1;
                          });
                        }
                      },
                      child: Icon(
                        Icons.remove_circle_outline,
                        size: 30,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    Text(
                      '$itemCounter',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          itemCounter+=1;
                        });
                      },
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 30,
                        color: Colors.orangeAccent,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 30,),
                Center(
                  child: Text(
                    'Total Amount :\t\t\t${$pound}${int.parse(widget.menuMap.get('menuPrice').toString()) * itemCounter}',
                    style: TextStyle(
                      fontFamily: "Sofia",
                      fontSize: 20,
                      color: Colors.orangeAccent
                    ),
                  ),
                ),

                Spacer(),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0,top: 10,bottom: 20),
                  child: InkWell(
                    onTap: () {
                      if(distanceCheck){
                        Get.snackbar(
                            'Sorry',
                            'Could\'nt Select due to max distance',
                            colorText: Colors.black,
                            backgroundColor: Colors.grey
                        );
                      }else{
                        addToCart(widget.menuMap);
                      }
                    },
                    child: Container(
                      height: 55.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFF975D),
                                Color(0xFFFEE140),
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp)),
                      child: Center(
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.0,
                              fontFamily: "Sofia",
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void addToCart(QueryDocumentSnapshot snapshot) async{


    await FirebaseFirestore.instance
        .collection('cart')
        .add({
      "uId":  uId,
      "hotelName":  widget.hotelMap.get('hotelName'),
      "hotelLat": widget.hotelMap.get('hotelLatitude'),
      "hotelLong": widget.hotelMap.get('hotelLongitude'),
      "hotelAddress": widget.hotelMap.get('hotelAddress'),
      "hotelImageUrl": widget.hotelMap.get('hotelImageUrl'),
      "menuImageUrl": widget.menuMap.get('menuImageUrl'),
      "menuName": widget.menuMap.get('menuName'),
      "menuPrice": widget.menuMap.get('menuPrice'),
      "Quantity": itemCounter,
      "totalBill": itemCounter*int.parse(widget.menuMap.get('menuPrice').toString()),
    });

    // Get.offAll(HomeScreenT1());
    Navigator.pop(context);
    Get.snackbar(
        'Added',
        'Successfully Added to Cart',
        colorText: Colors.black,
        backgroundColor: Colors.grey
    );

  }
}






