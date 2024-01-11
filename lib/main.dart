import 'package:flutter/material.dart';
import 'package:nike_shop/data/di/get_it.dart';
import 'package:nike_shop/data/favorite_manager.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/themes.dart';
import 'package:nike_shop/ui/root.dart';

void main() async {
  configureDependencies(); 
   await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  
  getIt<IAuthRepository>().loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defualtTextStyle = TextStyle(
        fontFamily: "IranYekan", color: LightThemeColor.primaryTextColor);
    return MaterialApp( 
      title: 'Flutter Demo',
      theme: ThemeData(
        hintColor: LightThemeColor.secondaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: LightThemeColor.secondaryTextColor.withOpacity(0.5))
          ),
          border: OutlineInputBorder(

          )
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: LightThemeColor.primaryTextColor
        ),
        textTheme: TextTheme(
            labelLarge: defualtTextStyle, // button text style
            titleMedium: defualtTextStyle.apply(
                color: LightThemeColor.secondaryTextColor),
            bodyMedium: defualtTextStyle, // textBody2
            bodySmall: defualtTextStyle.apply(
                color: LightThemeColor.secondaryTextColor),
            titleLarge: defualtTextStyle.copyWith(
                fontWeight: FontWeight.w700, fontSize: 18)),
        colorScheme: const ColorScheme.light(
            primary: LightThemeColor.primaryColor,
            secondary: LightThemeColor.secondaryColor,
            onSecondary: Colors.white,
            surface: LightThemeColor.primaryColor,
            inversePrimary: LightThemeColor.primaryColor),
        useMaterial3: false,
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
