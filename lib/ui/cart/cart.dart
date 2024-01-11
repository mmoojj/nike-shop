import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/cart_item.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/auth/auth.dart';
import 'package:nike_shop/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_shop/ui/cart/price_info.dart';
import 'package:nike_shop/ui/shipping/shipping.dart';
import 'package:nike_shop/ui/widget/empty_state.dart';
import 'package:nike_shop/ui/widget/image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  StreamSubscription<CartState>? streamSubscription;
  bool floatActionBtnVisibilite = false;

  @override
  void initState() {
    super.initState();
    AuthRepository.valueNotifier.addListener(NotifierChangeListener);
  }

  void NotifierChangeListener() {
    cartBloc?.add(CartAuthInfoChange(AuthRepository.valueNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.valueNotifier.removeListener(NotifierChangeListener);
    cartBloc?.close();
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: floatActionBtnVisibilite,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(right: 32, left: 32),
          child: FloatingActionButton.extended(
              onPressed: () {
                final state = cartBloc!.state;
                if (state is CartSuccess) {
                  context.nav(ShippingScreen(
                    payablePrice: state.cartResponse.payablePrice,
                    totalPrice: state.cartResponse.totalPrice,
                    shippingCost: state.cartResponse.shippingCost,
                  ));
                }
              },
              label: const Text("پرداخت")),
        ),
      ),
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("سبد خرید"),
      ),
      body: BlocProvider<CartBloc>(
        create: (context) {
          final bloc = CartBloc(cartRepository);
          streamSubscription = bloc.stream.listen((state) {
            setState(() {
              floatActionBtnVisibilite = state is CartSuccess;
            });
            if (_refreshController.isRefresh) {
              if (state is CartSuccess) {
                _refreshController.refreshCompleted();
              } else if (state is CartError || state is CartEmpty) {
                _refreshController.refreshFailed();
              }
            }
          });
          cartBloc = bloc;
          bloc.add(CartStarted(AuthRepository.valueNotifier.value));
          return bloc;
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is CartSuccess) {
              return Refresher(
                controller: _refreshController,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: state.cartResponse.items.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.cartResponse.items.length) {
                      final data = state.cartResponse.items[index];
                      return CartListItem(data: data);
                    } else {
                      return PriceInfo(
                        payablePrice: state.cartResponse.payablePrice,
                        shippingCost: state.cartResponse.shippingCost,
                        totalPrice: state.cartResponse.totalPrice,
                      );
                    }
                  },
                ),
              );
            } else if (state is CartAuthRequared) {
              return EmptyView(
                message: "برای مشاهده سبد خرید ابتدا وارد حساب خود شوید",
                callToAction: ElevatedButton(
                    onPressed: () {
                      context.nav(const AuthScreen(), navroot: true);
                    },
                    child: const Text('ورود به حساب کاربری')),
                image: SvgPicture.asset("assets/img/auth_required.svg",
                    width: 140),
              );
            } else if (state is CartEmpty) {
              return Refresher(
                controller: _refreshController,
                faileText: "هنوز هیچ محصولی اضافه نشده است",
                child: EmptyView(
                  message: "تا کنون هیچ محصولی به سبد خرید اضافه نکردید",
                  image: SvgPicture.asset(
                    "assets/img/empty_cart.svg",
                    width: 200,
                  ),
                ),
              );
            } else {
              throw Exception("state is not valid");
            }
          },
        ),
      ),
    );
  }
}

class Refresher extends StatelessWidget {
  final Widget child;
  final RefreshController controller;
  final String faileText;

  const Refresher(
      {super.key,
      required this.child,
      required this.controller,
      this.faileText = "خطا ی رخ داده است"});
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        header: ClassicHeader(
          refreshStyle: RefreshStyle.UnFollow,
          refreshingText: "در حال بروزرسانی",
          completeText: "با موفقیت انجام شد",
          idleText: "برای بروزرسانی پایین بکشید",
          releaseText: "رها کنید",
          failedText: faileText,
        ),
        onRefresh: () {
          BlocProvider.of<CartBloc>(context).add(CartStarted(
              AuthRepository.valueNotifier.value,
              isRefreshing: true));
        },
        controller: controller,
        child: child);
  }
}

class CartListItem extends StatelessWidget {
  const CartListItem({
    super.key,
    required this.data,
  });

  final CartItemEntity data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.2))
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageLoadingService(
                    imageurl: data.product.imageurl,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(data.product.title,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('تعداد'),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            BlocProvider.of<CartBloc>(context)
                                .add(CartPlusBtnClicked(data.id));
                          },
                          icon: const Icon(CupertinoIcons.plus_rectangle)),
                      data.changeCountBtnLoading
                          ? CupertinoActivityIndicator()
                          : Text(
                              data.count.toString(),
                              style: context.themedata.headlineSmall,
                            ),
                      IconButton(
                          onPressed: () {
                            if (data.count > 1)
                              BlocProvider.of<CartBloc>(context)
                                  .add(CartMinusBtnClicked(data.id));
                          },
                          icon: const Icon(CupertinoIcons.minus_rectangle))
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.product.previousPrice.withPriceLabale,
                    style:
                        const TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                  Text(data.product.price.withPriceLabale)
                ],
              )
            ],
          ).paddingLR(8, 8),
          const Divider(
            height: 1,
          ),
          data.deleteButtonLoading
              ? const Center(child: CupertinoActivityIndicator())
              : TextButton(
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context)
                        .add(CartDeletButtonClicked(data.id));
                  },
                  child: const Text("حذف از سبد خرید"))
        ],
      ),
    );
  }
}
