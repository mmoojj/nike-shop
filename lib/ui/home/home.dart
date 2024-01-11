import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/common/strings.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/banner_repository.dart';
import 'package:nike_shop/data/repo/product_repository.dart';
import 'package:nike_shop/ui/home/bloc/home_bloc.dart';
import 'package:nike_shop/ui/list/list.dart';
import 'package:nike_shop/ui/product/product.dart';
import 'package:nike_shop/ui/widget/error.dart';
import 'package:nike_shop/ui/widget/slider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final int HomeItemCount = 5;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) {
        final homebloc = HomeBloc(
            bannerRepository: bannerRepository,
            productRepository: productRepository);
        homebloc.add(HomeStarted());
        return homebloc;
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSucess) {
                return ListView.builder(
                    itemCount: HomeItemCount,
                    physics: defualtScrollPhysics,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Column(
                            children: [
                              Container(
                                height: 56,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/img/nike_logo.png",
                                  height: 24,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Container(
                                height: 56,
                                margin:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                child: TextField(
                                  onSubmitted: (value) => _search(context),
                                  controller: searchController,
                                  textInputAction: TextInputAction.search,
                                  autocorrect: false,
                                  style: context.themedata.bodyMedium!
                                      .apply(decoration: TextDecoration.none),
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(28)),
                                      prefixIcon: IconButton(
                                          onPressed: () => _search(context),
                                          icon: const Icon(Icons.search)),
                                      label: const Text("جستوجو ...")),
                                ),
                              )
                            ],
                          );
                        case 2:
                          return BannerSlider(
                            banners: state.banners,
                          );
                        case 3:
                          return _HorzintalProductList(
                            title: latestProductTextTitle,
                            ontap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ProductListScreen(
                                      sort: ProductSort.latest),
                                ),
                              );
                            },
                            products: state.latestProducts,
                          );
                        case 4:
                          return _HorzintalProductList(
                              title: popularProductTextTitle,
                              ontap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductListScreen(
                                            sort: ProductSort.popular),
                                  ),
                                );
                              },
                              products: state.popularProducts);
                        default:
                          return Container();
                      }
                    });
              } else if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeError) {
                return AppErrorWidget(
                  exception: state.exception,
                  ontap: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
                );
              } else {
                throw Exception("this state not suported");
              }
            },
          ),
        ),
      ),
    );
  }

  void _search(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            ProductListScreen.search(search: searchController.text)));
  }
}

class _HorzintalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback ontap;
  final List<ProductEntity> products;
  const _HorzintalProductList(
      {super.key,
      required this.title,
      required this.ontap,
      required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.themedata.titleMedium,
            ),
            TextButton(
                onPressed: ontap, child: const Text(latestProductTextBtn)),
          ],
        ).paddingLR(12, 12),
        SizedBox(
          height: 290,
          child: ListView.builder(
              itemCount: products.length,
              physics: defualtScrollPhysics,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  borderRadius: BorderRadius.circular(12),
                );
              }).paddingLR(8, 8),
        )
      ],
    );
  }
}
