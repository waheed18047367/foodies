import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_order_food_app/data_modal/global_data.dart';

class DetailRestaurentScreen extends StatefulWidget {
  QueryDocumentSnapshot snapshot;
  DetailRestaurentScreen({this.snapshot});

  @override
  _DetailRestaurentScreenState createState() => _DetailRestaurentScreenState();
}

class _DetailRestaurentScreenState extends State<DetailRestaurentScreen> {
  @override

  final Set<Marker> _markers = {};
   LatLng _currentPosition ;
  GoogleMapController _controller;
  String _mapStyle;

  @override
  void initState() {
    _currentPosition = LatLng(double.parse(widget.snapshot.get('hotelLat')), double.parse(widget.snapshot.get('hotelLong')));
    _markers.add(
      Marker(
        markerId: MarkerId("${widget.snapshot.get('hotelLat')}, ${widget.snapshot.get('hotelLong')}"),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        ),
      ),
    );
    super.initState();
  }

  Widget build(BuildContext context) {


    var _icon = Container(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          _line(),
        ],
      ),
    );



    var _location = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 0.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: Text(
            "Location",
            style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 20.0,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          height: 190.0,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(widget.snapshot.get('hotelLat')), double.parse(widget.snapshot.get('hotelLong'))),
              zoom: 13.0,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              // _controller.setMapStyle(_mapStyle);
            },
          ),
        ),
      ],
    );

    var _background = Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.94,
          child: Image(
            image: AssetImage('assets/profileBackground.png'),
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 200.0,
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
                    image: DecorationImage(image: NetworkImage(widget.snapshot.get('menuImageUrl'))),
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
          child: Text(
            widget.snapshot.get('menuName'),
            style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 24.5,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Color(0xFF1E2026),
      body: SingleChildScrollView(
        child: Stack(
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

                  /// For icon row
                  _icon,
                  
                  /// Location
                  _location,
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: ListTile(
                      title:  Text(
                        'Payment :',
                        style: TextStyle(
                            fontFamily: "Sofia",
                            fontSize: 24.5,
                            color: Colors.white54,
                            fontWeight: FontWeight.w600),
                      ),trailing:  Text(
                      '${$pound} ${widget.snapshot.get('Quantity')*int.parse(widget.snapshot.get('menuPrice'))}',
                      style: TextStyle(
                          fontFamily: "Sofia",
                          fontSize: 20.5,
                          color: Colors.white54,
                          fontWeight: FontWeight.w600),
                    ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0,top: 20,bottom: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 55.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xff380607)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.01, 0.8]),),
                        child: Center(
                          child: Text(
                            "Received",
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
      ),
    );
  }
}


Widget _line() {
  return Container(
    height: 0.9,
    width: double.infinity,
    color: Colors.white10,
  );
}
