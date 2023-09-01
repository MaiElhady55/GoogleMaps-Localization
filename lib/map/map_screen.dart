import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/localization/localization_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
//****Geolocator*****
//1-Services Location --> Enabled (True) OR Disable (False)
//2-permission
//3- get Position--> Lat & Long

  Future getPer() async {
    bool services;
    LocationPermission per;
    services = await Geolocator.isLocationServiceEnabled();
    if (services == false) {
      // ignore: use_build_context_synchronously
      AwesomeDialog(
              context: context,
              title: 'Services',
              body: const Text('Services Not Enabled'))
          .show();
    }
    per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied) {
      per = await Geolocator.requestPermission();
      //If Still Denied dosen't giv per so navigate to login screen
      if (per == LocationPermission.always ||
          per == LocationPermission.whileInUse) {
        //get position
      }
    }
    return per;
  }

  Future<Position> getLatAndLong() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  //GET Current Location
  CameraPosition? _kGooglePlex;
  late Position cl;
  late double lat;
  late double long;
  Future<void> getCurrentPosition() async {
    cl = await Geolocator.getCurrentPosition();
    lat = cl.latitude;
    long = cl.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long), //LatLng(31.040949, 31.378469),
      zoom: 14.4746,
    );
    myMarkers.add(
      Marker(
        markerId: const MarkerId('3'),
        position: LatLng(lat, long),
      ),
    );
    setState(() {});
  }

  //********************************************/
  //Live Location
  late StreamSubscription<Position> ps;

  @override
  void initState() {
    ps = Geolocator.getPositionStream().listen(
      (Position position) {
        changeMarker(position.latitude, position.longitude);
      },
    );
    getPer();
    getCurrentPosition();
    setMarkerCustomImage();
    getPolyline();
    super.initState();
  }

  GoogleMapController? gmc;

  changeMarker(newLatitude, newLongitude) {
    myMarkers.clear(); // to ensure thir is on marker in set and delet from map
    myMarkers.add(Marker(
        markerId: const MarkerId('3'),
        position: LatLng(newLatitude, newLongitude)));
    gmc?.animateCamera(
        CameraUpdate.newLatLng(LatLng(newLatitude, newLongitude)));
    setState(() {});
  }

  //*******************************************************8 */
  //Markers
  Set<Marker> myMarkers = {
    Marker(
        markerId: const MarkerId('2'),
        infoWindow: const InfoWindow(title: '2'),
        position: const LatLng(31.404881, 31.213360),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
  };

  setMarkerCustomImage() async {
    myMarkers.add(
      Marker(
          markerId: const MarkerId('1'),
          infoWindow: InfoWindow(
            title: '1',
            onTap: () {
              print('Tap Info Marker');
            },
          ),
          onTap: () {
            print('Tap Marker');
          },
          position: const LatLng(31.040949, 31.378469),
          draggable: true,
          onDragEnd: (value) {
            print('On Dragg End');
          },
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration.empty, 'assets/images/marker.png')),
    );
  }

//*************Start PoluLine********************

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBXCaROn5NKadgTCNz7F5akg0WT2ZUHSMY";

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 6,
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates);

    polylines[id] = polyline;
    setState(() {});
  }

  getPolyline() async {
    //PolylineResult result =
    await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      const PointLatLng(31.040949, 31.378469), //Start
      const PointLatLng(30.968307, 31.168782), //End
      travelMode: TravelMode.driving,
    );
    // if (result.points.isNotEmpty) {
    // result.points.forEach((PointLatLng point) {
    polylineCoordinates.add(const LatLng(31.040949, 31.378469)); //Start
    polylineCoordinates.add(const LatLng(30.968307, 31.168782)); //End
    // });
    //}
    addPolyLine();
  }

//*************Endd PolyLine*********************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const LocalizationScreen();
                  },
                ));
              },
              icon: const Icon(Icons.arrow_forward_ios))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _kGooglePlex == null
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      polylines: Set<Polyline>.of(polylines.values),
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex!,
                      onMapCreated: (GoogleMapController controller) {
                        gmc = controller;
                      },
                      markers: myMarkers,
                      onTap: (latLng) {
                        /* myMarkers.remove(const Marker(markerId: MarkerId('2')));
                        myMarkers.add(Marker(
                            markerId: const MarkerId('2'), position: latLng));
                        setState(() {});*/
                      },
                    ),
                  ),
            ElevatedButton(
                onPressed: () async {
                  Position cl = await getLatAndLong();
                  // print(cl.latitude);
                  //print(cl.longitude);
                  List<Placemark> placemarks =
                      await placemarkFromCoordinates(cl.latitude, cl.latitude);
                  print(placemarks[0].country);
                },
                child: const Text('Show Lat And Long')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  var distance = Geolocator.distanceBetween(
                      24.303054, 24.303054, -1.032659, 16.507410);
                  var distanceKM = distance / 1000;
                  print('dis $distanceKM');
                },
                child: const Text('Get Distance')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  LatLng latLng = const LatLng(31.040949, 31.378469);
                  gmc?.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: latLng, zoom: 10, tilt: 45, bearing: 45)));
                },
                child: const Text('Go to Mansoura')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  //to get Coordinate for any position by X , Y
                  var xy = await gmc
                      ?.getLatLng(const ScreenCoordinate(x: 30, y: 30));
                  print(xy);

                  //to get Zoom by controller
                  var zoom = await gmc?.getZoomLevel();
                  print(zoom);
                },
                child: const Text('Get LatLng By Controller')),
          ],
        ),
      ),
    );
  }
}
