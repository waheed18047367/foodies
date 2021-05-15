import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'menu_display_screen.dart';

class MapsScreen extends StatefulWidget {
  MapsScreen({Key key}) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {

  GoogleMapController _controller;
  BitmapDescriptor customIcon;
  bool isMapCreated = false;
  String _mapStyle;
  List<Marker> allMarkers = [];

  PageController _pageController;

  int prevPage;

  createMarker(context) {
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
          configuration, 'assets/marker.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMapPin();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void setCustomMapPin() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/marker.png');
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  _restaurantList(index, QueryDocumentSnapshot snapshot) {
    String _id = snapshot.id;
    String _image = snapshot.get('hotelImageUrl');
    String _title = snapshot.get('hotelName');
    String _address = snapshot.get('hotelAddress');
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: Padding(
        padding:
        const EdgeInsets.only(left: 0.0, right: 8.0, top: 5.0, bottom: 5.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new MenuDisplayScreen(
                  docId: _id,
                )));
          },
          child: Container(
            height: 140.0,
            width: 340.0,
            decoration: BoxDecoration(
                color: Color(0xFF1E2026),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      color: Colors.black12.withOpacity(0.03))
                ]),
            child: Row(
              children: <Widget>[
                Hero(
                  tag: "hero-grid-${_id}",
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 140.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                          color: Color(0xFF1E2026),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                          image: DecorationImage(
                              image: NetworkImage(_image), fit: BoxFit.cover)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: 150.0,
                          child: Text(
                            _title,
                            style: TextStyle(
                                fontFamily: "Sofia",
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0),
                            overflow: TextOverflow.ellipsis,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 14.0,
                              color: Colors.white,
                            ),
                            Container(
                              width: 140.0,
                              child: Text(
                                _address,
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14.5,
                                    fontFamily: "Sofia",
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellowAccent,
                                      size: 21.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellowAccent,
                                      size: 21.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellowAccent,
                                      size: 21.0,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellowAccent,
                                      size: 21.0,
                                    ),
                                    Icon(
                                      Icons.star_half,
                                      color: Colors.yellowAccent,
                                      size: 21.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<QueryDocumentSnapshot> allSnapshot = [];

  @override
  Widget build(BuildContext context) {
    createMarker(context);
    return Scaffold(
        backgroundColor: Color(0xFF1E2026),
        body: StreamBuilder<QuerySnapshot>(
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
                snapshot.data.docs.forEach((element) {
                  allSnapshot.add(element);
                  allMarkers.add(Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange,
                      ),
                      markerId: MarkerId(element.get('hotelName')),
                      draggable: false,
                      infoWindow:
                      InfoWindow(title: element.get('hotelName'), snippet: element.get('hotelAddress')),
                      position: LatLng(
                          double.parse(element.get('hotelLatitude')),
                          double.parse(element.get('hotelLongitude'))
                  )
                  )
                  );
                });
                return Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                double.parse(snapshot.data.docs[1].get('hotelLatitude')),
                                double.parse(snapshot.data.docs[1].get('hotelLongitude'))
                            ),
                            zoom: 13.0
                        ),
                        markers: Set.from(allMarkers),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          // _controller.setMapStyle(_mapStyle);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 250,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _restaurantList(index,snapshot.data.docs[index]);
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Container(
                            height: 75.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 30.0),
                              child: Center(
                                child: Text(
                                  "Locations",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Sofia",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0,
                                      letterSpacing: 1.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return SizedBox();
              }
            }),

    );
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            double.parse(allSnapshot[_pageController.page.toInt()].get('hotelLatitude')),
            double.parse(allSnapshot[_pageController.page.toInt()].get('hotelLongitude'))
        ),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)
    )
    );
  }
}
