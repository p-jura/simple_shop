import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

const _apiKey = 'Your Api Key';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId ?? '';
  }

  Future<void> _signUpOrLogIn(
      String email, String password, String urlDiffer) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlDiffer?key=$_apiKey');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responseBodyDecoded = json.decode(response.body);

      if (responseBodyDecoded['error'] != null) {
        throw HttpException(responseBodyDecoded['error']['message'].toString());
      }
      _token = responseBodyDecoded['idToken'];
      _userId = responseBodyDecoded['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBodyDecoded['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate?.toIso8601String()
        },
      );
      preferences.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogIn() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(preferences.getString('userData')!) as Map;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _signUpOrLogIn(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _signUpOrLogIn(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire = _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;
    _authTimer = Timer(
      Duration(seconds: timeToExpire),
      () {
        logOut();
      },
    );
  }
}
