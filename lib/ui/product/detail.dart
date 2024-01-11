import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/product/bloc/product_bloc.dart';
import 'package:nike_shop/ui/product/comment/comment_list.dart';
import 'package:nike_shop/ui/product/comment/insert/insert_comment_dialog.dart';
import 'package:nike_shop/ui/widget/image.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductEntity product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? streamSubscription;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();

  @override
  void dispose() {
    streamSubscription?.cancel();
    scaffoldMessenger.currentState?.dispose();
    super.dispose();
  }

  void _showSnackBar(String text) {
    scaffoldMessenger.currentState!.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          streamSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartError) {
              _showSnackBar(state.exception.message);
            } else if (state is ProductAddToCartSuccess) {
              _showSnackBar("با موفقیت به سبد خرید اضافه شد");
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: scaffoldMessenger,
          child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) => FloatingActionButton.extended(
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context)
                            .add(CartAddButtonClicked(widget.product.id));
                      },
                      label: state is ProductAddToCartButtonLoading
                          ? CupertinoActivityIndicator(
                              color: Theme.of(context).colorScheme.onSecondary,
                            )
                          : const Text("افزودن به سبد خرید")),
                ),
              ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    foregroundColor: Colors.black,
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.heart))
                    ],
                    expandedHeight: MediaQuery.of(context).size.width * 0.8,
                    flexibleSpace: Hero(
                      tag: "image-${widget.product.id}",
                      child: ImageLoadingService(
                          imageurl: widget.product.imageurl),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                widget.product.title,
                                style: context.themedata.titleLarge,
                              )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget
                                        .product.previousPrice.withPriceLabale,
                                    style: context.themedata.bodySmall!.apply(
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  Text(widget.product.price.withPriceLabale)
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "نظرات کاربران",
                                style: context.themedata.titleMedium,
                              ),
                              TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(12))),
                                        useRootNavigator: true,
                                        builder: (context) => Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: InserCommentDialog(
                                                productId: widget.product.id,
                                                scaffoldMessenger:
                                                    scaffoldMessenger
                                                        .currentState,
                                              ),
                                            ));
                                  },
                                  child: const Text("ثبت نظر"))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  CommentList(productId: widget.product.id)
                ],
              )),
        ),
      ),
    );
  }
}
