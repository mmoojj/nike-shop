import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/favorite_manager.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/ui/product/detail.dart';
import 'package:nike_shop/ui/widget/image.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.borderRadius,
  });

  final ProductEntity product;
  final BorderRadius borderRadius;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    product: widget.product,
                  ))),
          child: SizedBox(
            width: 176,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.98,
                      child: ImageLoadingService(
                        imageurl: widget.product.imageurl,
                        borderRadius: widget.borderRadius,
                      ),
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            if (!favoriteManager.isFavorite(widget.product)) {
                              favoriteManager.addToFavorite(widget.product);
                            } else {
                              favoriteManager.delete(widget.product);
                            }
                            setState(() {});
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ValueListenableBuilder<Box<ProductEntity>>(
                              valueListenable: favoriteManager.valueListenable,
                              builder: (context , box ,child) {
                                return Icon(
                                  favoriteManager.isFavorite(widget.product)
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  size: 20,
                                );
                              }
                            ),
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: Text(
                    widget.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ).paddingLR(8, 8),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.product.previousPrice.withPriceLabale,
                        style: context.themedata.bodySmall!
                            .apply(decoration: TextDecoration.lineThrough))
                    .paddingLR(8, 8),
                Text(widget.product.price.withPriceLabale).paddingLR(8, 8),
              ],
            ),
          ),
        ));
  }
}
