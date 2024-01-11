import 'package:dio/dio.dart';
import 'package:nike_shop/data/banner.dart';
import 'package:nike_shop/data/common/http_respone_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource with HttpResponseValidator implements IBannerDataSource{
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);
  @override
  Future<List<BannerEntity>> getAll() async {
      final response = await httpClient.get("banner/slider");
      validateResponse(response);
      final banners = <BannerEntity>[];
      (response.data as List).forEach((element) {
          banners.add(BannerEntity.fromjson(element));
      });
      return banners;
  }

}