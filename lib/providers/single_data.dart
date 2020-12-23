import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const kGoogleApiKey = "AIzaSyDdbA43bFJOu8AZVMa54af8CvC_zzSZHMs";

class SingleData with ChangeNotifier{
  String pickup;
  String destination;
  String fare;
  String time;
  String distance;

  SingleData({
    @required this.pickup,
    @required this.destination,
    @required this.fare,
    @required this.time,
    @required this.distance,
  });

  Future<Map<String, Object>> calculateNow(pickup, destination) async{
    final url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins="+pickup+"&destinations="+destination+"&key=AIzaSyDdbA43bFJOu8AZVMa54af8CvC_zzSZHMs";
    try{
    final response  = await http.post(url);
    return json.decode(response.body);
    }catch(error){
      throw(error.toString());
    }
  }

  Future<Map> calculateMore(Map addy) async{
    String pickup = addy['pickup'];
    List all = [];
    addy.forEach((key, value) {
      if (key != 'pickup') {
        all.add(value);
      }
    });
    destination = all.join('|');
    final url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins="+pickup+"&destinations="+destination+"&key=AIzaSyDdbA43bFJOu8AZVMa54af8CvC_zzSZHMs";
    try{
    final response  = await http.post(url);
    return json.decode(response.body);
    }catch(error){
      throw(error.toString());
    }
  }

  Future<Map> calculateOrder(Map addy) async{
    String pickup = addy['pickup'];
    List all = [];
    List order = [];
    List mMap = [];
    int totalA = 0;
    addy.forEach((key, value) {
      if (key != 'pickup') {
        all.add(value);
      }
    });
    destination = all.join('|');
    final url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins="+pickup+"&destinations="+destination+"&key=AIzaSyDdbA43bFJOu8AZVMa54af8CvC_zzSZHMs";
    try{
    final response  = await http.post(url);
    Map data = json.decode(response.body);
    data['rows'][0]['elements'].forEach((k) {
        order.add(k["duration"]["value"]);
    });
    order.sort();
   
    for (var i = 0; i < order.length; i++) {
      data['rows'][0]['elements'].forEach((k){
        if (k["duration"]["value"] == order[i]) {
          var a = data['rows'][0]['elements'].indexOf(k);
          mMap.add({'address':data["destination_addresses"][a],'elements':k});
        }
      });
    }
    mMap.forEach((e) { 
      int price = (num.parse(e['elements']['distance']['text'].substring(0, e['elements']['distance']['text'].length - 3)) * 75).ceil();
      if (price < 1200) {
        totalA += 1200;
      } else{
        totalA += price;
      }
      
    });
    return {'pickup':data['origin_addresses'][0], 'data':mMap, 'total':totalA};
    }catch(error){
      throw(error.toString());
    }
  }
}