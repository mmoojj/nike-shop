import 'package:dio/dio.dart';

import 'package:nike_shop/data/common/http_respone_validator.dart';
import 'package:nike_shop/data/product.dart';

abstract class IProductDataSource{
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>>  search(String searchterm);
}

class ProductRemoteDataSource with HttpResponseValidator implements IProductDataSource{
  final Dio httpClient;
  ProductRemoteDataSource(this.httpClient);
  @override
  Future<List<ProductEntity>> getAll(int sort)async {
    final response = await httpClient.get("product/list?sort=$sort");
    validateResponse(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
        products.add(ProductEntity.fromjsno(element));
    });
    return products;
  }

  @override
  Future<List<ProductEntity>> search(String searchterm) async {
   final response = await httpClient.get("product/search?q=$searchterm");
    validateResponse(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
        products.add(ProductEntity.fromjsno(element));
    });
    return products;
  }

}