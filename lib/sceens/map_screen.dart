import 'dart:async';
import 'dart:math' as Math;
import 'package:Area_finder/sceens/appebarewid.dart';
import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:Area_finder/sceens/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';

class ScreenArguments {
  final List<LatLng> polyfils;
  final String polyfilsCalculatedArea;

  ScreenArguments(this.polyfils, this.polyfilsCalculatedArea);
}

class MapDetails extends StatefulWidget {
  final String firstName, mobileNo, userId, password, profileKey;
  MapDetails(
      {this.firstName,
      this.mobileNo,
      this.userId,
      this.password,
      this.profileKey});
  @override
  State<MapDetails> createState() => MapDetailsState();
}

class MapDetailsState extends State<MapDetails> {
  BitmapDescriptor myIcon;

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  dynamic custom_markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  List<LatLng> polyPoints = [];
  List<LatLng> polyPoints1 = [];
  Location myLocation;
  LocationData _startLocation;
  LocationData _currentLocation;
  CameraPosition _currentCameraPosition;
  CameraPosition _position1;
  var currentLocation = LocationData;
  var sliderValue = 18.5;
  var flag = false;
  var address = "";

  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = new Location();
  bool _permission = false;
  String error;
  bool currentWidget = true;
  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'images/dot.png')
        .then((onValue) {
      myIcon = onValue;
    });
    _clearAllMarkers();
    initPlatformState();
    super.initState();
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 100, distanceFilter: 1.0);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        if (_permission) {
          location = await _locationService.getLocation();

          final coordinates =
              Coordinates(location.latitude, location.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          var first = addresses.first;
          address = first.addressLine;
          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
              target: LatLng(result.latitude, result.longitude),
              zoom: sliderValue,
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));

            if (mounted) {
              setState(() {
                _currentLocation = result;
                if (flag) {
                  var geoFencelatlngs = [];
                  var geoFencelatlngsq = [];
                  var data = {};
                  data['lat'] = result.latitude;
                  data['lng'] = result.longitude;
                  geoFencelatlngs.add(data);
                  geoFencelatlngsq.add(
                      {_currentLocation.latitude, _currentLocation.longitude});
                  custom_markers['geoFencelatlngs'] = geoFencelatlngs;
                  polyPoints1.add(LatLng(
                      _currentLocation.latitude, _currentLocation.longitude));
                  polyPoints.add(LatLng(
                      _currentLocation.latitude, _currentLocation.longitude));
                  _drawPolygon(polyPoints);
                  _markers.add(
                    Marker(
                      draggable: true,
                      markerId: MarkerId(LatLng(_currentLocation.latitude,
                              _currentLocation.longitude)
                          .toString()),
                      position: LatLng(_currentLocation.latitude,
                          _currentLocation.longitude),
                      infoWindow:
                          InfoWindow(title: 'title', snippet: 'snippet'),
                      icon: BitmapDescriptor.defaultMarker,
                      anchor: Offset(100, 160),
                    ),
                  );
                }
                setState(() {
                  _startLocation = location;
                  _position1 = CameraPosition(
                    target: LatLng(
                        _startLocation.latitude, _startLocation.longitude),
                    zoom: sliderValue,
                  );
                });
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }
  }

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
//    position.zoom;
  }

  _clearAllMarkers() {
    setState(() {
      _markers.clear();
      _polygons.clear();
      polyPoints.clear();
      flag = true;
    });
  }

  _drawPolygon(List<LatLng> listLatLng) {
    setState(() {
      _polygons.add(Polygon(
          polygonId: PolygonId('123'),
          points: listLatLng,
          fillColor: Colors.transparent,
          strokeColor: Colors.red));
    });
  }

  final List setOfLatLong = [];

  convertLatLongToJson(data) {
    var data2 = data;
    data2
        .map((latlong) => {
              setOfLatLong
                  .add({'lat': latlong.latitude, 'lng': latlong.longitude})
            })
        .toList();
    return setOfLatLong;
  }

  _calculateArea() {
    setState(() {
      flag = false;
    });
    if (polyPoints.isNotEmpty) {
      polyPoints.add(polyPoints[0]);
      var area = calculatePolygonArea(polyPoints).toStringAsFixed(4);
      Navigator.pushNamed(context, CapturedAreaRoute, arguments: {
        'polyPoints': convertLatLongToJson(polyPoints),
        'calculatedArea': area,
        'mobileNo': widget.mobileNo,
        'userName': widget.firstName,
        'profileKey': widget.profileKey,
        'password': widget.password,
        'userId': widget.userId,
        'address': address,
        'flag':true,
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: new Text(
                    "Information",
                    style: TextStyle(color: Colors.teal[700]),
                  ),
                  content: Text("Please click on start to calculate Area !!!",
                      textAlign: TextAlign.left),
                  actions: <Widget>[
                    RaisedButton(
                      color: Colors.teal[700],
                      child: Text(
                        'ok'.toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]));
    }
  }

  static double calculatePolygonArea(List coordinates) {
    double area = 0;

    if (coordinates.length > 2) {
      for (var i = 0; i < coordinates.length - 1; i++) {
        var p1 = coordinates[i];
        var p2 = coordinates[i + 1];
        area += convertToRadian(p2.longitude - p1.longitude) *
            (2 +
                Math.sin(convertToRadian(p1.latitude)) +
                Math.sin(convertToRadian(p2.latitude)));
      }

      area = area * 6378137 * 6378137 / 2;
    }

    return area.abs() * 0.000247105;
  }

  static double convertToRadian(double input) {
    return input * Math.pi / 180;
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.teal[700],
      child: Icon(icon, size: 25.0),
      heroTag: icon.toString(),
    );
  }

  void navigationPage() {
    Navigator.popAndPushNamed(context, LandingScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    startTime() async {
      var _duration = Duration(seconds: 0);
      return Timer(_duration, navigationPage);
    }

    return Scaffold(
      endDrawer: Drawers(),
      appBar: MyAppBar(
          falg: true,
          leadingButton: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: startTime,
          )),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(17.3984, 78.5583), zoom: sliderValue),
            mapType: _currentMapType,
            markers: _markers,
            polygons: _polygons,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 16.0),
                      RaisedButton(
                        onPressed: _clearAllMarkers,
                        child: Text(
                          "Restart",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.teal[700],
                      ),
                      SizedBox(width: 16.0),
                      RaisedButton(
                          onPressed: _calculateArea,
                          child: Text(
                            "Finish",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.teal[700]),
                      SizedBox(width: 16.0),
                    ],
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          child: Slider(
                            min: 5.0,
                            max: 30.0,
                            divisions: 25,
                            value: sliderValue,
                            activeColor: Colors.teal[700],
                            inactiveColor: Colors.blueAccent,
                            onChanged: (newValue) {
                              setState(() {
                                sliderValue = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    initPlatformState();
  }
}
