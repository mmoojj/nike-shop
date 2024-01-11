import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nike_shop/data/Auth_info.dart';
import 'package:nike_shop/data/di/get_it.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/auth/auth.dart';
import 'package:nike_shop/ui/auth/bloc/auth_bloc.dart';
import 'package:nike_shop/ui/favorites/favorite.dart';
import 'package:nike_shop/ui/order/order_history.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("پروفایل"),
        ),
        body: ValueListenableBuilder<AuthInfo?>(
            valueListenable: AuthRepository.valueNotifier,
            builder: (context, authinfo, child) {
              final isUserLogin =
                  authinfo != null && authinfo.accessToken.isNotEmpty;
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 32, bottom: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).dividerColor, width: 1),
                      ),
                      child: Image.asset("assets/img/nike_logo.png"),
                    ),
                    Text(isUserLogin ? authinfo.email : "کاربر میهمان"),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FavoriteListScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 56,
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.heart),
                            SizedBox(
                              width: 16,
                            ),
                            Text("لیست علاقه مندی ها"),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const OrderHistoryScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 56,
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.cart),
                            SizedBox(
                              width: 16,
                            ),
                            Text("   سوابق سفارش"),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        if (isUserLogin) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text("خروج از حساب کاربری"),
                                    content: const Text(
                                        "آیا میخواهید از حساب خود خارج شوید"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("خیر")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            CartRepository.countNotifier.value =
                                                0;
                                            getIt<IAuthRepository>().Sigout();
                                          },
                                          child: Text("بله")),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 56,
                        child: Row(
                          children: [
                            Icon(isUserLogin
                                ? Icons.exit_to_app
                                : CupertinoIcons.arrow_left_square),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(isUserLogin
                                ? "خروج از حساب کاربری"
                                : "  ورود به حساب کاربری"),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
