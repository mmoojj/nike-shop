import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/favorite_manager.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/themes.dart';
import 'package:nike_shop/ui/product/detail.dart';
import 'package:nike_shop/ui/widget/image.dart';

class FavoriteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("لیست علاقه مندی ها"),
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
          valueListenable: favoriteManager.valueListenable,
          builder: (context, box, child) {
            final products = box.values.toList();
            return ListView.builder(
                itemCount: products.length,
                padding: EdgeInsets.fromLTRB(0, 8, 0, 100),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product)));
                    },
                    onLongPress: () {
                      favoriteManager.delete(product);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                      child: Row(
                        children: [
                          Hero(
                            tag: "image-${product.id}",
                            child: SizedBox(
                              width: 110,
                              height: 110,
                              child: ImageLoadingService(
                                imageurl: product.imageurl,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .apply(
                                            color: LightThemeColor
                                                .primaryTextColor),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    product.previousPrice.withPriceLabale,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .apply(
                                            decoration:
                                                TextDecoration.lineThrough),
                                  ),
                                  Text(product.price.withPriceLabale),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
