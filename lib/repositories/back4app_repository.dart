import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:via_cep/models/back4app_model.dart';

class Back4appRepository {
  final _headers = {
    'X-Parse-Application-Id': '1rgkAyqyUe9xJDUG8hS2Tr5rqLFRCSi9JniWlP2h',
    'X-Parse-REST-API-Key': 'nJhIpU1GbHu1do9DPX7tDC1clxqZ3Mxurxmz9cNr',
    'Content-Type': 'application/json'
  };

  final _baseUrl = 'https://parseapi.back4app.com/classes';

  Future<dynamic> addCep(dynamic body) async {
    var response = await http.post(
      Uri.parse('$_baseUrl/Enderecos'),
      body: jsonEncode(body),
      headers: _headers,
    );
    //print(response.statusCode);
    return response.body;
    //exception
  }

  Future<Back4appModel> getDbCep() async {
    var response = await http.get(
      Uri.parse('$_baseUrl/Enderecos'),
      headers: _headers,
    );
    //print(response.statusCode);
    final json = jsonDecode(response.body);
    final result = json['results'] as List;
    return Back4appModel.fromJson(json);
  }

  Future<dynamic> deleteById(String id) async {
    var response = await http.delete(
      Uri.parse('$_baseUrl/Enderecos/$id'),
    );
    return response.statusCode == 200;
  }
}
