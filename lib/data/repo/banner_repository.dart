import 'package:nike_shop/data/banner.dart';
import 'package:nike_shop/data/common/http_client.dart';
import 'package:nike_shop/data/source/banner_data_source.dart';

final BannerRepository bannerRepository =
    BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);

  @override
  Future<List<BannerEntity>> getAll() => dataSource.getAll();
}
