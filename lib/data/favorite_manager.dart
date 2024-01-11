import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_shop/data/product.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = "favorite";
  final _box = Hive.box<ProductEntity>(_boxName);

  ValueListenable<Box<ProductEntity>> get valueListenable =>
      Hive.box<ProductEntity>(_boxName).listenable();

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    await Hive.openBox<ProductEntity>(_boxName);
  }

  void addToFavorite(ProductEntity product) async {
    await _box.put(product.id, product);
  }

  void delete(ProductEntity product) async {
    await _box.delete(product.id);
  }

  List<ProductEntity> get favoriteList => _box.values.toList();

  bool isFavorite(ProductEntity product) {
    return _box.containsKey(product.id);
  }
}
