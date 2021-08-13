

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:livraison_mobile/screens/creer_colis.dart';

import '../secret.dart';
import 'dart:math' show cos, sqrt, asin;

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  String dropdownValue = 'Please choose a location';

  // To show Selected Item in Text.
  String holder = '' ;
  Position _currentPosition;
  String _currentAddress = '';
  List <String> enginreq= [
    'moto ',
    'voiture',
    'Pick up',
    'Camion',
  ] ;
  void getDropDownItem(){

    setState(() {
      holder = dropdownValue ;
    });
  }
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final longController = TextEditingController();
  final largController = TextEditingController();
  final hautController = TextEditingController();
  final poidsController = TextEditingController();
  final startAddressFocusNode = FocusNode();
  final longFocusNode = FocusNode();
  final largFocusNode = FocusNode();
  final poidsFocusNode = FocusNode();
  final htFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _str = '';
  String _destinationAddress = '';
  String _placeDistance;
  double realdistanceIn;
  String dd;
  double dis;
  String pp;
  double pr;
  Set<Marker> markers = {};
  double longueur;
  double largeur;
  double hauteur;
  double poids;
  double prix;
  String engin;
  double prixMoto;
  double prixVoiture;
  double prixPick;
  double prixCamion;
  double poidsVolum;
  double poidsConsid=0.0;
  String pm;
  String v;
  String pc;
  String cm;
  double pm1;
  double v1;
  double pc1;
  double cm1;
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
      await locationFromAddress(_destinationAddress);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      double startLatitude = _startAddress == _currentAddress
          ? _currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = _startAddress == _currentAddress
          ? _currentPosition.longitude
          : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      double distanceInMeters = await Geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        destinationLatitude,
        destinationLongitude,
      );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
        realdistanceIn  =  _coordinateDistance( startLatitude,
          startLongitude,
          destinationLatitude,
          destinationLongitude,);
        dd =realdistanceIn.toStringAsFixed(2);
       dis = double.parse(dd);
        poidsVolum= longueur*largeur*hauteur/5000;
        if (poidsVolum>poids){
          poidsConsid=poidsVolum;


        }else if(poids>poidsVolum){
          poidsConsid=poids;
        }
        prixMoto = dis * 50;
         pm =  prixMoto.toStringAsFixed(3);
         pm1 = double.parse(pm);
        dis = double.parse(dd);
        prixVoiture = dis*100;
        v =  prixVoiture.toStringAsFixed(3);
        v1 = double.parse(v);
        prixPick = dis*250;
        pc =  prixPick.toStringAsFixed(3);
        pc1 = double.parse(pc);
        prixCamion = dis*500;
        cm =  prixCamion.toStringAsFixed(3);
        cm1 = double.parse(cm);


        if (0.0<poidsConsid && poidsConsid<200){
          engin= "moto";
               prix = dis*50;


        } else if (200<poidsConsid && poidsConsid<500){
          engin= "voiture";
          prix = dis*100;

        }else if (500<poidsConsid && poidsConsid<3000){
          engin= "pick up";

            prix = dis*250;

        }else if (3000<poidsConsid && poidsConsid<24000){
          engin= "camion";

            prix = dis*500;
          }

        pp =prix.toStringAsFixed(3);
        pr = double.parse(pp);

        print('prix: $prix CFA');
        print('engin: $engin');
        print('h: $holder CFA');

      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude,
      ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            // Show zoom buttons
            SafeArea(

              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Pré-Informations',
                              style: TextStyle(fontSize: 20.0),
                            ),    GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      CreerColis(longueur: longueur,largeur: largeur,hauteur: hauteur,poids: poidsConsid,prix: pr,engin: engin,adresse_recup: _str,adresse_liv: _destinationAddress,),
                                ));
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(Icons.arrow_forward)),
                            )
                          ],  ),
                            SizedBox(height: 10),
                            _textField(
                                label: 'largeur',
                                hint: 'largeur',

                                controller: largController,
                                focusNode: largFocusNode,
                                width: width,
                                locationCallback: ( value) {
                                  setState(() {
                                    largeur = double.parse(value);
                                  });
                                }),
                            SizedBox(height: 10),
                            _textField(
                                label: 'longueur',
                                hint: 'longueur',

                                controller: longController,
                                focusNode: longFocusNode,
                                width: width,
                                locationCallback: ( value) {
                                  setState(() {
                                    longueur = double.parse(value);
                                  });
                                }),
                            SizedBox(height: 10),
                            _textField(
                                label: 'hauteur',
                                hint: 'hauteur',

                                controller: hautController,
                                focusNode: htFocusNode,
                                width: width,
                                locationCallback: ( value) {
                                  setState(() {
                                    hauteur = double.parse(value);
                                  });
                                }),
                            SizedBox(height: 10),
                            _textField(
                                label: 'Poids',
                                hint: 'Poids',

                                controller: poidsController,
                                focusNode: poidsFocusNode,
                                width: width,
                                locationCallback: ( value) {
                                  setState(() {
                                    poids = double.parse(value);
                                  });
                                }),
                            SizedBox(height: 10),
                            _textField(
                                label: 'Départ',
                                hint: 'Emplacement du colis',
                                prefixIcon: Icon(Icons.looks_one),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.my_location),
                                  onPressed: () {
                                    startAddressController.text = _currentAddress;
                                    _startAddress = _currentAddress;
                                  },
                                ),
                                controller: startAddressController,
                                focusNode: startAddressFocusNode,
                                width: width,
                                locationCallback: (String value) {
                                  setState(() {
                                    _startAddress = value;
                                    _str= value;
                                  });
                                }),
                            SizedBox(height: 10),
                            _textField(
                                label: 'Destination',
                                hint: 'Point de livraison',
                                prefixIcon: Icon(Icons.looks_two),
                                controller: destinationAddressController,
                                focusNode: desrinationAddressFocusNode,
                                width: width,
                                locationCallback: (String value) {
                                  setState(() {
                                    _destinationAddress = value;
                                  });
                                }),

                            SizedBox(height: 10),
                            Visibility(
                              visible: _placeDistance == null ? false : true,
                              child: Text(
                                'DISTANCE: $dis km',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Container(
                                  width: 150,
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                          value: pm1,
                                          groupValue: pr,
                                          onChanged: (val) {
                                            pr = val;
                                            engin="Moto";
                                            setState(() {});
                                          }),
                                      Text(
                                        'Moto',
                                        style: TextStyle(fontSize: 24),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                          value: v1,
                                          groupValue: pr,
                                          onChanged: (val) {
                                            pr = val;
                                            engin="voiture";
                                            setState(() {});
                                          }),
                                      Text('Voiture', style: TextStyle(fontSize: 24))
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                          value: pc1,
                                          groupValue: pr,
                                          onChanged: (val) {
                                            pr = val;
                                            engin="Pick-up";
                                            setState(() {});
                                          }),
                                      Text('Pick-up', style: TextStyle(fontSize: 24))
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                          value: cm1,
                                          groupValue: pr,
                                          onChanged: (val) {
                                            engin="Camion";
                                            pr = val;
                                            setState(() {});
                                          }),
                                      Text('Camion', style: TextStyle(fontSize: 24))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 1),
                            Visibility(
                              visible: pr == null ? false : true,

                              child: Text(
                                'Prix pour l\'engin requis: $pr FCFA',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                DropdownButton<String>(
                                        value:dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.red, fontSize: 18),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String data) {
                                    setState(() {


                                    });
                                  },
                                  items: enginreq.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),

                                ),

                              ],  ),
                            SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: (_startAddress != '' &&
                                  _destinationAddress != '')
                                  ? () async {
                                startAddressFocusNode.unfocus();
                                desrinationAddressFocusNode.unfocus();
                                setState(() {
                                  if (markers.isNotEmpty) markers.clear();
                                  if (polylines.isNotEmpty)
                                    polylines.clear();
                                  if (polylineCoordinates.isNotEmpty)
                                    polylineCoordinates.clear();
                                  _placeDistance = null;

                                });
                                getDropDownItem();
                                _calculateDistance().then((isCalculated) {
                                  if (isCalculated) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Distance Calculée avec succès'),
                                      ),
                                    );}
                                   else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Erreur de calcul'),
                                      ),
                                    );
                                  }
                                });
                              }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Lancer'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }   }