import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehicleService extends ChangeNotifier {
  static const String _baseUrl = 'http://192.168.0.7:3000/api/vehicle';
  List<dynamic> _vehicles = [];

  List<dynamic> get vehicles => _vehicles;

  Future<void> getVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No authentication token found.');
    }
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token'
        },
      );
      if (response.statusCode == 200) {
        _vehicles = jsonDecode(response.body);
        notifyListeners();
      } else {
        throw Exception('Failed to load vehicles: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching vehicles: $error');
    }
  }

  Future<void> addVehicle(String name, String size) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No authentication token found.');
    }
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token'
        },
        body: jsonEncode({'name': name, 'size': size}),
      );
      if (response.statusCode == 200) {
        await getVehicles(); // Refresh the vehicle list
      } else {
        throw Exception('Failed to add vehicle: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error adding vehicle: $error');
    }
  }
  Future<bool> deletevehicle(id)async{
       final url=Uri.parse(_baseUrl+'/delete');
       final response=await http.delete(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"id":id})
        );
       if(response.statusCode==200)
          {
            getVehicles();
            return true;
          }
       else
          return false;
  }
}
