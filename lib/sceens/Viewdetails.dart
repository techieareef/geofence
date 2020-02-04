import 'dart:ui';
import 'package:Area_finder/providers/auth_provider.dart';
import 'package:Area_finder/sceens/appebarewid.dart';
import 'package:Area_finder/sceens/routing%20Constants.dart';
import 'package:Area_finder/sceens/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ViewMaps extends StatefulWidget {
  String profilekey;
  ViewMaps({this.profilekey});
  @override
  _ViewMapsState createState() => _ViewMapsState();
}

class _ViewMapsState extends State<ViewMaps> {
  dynamic jsondata;
  List data;
  dynamic response;
  var datalength= 0;
//  String userName;

  @override
  void initState() {
    super.initState();
    getJsonData();
  }

  Future<String> getJsonData() async {
//    print("==========profilekey=========");
//    print((widget.profilekey));
    response = await http.get(
        Uri.encodeFull(
            "http://www.devkalgudi.vasudhaika.net/rest/v1/profiles/data/geofence?markedBy="+widget.profilekey),
        headers: {"Accept": "application/json"});
    jsondata = json.decode(response.body);
    this.setState(() {
      try {
        data = jsonDecode ( jsondata['data'] );
      }catch (e){
      data =[];}

      data=data.reversed.toList();
      print('*--*-*-*-*-*-*-*-*-*--**-*-*-*-*-');
      print(data.length);
      datalength=data.length;

    });

    return "success";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        endDrawer: Drawers(),
        appBar: MyAppBar(
          falg: true,
        ),
        body: datalength!=0?Container(
          color: Colors.white,
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.teal[700],
            onRefresh:getJsonData ,
            child: ListView.builder(

//            reverse: true,
              scrollDirection: Axis.vertical,
              itemCount: datalength!=null?datalength:0,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return Container(
                  height: MediaQuery.of(context).size.height*0.39,
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Card(
                    elevation: 5.0,

                    color: Colors.teal[700],
                    child: Container(
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.1, 0.5, 0.8, 0.9],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.teal[800],
                            Colors.teal[400],
                            Colors.teal[400],
                            Colors.teal[500],
                          ],
                        ),
                      ),
                      child: Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left:20.0,top: 20.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Area : ',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),

                                Text(
                                    data[i]['area'] == null ||
                                        data[i]['area'] == ""
                                        ? '0.00'
                                        : data[i]['area'].toString()=='0'?'0.0000':data[i]['area'].toString(),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),

                              ],
                            )),


                        Padding(
                          padding: EdgeInsets.only(left:20,top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 1.0),
                                child:Text(
                                  'Created Time : ',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  '${data[i]['CTS'] == null || data[i]['CTS'] == "" ? "2020-01-29 17:26:33" : (data[i]['CTS'].toString()).split('.')[0].toString()} ',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:20,top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 1.0),
                                child:Text(
                                  'Marked For : ',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  '${data[i]['markedFor'] == null || data[i]['markedFor'] == "" ? "2020-01-29 17:26:33" : data[i]['markedFor'].toString()} ',
                                  style: TextStyle(
                                    fontSize: 12.0, color: Colors.white,),textAlign: TextAlign.start,
                                  maxLines: 1,

                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:20,top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 1.0),
                                child: Text(
                                  'Note : ',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  '${data[i]['note'] == null || data[i]['note'] == "" ? "......" : data[i]['note'].toString()} ',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:20,top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 1.0),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  )),

                              Expanded(
                                child: Text(
                                  '${data[i]['address'] == null || data[i]['address'] == "" ? "Location Not Found..." : data[i]['address'].toString()} ',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          heightFactor: 1.5,
                          child: Container(
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Box decoration takes a gradient
                              gradient: LinearGradient(
                                // Where the linear gradient begins and ends
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                // Add one stop for each color. Stops should increase from 0 to 1
                                stops: [0.1, 0.5, 0.7, 0.9],
                                colors: [
                                  // Colors are easy thanks to Flutter's Colors class.
                                  Colors.white,
                                  Colors.teal[700],
                                  Colors.teal[300],
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: FloatingActionButton(
                              heroTag: i,
                              elevation: 20.0,
                              backgroundColor: Colors.transparent.withOpacity(0.0),
                              onPressed: (){
//                                print('next screen pressed'+data[i]['latlongs'].toString());
                                Navigator.pushNamed(context, CapturedAreaRoute, arguments: {
                                  'polyPoints': data[i]['latlongs'],
                                  'calculatedArea': (data[i]['area']).toString(),
                                  'mobileNo': "9110734268",
                                  'userName': "abhiram",
                                  'profileKey': "abcdef",
                                  'password': "12345678",
                                  'userId': "12345678",
                                  'address': data[i]['address']??"hello",
                                  'flag':false,
                                });
                              },
                              child: Icon(Icons.arrow_forward,size: 19.0,),
                            ),
                          ),),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ):Container(child: Center(child: Text("No Records Found...",style: TextStyle(fontSize: 16.0),),),));
  }
}
