import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nike_shop/common/strings.dart';
import 'package:nike_shop/data/Auth_info.dart';
import 'package:nike_shop/data/common/http_respone_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username , String password);
  Future<AuthInfo> signUp(String username , String password);
  Future<AuthInfo> refreshToken(String token);
}


@Injectable(as: IAuthDataSource)
class AuthRemoteDataSource with HttpResponseValidator implements IAuthDataSource{
  final Dio httpClient;
  

  AuthRemoteDataSource(this.httpClient);
  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post("auth/token",data: {
      "grant_type":"password",
      "client_id":2,
      "client_secret":clientSecret,
      "username":username,
      "password":password
    });
    validateResponse(response);
    
    return AuthInfo(response.data['access_token'], response.data['refresh_token'],username);
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type":"refresh_token",
      "refresh_token":token,
      "client_id":2,
      "client_secret":clientSecret
    });
    validateResponse(response);
    return AuthInfo(response.data['access_token'], response.data['refresh_token'],'');
  }

  @override
  Future<AuthInfo> signUp(String username, String password) async {
    final response = await httpClient.post('user/register',data: {
        "email":username,
        "password":password
    });
    validateResponse(response);
    return login(username, password);
  }

}