import 'package:dio/dio.dart';
import 'package:nike_shop/common/exception.dart';

mixin HttpResponseValidator {
  
  validateResponse(Response response){
    if (response.statusCode != 200){
      if (response.statusCode == 401){
        throw AppException(message: "لطفا وارد حساب کاربری خود شوید");
      }
      throw AppException();
    }
  }
}
