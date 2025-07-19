// lib/user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class Userdetails {
  final int id;
  final String name;
  final String username;
  final String email;
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final String latitude;
  final String longitude;

  Userdetails({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
  });

  factory Userdetails.fromJSON(Map<String, dynamic> json) {
    return Userdetails(
      id: json['id'],
      name: json['name'] ?? 'No name',
      username: json['username'] ?? 'No username',
      email: json['email'] ?? 'No email',
      street: json['address']['street'] ?? 'No street',
      suite: json['address']['suite'] ?? 'No suite',
      city: json['address']['city'] ?? 'No city',
      zipcode: json['address']['zipcode'] ?? 'No zipcode',
      latitude: json['address']['geo']['lat'] ?? 'No latitude',
      longitude: json['address']['geo']['lng'] ?? 'No longitude',
    );
  }
}

class UserService {
  static Future<List<Userdetails>> fetchUserDetails() async {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/users");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Userdetails.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to load user data");
    }
  }
}
