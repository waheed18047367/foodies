import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:multi_order_food_app/auth_modal/firebase_auth_modal.dart';
import 'package:multi_order_food_app/data_modal/restaurantModel.dart';
import 'package:multi_order_food_app/screens/cart_screen.dart';
import 'package:multi_order_food_app/screens/maps_screen.dart';
import 'package:multi_order_food_app/screens/menu_display_screen.dart';
import 'package:multi_order_food_app/data_modal/global_data.dart';

class HomeScreenT1 extends StatefulWidget {
  HomeScreenT1({Key key}) : super(key: key);

  @override
  _HomeScreenT1State createState() => _HomeScreenT1State();
}

class _HomeScreenT1State extends State<HomeScreenT1> {
  @override
  void initState() {
    // TODO: implement initState
    getHotels();
    getUser();
    getCurrentLocation();
    super.initState();
  }
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<RestaurantModel> restaurantArray = [];
  void getUser() {
    final User user = auth.currentUser;
    final uid = user.uid;
    uId = user.uid;
    print('UID--->> $uid');
    FirebaseFirestore.instance
        .collection('users')
        .where('uid',isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        userName = snapshot.docs.fold('', (tot, doc) => tot + doc.get('name'));
      });
      debugPrint(userName.toString());
    });
  }
  void getHotels() {
    restaurantArray = [];
    FirebaseFirestore.instance
        .collection('hotels')
        .snapshots()
        .listen((snapshot) {
          snapshot.docs.forEach((element) {
            restaurantArray.add(
                RestaurantModel(
                    id: element.id,
                  title: element.get('hotelName'),
                  image: element.get('hotelImageUrl'),
                  near: false,
                  price: '000',
                  ratting: '4.4',
                  lat: double.parse(element.get('hotelLatitude')),
                  long: double.parse(element.get('hotelLongitude')),
                  location: element.get('hotelAddress')
                )
            );
          });
    });
  }
  List<RestaurantModel> nearRestaurantsList = [];
  distanceCalc(){
    print('balooo');
    restaurantArray.forEach((element) async{
      double distance = await geolocator.distanceBetween(latitude, longitude, element.lat, element.long)/1000;
      print('distance->> ${distance.toString()}');

      if(distance<2){
        setState(() {
          RestaurantModel updateElement = RestaurantModel(
              near: true,
              image: element.image,
              id: element.id,
              lat: element.lat,
              location: element.location,
              long: element.long,
              price: element.price,
              ratting: element.ratting,
              title: element.title);
          nearRestaurantsList.add(updateElement);
          print('near');
        });

      }else{
        element.near=false;
      }
    });
    setState(() {
      loader=false;
    });
  }
  bool loader=true;
  double latitude;
  double longitude;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position currentPosition;

  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  String currentAddress;
  String currentArea;
  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      // setState(() {
      currentPosition = position;
      longitude= currentPosition.longitude;
      latitude= currentPosition.latitude;
      // longitude= 0.059005;
      // latitude= 51.532347;
      print("longitude : $longitude");
      print("latitude : $latitude");
      print("address : $currentPosition");
      // });
      distanceCalc();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  List<String> _image = [
    "assets/1.jpg",
    "assets/2.jpg",
    "assets/3.jpg",
    "assets/4.jpg",
    "assets/5.jpg",
    "assets/6.jpg",
    "assets/7.jpg",
  ];

  var _background = Stack(
    children: <Widget>[
      Image(
        image: AssetImage('assets/profileBackground.png'),
        height: 350.0,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Container(
        height: 355.0,
        margin: EdgeInsets.only(top: 0.0, bottom: 105.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.0, 1.0),
            // stops: [0.0, 1.0],
            colors: <Color>[
              Color(0xFF1E2026).withOpacity(0.1),
              Color(0xFF1E2026).withOpacity(0.3),
              Color(0xFF1E2026),
              //  Color(0xFF1E2026),
            ],
          ),
        ),
      ),
    ],
  );

  var _featured = Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Text(
          "Featured",
          style: TextStyle(
              fontFamily: "Sofia",
              fontSize: 18.5,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
        ),
        child: Container(
          height: 140.0,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
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
                  return Container(
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(snapshot.data.docs.length, (index){
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new MenuDisplayScreen(
                                    docId: snapshot.data.docs[index].id,
                                    hotelMap: snapshot.data.docs[index],
                                    // id: doc.id,

                                  ),
                                  transitionDuration: Duration(milliseconds: 600),
                                  transitionsBuilder:
                                      (_, Animation<double> animation, __, Widget child) {
                                    return Opacity(
                                      opacity: animation.value,
                                      child: child,
                                    );
                                  }));
                            },
                            child: cardPopular(
                                colorTop: Color(0xFF1E2026),
                                colorBottom: Color(0xFF23252E),
                                image: featuredRestaurantsIcons[index],
                                title: snapshot.data.docs[index].get('hotelName')
                            ),
                          );
                        })
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ),
      ),
    ],
  );


  var _popular = Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        height: 25.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "All",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontSize: 18.5,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600),
              ),

            ]),
      ),
      Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
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
                      height: MediaQuery.of(context).size.height*.02,
                    ),
                    Container(
                      // height: MediaQuery.of(context).size.height*.4,
                      child: Column(
                        children: snapshot.data.docs.map((doc) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new MenuDisplayScreen(
                                    docId: doc.id,
                                    hotelMap: doc,
                                    // id: doc.id,

                                  ),
                                  transitionDuration: Duration(milliseconds: 600),
                                  transitionsBuilder:
                                      (_, Animation<double> animation, __, Widget child) {
                                    return Opacity(
                                      opacity: animation.value,
                                      child: child,
                                    );
                                  }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Material(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    color: Color(0xFF1E2026),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 100.0,
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(doc.get('hotelImageUrl')),
                                            fit: BoxFit.contain,
                                          ),
                                          boxShadow: [
                                            BoxShadow(blurRadius: 0.0, color: Colors.black87)
                                          ],
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          gradient: LinearGradient(colors: [
                                            Color(0xFF1E2026),
                                            Color(0xFF23252E),
                                          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, top: 25.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          doc.get('hotelName'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Sofia",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 2.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              size: 18.0,
                                              color: Colors.white70,
                                            ),
                                            Text(
                                              doc.get('hotelAddress'),
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontFamily: "Sofia",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
      SizedBox(
        height: 20.0,
      ),
    ],
  );

  Widget build(BuildContext context) {

    var _sliderImage = Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          aspectRatio: 24 / 18,
          viewportFraction: 0.9,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: _image.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(i), fit: BoxFit.cover),
                    color: Color(0xFF23252E)),
              );
            },
          );
        }).toList(),
      ),
    );

    var _body = Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: Column(
        children: <Widget>[
          _sliderImage,
          _featured,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Near you",
                      style: TextStyle(
                          fontFamily: "Sofia",
                          fontSize: 18.5,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: (){Get.to(MapsScreen());},
                      child: Text(
                        "On Map",
                        style: TextStyle(
                            fontFamily: "Sofia",
                            fontSize: 18.5,
                            color: Colors.orangeAccent.withOpacity(0.9),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 215.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      width: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        height: 265.0,
                        child: nearRestaurantsList.length == 0
                            ?Container(
                          height: double.infinity,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                          'No \nNearBy \nRestaurants \nAvailable',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.orangeAccent
                                ),
                                ),
                              ),
                            )
                            :ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => new MenuDisplayScreen(docId: nearRestaurantsList[index].id,),
                                    transitionDuration: Duration(milliseconds: 1000),
                                    transitionsBuilder:
                                        (_, Animation<double> animation, __, Widget child) {
                                      return Opacity(
                                        opacity: animation.value,
                                        child: child,
                                      );
                                    }));
                              },
                              child: cardNear(nearRestaurantsList[index])
                            );
                          },
                          itemCount: nearRestaurantsList.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _popular,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFF1E2026),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _background,
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      userName == null
                          ?Text(
                        "Hello Alex",
                        style: TextStyle(
                            fontFamily: "Sofia",
                            fontWeight: FontWeight.w800,
                            fontSize: 30.0,
                            letterSpacing: 1.5,
                            color: Colors.white
                        ),
                      )
                    :Flexible(
                      child: Text(
                        "Hello $userName",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                              fontFamily: "Sofia",
                              fontWeight: FontWeight.w800,
                              fontSize: 30.0,
                              letterSpacing: 1.5,
                              color: Colors.white
                        ),
                      ),
                    ),
                    ]),
              ),
            ),
            Positioned(
              right: 10,
              top: 60,
              child: InkWell(
                onTap: (){
                  Get.to(CartScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50.0,
                    width: 80.0,
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.orangeAccent,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
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
            _body,
          ],
        ),
      )
    );
  }
}

class cardPopular extends StatelessWidget {
  Color colorTop, colorBottom;
  String image, title;
  cardPopular({this.colorTop, this.colorBottom, this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 4.0, top: 3.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 95.0,
            width: 95.0,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 8.0, color: Colors.black54)],
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              gradient: LinearGradient(
                  colors: [colorTop, colorBottom],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    image,
                    height: 35,
                    color: Colors.white54,
                  )),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              title,
              softWrap: true,
              style: TextStyle(
                  color: Colors.white70,
                  fontFamily: "Sofia",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class cardNear extends StatelessWidget {
  RestaurantModel _dinner;
  cardNear(this._dinner);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Container(
              height: 110.0,
              width: 180.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(_dinner.image), fit: BoxFit.contain),
                boxShadow: [
                  BoxShadow(blurRadius: 0.0, color: Colors.black87)
                ],
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                gradient: LinearGradient(colors: [
                  Color(0xFF1E2026),
                  Color(0xFF23252E),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            _dinner.title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Sofia",
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.location_on,
                size: 18.0,
                color: Colors.white70,
              ),
              Text(
                _dinner.location,
                style: TextStyle(
                    color: Colors.white70,
                    fontFamily: "Sofia",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.star,
                size: 18.0,
                color: Colors.yellow,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  _dinner.ratting,
                  style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Sofia",
                      fontSize: 13.0),
                ),
              ),
              SizedBox(
                width: 35.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

