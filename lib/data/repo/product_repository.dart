import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/source/product_data_source.dart';

final ProductRepository productRepository =
    ProductRepository(ProductRemoteDataSource(httpClient));

abstract class IProductRepository {
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> search(String searchterm);
}

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository(this.dataSource);

  @override
  Future<List<ProductEntity>> getAll(int sort) => dataSource.getAll(sort);

  @override
  Future<List<ProductEntity>> search(String searchterm) =>
      dataSource.search(searchterm);
}
