import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/cart/cart.dart';
import 'package:nike_shop/ui/home/home.dart';
import 'package:nike_shop/ui/profile/profile.dart';
import 'package:nike_shop/ui/widget/badge.dart';

const homeindex = 0;
const cartindex = 1;
const profileindex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final GlobalKey<NavigatorState> _homenavigatorstate = GlobalKey();
  final GlobalKey<NavigatorState> _cartnavigatorstate = GlobalKey();
  final GlobalKey<NavigatorState> _profilenavigatorstate = GlobalKey();
  final List<int> _history = [];

  late final map = {
    homeindex: _homenavigatorstate,
    cartindex: _cartnavigatorstate,
    profileindex: _profilenavigatorstate,
  };

  int currentindex = homeindex;

  void popscope(bool didpop) {
    final NavigatorState currentNavState = map[currentindex]!.currentState!;
    if (currentNavState.canPop()) {
      currentNavState.pop();
      return;
    } else if (_history.isNotEmpty) {
      setState(() {
        currentindex = _history.last;
        _history.removeLast();
      });
      return;
    }
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: popscope,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentindex,
            onTap: (selectedindex) {
              setState(() {
                _history.remove(currentindex);
                _history.add(currentindex);
                currentindex = selectedindex;
              });
            },
            items: [
              const BottomNavigationBarItem(
                label: "خانه",
                icon: Icon(CupertinoIcons.home),
              ),
              BottomNavigationBarItem(
                label: "سبد خرید",
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(CupertinoIcons.cart),
                    Positioned(
                      top: 0,
                      right: -10,
                      child: ValueListenableBuilder<int>(
                        valueListenable: CartRepository.countNotifier,
                        builder: (context, value, child) {
                          return BadgeCart(value: value);
                        },
                      ),
                    )
                  ],
                ),
              ),
              const BottomNavigationBarItem(
                label: "پروفایل",
                icon: Icon(CupertinoIcons.person_fill),
              ),
            ],
          ),
          body: IndexedStack(
            index: currentindex,
            children: [
              _navigator(_homenavigatorstate, homeindex,  HomeScreen()),
              _navigator(_cartnavigatorstate, cartindex, const CartScreen()),
              _navigator(
                _profilenavigatorstate,
                profileindex,
                ProfileScreen(),
              )
            ],
          ),
        ));
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && currentindex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) =>
                    Offstage(offstage: currentindex != index, child: child)),
          );
  }
}
