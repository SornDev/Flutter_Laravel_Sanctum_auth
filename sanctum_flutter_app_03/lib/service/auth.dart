import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sanctum_flutter_app_03/model/user.dart';
import 'package:sanctum_flutter_app_03/service/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  late User _user;
  late String _token;

  bool get authenticated => _isLoggedIn;
  User get user => _user;

  // get storage => null;

  final storage = new FlutterSecureStorage();

  void login(Map creds) async {
    //  print(creds);

    try {
      var respons = await dio().post('/sanctum/token', data: creds);
      print(respons.data.toString());
      String token = respons.data.toString();
      tyToken(token: token);
      //_isLoggedIn = true;
      //notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void tyToken({required String token}) async {
    //print(token);
    if (token == null) {
      return;
    } else {
      try {
        var response = await dio().get('/user',
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        //print(response.toString());
        this._isLoggedIn = true;
        this._user = User.fromJson(response.data);
        this._token = token;
        print(response.data.toString());

        this.storeToken(token: token);

        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken({required String token}) async {
    await storage.write(key: 'token', value: token);

    // String? value = await storage.read(key: 'token');
    // print(value);
  }

  void logout() async {
    try {
      await dio().get('/user/revoke',
          options: Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }

    //
  }

  void cleanUp() async {
    String? _user = null;
    this._isLoggedIn = false;
    String? _token = null;
    await storage.delete(key: 'token');
  }
}
