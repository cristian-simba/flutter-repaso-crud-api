import 'package:flutter/material.dart';
import 'package:crud_api/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier{

  final String url = "https://67180fecb910c6a6e02afe14.mockapi.io/users";
  late Uri api = Uri.parse(url);

  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async{
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _users = data.map((user)=> User.fromJson(user)).toList();
      notifyListeners();
    }else{
      throw Exception("Error al cargar usuarios");
    }
  }

  Future<void> addUser(User user) async {
    final response = await http.post(
      Uri.parse('https://67180fecb910c6a6e02afe14.mockapi.io/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      final newUser = User.fromJson(json.decode(response.body));
      _users.add(newUser);
      notifyListeners();
    } else {
      throw Exception('Failed to add user');
    }
  }
  
  Future<void> updateUser(String id, User updateUser) async {
    final response = await http.put(
      Uri.parse('https://67180fecb910c6a6e02afe14.mockapi.io/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updateUser.toJson()),
    );

    if (response.statusCode == 200) {
      int index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = User.fromJson(json.decode(response.body));
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('https://67180fecb910c6a6e02afe14.mockapi.io/users/$id'),
    );

    if (response.statusCode == 200) {
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete user');
    }
  }

}

  // void addUser(User user){
  //   _users.add(user);
  //   notifyListeners();
  // }

  // void updateUser(String id, User updateUser){
  //   int index = _users.indexWhere((user)=>user.id == id);
  //   if(index != -1){
  //     _users[index] = updateUser;
  //     notifyListeners();
  //   }
  // }

  // void deleteUser(String id){
  //   _users.removeWhere((user)=> user.id == id);
  //   notifyListeners();
  // }

