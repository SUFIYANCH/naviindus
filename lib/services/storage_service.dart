import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class StorageClass {
  final prefs = SharedPreferences.getInstance();

  void setToken(String token) async {
    await (await prefs).setString('token', token).then((value) {
      log("Stored:$value");
    });
  }

  Future<String?> getToken() async {
    return (await prefs).getString('token');
  }

  Future<bool?> removeToken() async {
    return (await prefs).remove('token');
  }
}
