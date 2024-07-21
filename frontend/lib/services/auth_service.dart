import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static const String _baseUrl = 'http://192.168.0.7:3000/api/auth';
  String? _token;
  String name='Rishant';
  String email='';
  String wallet='';
  String? get token => _token;

  Future<void> signUp(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _token!);
        notifyListeners();
      } else {
        // Handle error based on status code
        throw Exception('Failed to sign up: ${response.body}');
      }
    } catch (error) {
      throw error; // Propagate error for further handling
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _token!);
        notifyListeners();
        return true;
      } else {
        // Handle error based on status code
        return false;
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (error) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    notifyListeners();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<bool> getdetail()async{

    var url=Uri.parse('$_baseUrl'+'/getdetails');
    final prefs = await SharedPreferences.getInstance();
    final token=prefs.getString('token');
    final response=await http.get(url,
         headers:{
           'Content-Type': 'application/json',
           'Authorization': '$token'
         }
    );

    if(response.statusCode==200)
        {
           final data=json.decode(response.body);
           name=data["name"];
           email=data['email'];
           wallet=data['wallet'].toString();
           notifyListeners();
           return true;
        }
    return false;

  }
}
