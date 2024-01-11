import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nike_shop/data/Auth_info.dart';
import 'package:nike_shop/data/source/authDataSource.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
  Future<void> Sigout();
  Future<void>  loadAuthInfo();
}

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> valueNotifier = ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);
  @override
  Future<void> login(String username, String password) async {
    final authInfo = await dataSource.login(username, password);
    _PersistAuthToken(authInfo);
  }

  @override
  Future<void> signUp(String username, String password) async {
    final authInfo = await dataSource.signUp(username, password);
    _PersistAuthToken(authInfo);
  }

  @override
  Future<void> refreshToken() async {
    if (valueNotifier.value != null) {
      final authInfo =
          await dataSource.refreshToken(valueNotifier.value!.accessToken);
      _PersistAuthToken(authInfo);
    }
  }

  Future<void> _PersistAuthToken(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
    sharedPreferences.setString("email", authInfo.email);
    loadAuthInfo();
  }

  @override
  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';
    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      valueNotifier.value = AuthInfo(
          accessToken, refreshToken, sharedPreferences.getString("email"));
    }
  }

  @override
  Future<void> Sigout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();

    valueNotifier.value = null;
  }
}
