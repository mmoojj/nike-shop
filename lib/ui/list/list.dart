import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/product.dart';
import 'package:nike_shop/data/repo/product_repository.dart';
import 'package:nike_shop/ui/list/bloc/product_list_bloc.dart';
import 'package:nike_shop/ui/product/product.dart';
import 'package:nike_shop/ui/widget/empty_state.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;
  final String search;

  const ProductListScreen({super.key, required this.sort}) : search = "";

  const ProductListScreen.search({super.key, required this.search})
      : sort = ProductSort.popular;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ListDisplay { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ListDisplay currentListView = ListDisplay.grid;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(" کفش های ورزشی" + " : ${widget.search}" ),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(widget.sort, widget.search));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.product;
              return Column(
                children: [
                  if (widget.search.isEmpty)
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).dividerColor)),
                          color: Theme.of(context).colorScheme.onSecondary,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.2))
                          ]),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            builder: (context) {
                              return Container(
                                height: 300,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32))),
                                child: Column(
                                  children: [
                                    Text(
                                      "انتخاب مرتب سازی",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: state.sortName.length,
                                        itemBuilder: (context, index) {
                                          final selectedIndexItem = state.sort;

                                          return InkWell(
                                            onTap: () {
                                              bloc!.add(ProductListStarted(
                                                  index, widget.search));
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 8, 16, 8),
                                              child: Row(
                                                children: [
                                                  Text(state.sortName[index]),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  if (selectedIndexItem ==
                                                      index)
                                                    Icon(
                                                      CupertinoIcons
                                                          .check_mark_circled_solid,
                                                      size: 20,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ).paddingTB(24, 24),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(CupertinoIcons.sort_down),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("مرتب سازی"),
                                      Text(
                                        state.sortName[state.sort],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    currentListView =
                                        currentListView == ListDisplay.grid
                                            ? ListDisplay.list
                                            : ListDisplay.grid;
                                  });
                                },
                                icon:
                                    const Icon(CupertinoIcons.square_grid_2x2))
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              currentListView == ListDisplay.grid ? 2 : 1,
                          childAspectRatio: 0.65),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                            product: product, borderRadius: BorderRadius.zero);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is ProductListEmptyState) {
              return Center(
                child: EmptyView(
                    message: state.message,
                    image: SizedBox(
                      height: 200,
                      child: SvgPicture.asset("assets/img/no_data.svg"))),
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
