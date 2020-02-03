import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Area_finder/providers/auth_provider.dart';
import 'package:Area_finder/sceens/appebarewid.dart';
import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:Area_finder/sceens/sidemenu.dart';

class CapturedArea extends StatefulWidget {
  final List areaLatitudeLongitude;
  final double calculatedArea;
  final String mobileNo, profileKey, password, userId, userName, address;
  bool flag=false;
  CapturedArea(
      {@required this.areaLatitudeLongitude,
        @required this.calculatedArea,
        this.mobileNo,
        this.password,
        this.profileKey,
        this.userId,
        this.userName,
        this.address,this.flag});

  @override
  _CapturedAreaState createState() => _CapturedAreaState();
}

class _CapturedAreaState extends State<CapturedArea> {
  final List<Marker> mapMarkers = [];
  BitmapDescriptor myIcon;
  List<Marker> allMarkers = [];
  List<Polygon> allPolygons = [];
  List<LatLng> latlongss = [];
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  final List setOfLatLong = [];
  List<LatLng> setJsonToLatlong = [];
  TextEditingController _markedFor = TextEditingController ( );
  TextEditingController _note = TextEditingController ( );

  convertLatLongToJson ( ) {
    widget.areaLatitudeLongitude.map ( ( f ) {
      setJsonToLatlong.add ( LatLng ( f['lat'], f['lng'] ) );
    } ).toList ( );
  }

  addMarkers ( ) {
    for ( var i = 0; i < setJsonToLatlong.length; i++ ) {
      Marker x = Marker (
        // visible: false,
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        icon: BitmapDescriptor.defaultMarker,
        anchor: Offset ( 100, 160 ),

        markerId: MarkerId ( setJsonToLatlong[i].toString ( ) ),
        position: setJsonToLatlong[i],
      );
      allMarkers.add ( x );
      Polygon y = Polygon (
          polygonId: PolygonId ( setJsonToLatlong.toString ( ) ),
          points: setJsonToLatlong,
          fillColor: Colors.transparent,
          strokeColor: Colors.red );
      allPolygons.add ( y );
    }
  }

  addPolygons ( ) {
    for ( var i = 0; i < setJsonToLatlong.length; i++ ) {
      latlongss.add ( setJsonToLatlong[i] );
    }
  }

  Future<void> _saveCalculatedArea (
      {String userId, profilekey, username, password} ) async {
    print ( "============= _userid======" );
    print ( "$userId, $profilekey, $username, $password,:" + _markedFor.text );
    print ( userId.split ( '+' )[1].toString ( ) );
    const url =
        'http://www.devkalgudi.vasudhaika.net/rest/v1/profiles/data/geofence';
    try {
      final response = await http.post ( url,
          body: json.encode ( {
            "markedFor": _markedFor.text,
            "markedBy": {
              "profileKey": profilekey,
              "userId": (userId.split ( '+' )[1].toString ( ))
            },
            "latlongs": widget.areaLatitudeLongitude,
            "area": widget.calculatedArea,
            "address": widget.address,
            "note": _note.text,
            "CTS": DateTime.now ( ).toString ( )
          } ),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'username': userId,
            'password': password,
          } );
      final responseData = json.decode ( response.body );
      if ( responseData['code'] == HttpStatus.ok ) {
        print ( "data posted successfully" );
      }
    } catch (e) {
      print ( 'error message: ${e.message}' );
      throw e;
    }
    print ( _connectionStatus == ConnectivityResult.wifi.toString ( ) );

    SharedPreferences pref = await SharedPreferences.getInstance ( );
    pref.setString ( 'calculatedArea',
        widget.calculatedArea.toString ( ) ); //Storing data in localStorage
    String calculatedArea =
    pref.getString ( 'calculatedArea' ); //geting data from localStorage
    print ( calculatedArea );

    if ( _connectionStatus == ConnectivityResult.wifi.toString ( ) ||
        _connectionStatus == ConnectivityResult.mobile.toString ( ) ) {
      String calculatedArea =
      pref.getString ( 'calculatedArea' ); //geting data from localStorage
      //  ToDo: send data to server

      pref.remove ( 'calculatedArea' );
      print ( calculatedArea );
    }
  }

  saveLoallyStoredData ( ) async {
    SharedPreferences pref = await SharedPreferences.getInstance ( );
    String calculatedArea = pref.getString ( 'calculatedArea' );
    print ( 'saveLoallyStoredData: $calculatedArea' );
    if ( calculatedArea.isEmpty ) {
      // _saveCalculatedArea();
    }
  }

//  ====

  @override
  void initState ( ) {
    // saveLoallyStoredData();
    // _saveCalculatedArea();
    convertLatLongToJson ( );
    print ( 'init state:===>' );
    print ( setJsonToLatlong );
    addMarkers ( );
    BitmapDescriptor.fromAssetImage (
        ImageConfiguration ( size: Size ( 20, 20 ) ), 'images/dot.png' )
        .then ( ( onValue ) {
      myIcon = onValue;
    } );

    connectivity = new Connectivity( );
    subscription =
        connectivity.onConnectivityChanged.listen ( (
            ConnectivityResult result ) {
          _connectionStatus = result.toString ( );
          if ( result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile ) {
            setState ( ( ) {} );
          }
        } );
    super.initState ( );
    _userdata ( );
  }

  _userdata ( ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance ( );


    print ( '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' );
    setState ( ( ) {
      username = prefs.getString ( "userName" );
      contact = prefs.getString ( "userId" );
      userimage = prefs.getString ( "image" );
      profilekey = prefs.getString ( "profileKey" );
      print ( username );
      print ( contact );
      print ( prefs.getString ( "image" ), );
      print ( prefs.getString ( "profileKey" ), );
    } );
//    @override
//    void dispose ( ) {
//      subscription.cancel ( );
//      super.dispose ( );
//    }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      endDrawer: Drawers ( ),
      appBar: MyAppBar (
        falg: true,
      ),
      bottomNavigationBar: BottomAppBar (
        color: Colors.transparent,
        child: Row (
          children: <Widget>[
            widget.flag ?
            Expanded (
              child: RaisedButton (
                color: Colors.red,
                child: Text (
                  'Reset',
                  style: TextStyle ( color: Colors.white ),
                ),
                onPressed: ( ) {
                  Navigator.popAndPushNamed ( context, MapScreenRoute ,arguments: {
                    'firstName': username,
                    'mobileNo': contact,
                  });
                },
              ),
            ) : Container ( height: 0, width: 0, ),
            widget.flag ?
            Expanded (
              child: RaisedButton (
                color: Color.fromRGBO ( 0, 130, 128, 1.0 ),
                child: Text (
                  'Save',
                  style: TextStyle ( color: Colors.white ),
                ),
                onPressed: ( ) {
                  showDialog (
                    context: context,
                    builder: ( _ ) =>
                        AlertDialog (
                          title: Text ( 'Enter Farmer Data' ),
                          content: Container (
                            height: 150,
                            child: Column (
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Row (
                                  children: <Widget>[
                                    Expanded (
                                        flex: 3,
                                        child: TextField (
                                          controller: _markedFor,
                                          autofocus: true,
                                          decoration: InputDecoration (
                                              labelText: 'Email| Phone' ),
                                        ) ),
                                  ],
                                ),
                                Expanded (
                                    flex: 2,
                                    child: TextField (
                                      controller: _note,
                                      keyboardType: TextInputType.multiline,
//                                  maxLength: 100,
                                      maxLines: 2,
                                      decoration:
                                      InputDecoration ( labelText: 'Note: ' ),
                                    ) )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton (
                              child: Text ( 'Ok' ),
                              onPressed: ( ) {
                                _saveCalculatedArea (
                                    userId: contact,
                                    profilekey: profilekey,
                                    password: "",
                                    username: username );
//                            Navigator.of(context).pop();
                                Navigator.popAndPushNamed ( context, Viewmaps,
                                    arguments: { 'profilekey': profilekey,'flag':true} );
                              },
                            ),
                            FlatButton (
                              child: Text ( 'Cancel' ),
                              onPressed: ( ) {
                                _note.clear ( );
                                _markedFor.clear ( );
                                Navigator.of ( context ).pop ( );
                              },
                            ),
                          ],
                        ),
                  );
                },
                //_saveCalculatedArea,
              ),
            ) : Container ( height: 0, width: 0, ),
          ],
        ),
      ),
      body: Container (
        child: Column (
          children: <Widget>[
            Expanded (
              flex: 10,
              child: GoogleMap (
                zoomGesturesEnabled: true,
                initialCameraPosition:
                CameraPosition ( target: setJsonToLatlong[0], zoom: 15.0 ),
                mapType: MapType.normal,
                markers: Set.from ( allMarkers ),
                polygons: Set.from ( allPolygons ),
              ),
            ),
            Expanded (
              flex: 3,
              child: Container (
                margin: EdgeInsets.all ( 10 ),
                padding: EdgeInsets.only ( left: 10 ),
                height: 15,
                child: SingleChildScrollView (
                  child: Column (
                    children: <Widget>[
                      Row (
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
//                        SizedBox(
//                          width: 5,
//                        ),
                          Container (
                            padding: EdgeInsets.only ( top: 5 ),
                            child: RichText (
                              text: TextSpan (
                                text: 'Area:  ',
                                style: TextStyle (
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold ),
                                children: <TextSpan>[
                                  TextSpan (
                                    text:
                                    '${widget.calculatedArea.toString ( ) !=
                                        null ? widget.calculatedArea
                                        .toString ( ) : ''} Acres',
                                    style: TextStyle (
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row (
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
//                        SizedBox(
//                          width: 5,
//                        ),

                          Text (
                            'Address:',
                            style: TextStyle (
                                fontSize: 18, fontWeight: FontWeight.bold ),
                          ),
                          SizedBox (
                            width: 5,
                          ),
                          Expanded (
                            child: Text (
                              '${widget.address.toString ( ) != null ? widget
                                  .address.toString ( ) : ''} ',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}