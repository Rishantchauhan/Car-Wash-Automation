import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingService extends ChangeNotifier {
  static const String _baseUrl = 'http://192.168.0.7:3000/api/booking';
  List<dynamic>Orders=[];
  Future<dynamic> bookWash(String vehicleId, String washQuality, double price,String name) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'vehicleId': vehicleId, 'washQuality': washQuality, 'price': price,'vehiclename':name}),
    );
    if (response.statusCode == 200) {
      return "Booking Success";
    }
    else {
      return response.body;
    }
  }
  Future<bool> getBooking()async {
     final url=Uri.parse(_baseUrl+'/get');
     final pref=await SharedPreferences.getInstance();
     final token=pref.getString('token');

     final response=await http.get(url,
       headers: {
         'Content-Type':'application/Json',
         'Authorization': '$token'
       }
     );
     if(response.statusCode==200){
        Orders=jsonDecode(response.body);
        notifyListeners();
         return true;
     }
     else return false;
  }
}
