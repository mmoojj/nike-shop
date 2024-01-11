import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/di/get_it.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';
import 'package:nike_shop/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController =
      TextEditingController(text: "test@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    const onBackground = Colors.white;
    return Theme(
      data: themedata.copyWith(
          snackBarTheme:
              SnackBarThemeData(backgroundColor: themedata.colorScheme.primary),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(56),
              ),
              backgroundColor: const MaterialStatePropertyAll(onBackground),
              foregroundColor:
                  MaterialStatePropertyAll(themedata.colorScheme.secondary),
            ),
          ),
          colorScheme: themedata.colorScheme.copyWith(onSurface: onBackground),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(color: onBackground),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
          )),
      child: Scaffold(
        backgroundColor: themedata.colorScheme.secondary,
        body: BlocProvider<AuthBloc>(
          create: (context) {
            final bloc = AuthBloc(
                repository: getIt<IAuthRepository>(), cartRepository: cartRepository);
            bloc.stream.forEach((state) {
              if (state is AuthSuccess) {
                Navigator.of(context).pop();
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.exception.message)));
              }
            });
            bloc.add(AuthStarted());
            return bloc;
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) {
              return current is AuthLoading ||
                  current is AuthError ||
                  current is AuthInitial;
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/nike_logo.png",
                    color: Colors.white,
                    width: 120,
                  ),
                  Text(
                    state.isLoginMode ? "خوش آمدید" : "ثبت نام",
                    style: const TextStyle(color: onBackground, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                      state.isLoginMode
                          ? "لطفا وارد حساب کاربری خود شوید"
                          : "ایمیل و رمز عبور خود را تعیین کنید",
                      style:
                          const TextStyle(color: onBackground, fontSize: 16)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text("آدرس ایمیل"),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _PasswordTextField(
                    onBackground: onBackground,
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(AuthButtonClicked(
                          usernameController.text, passwordController.text));
                    },
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : Text(state.isLoginMode ? "ورود" : "ثبت نام"),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.isLoginMode
                            ? "آیا هیچ حسابی ندارید ؟"
                            : "آیا حساب کاربری دارید",
                        style: const TextStyle(color: onBackground),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(AuthModeChangeClicked());
                        },
                        child: Text(
                          state.isLoginMode ? "ثبت نام" : "ورود",
                          style: TextStyle(
                              color: themedata.colorScheme.primary,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ).paddingLR(48, 48);
            },
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField(
      {super.key, required this.onBackground, required this.controller});

  final Color onBackground;
  final TextEditingController controller;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obsecureText,
      keyboardType: TextInputType.visiblePassword,
      obscuringCharacter: "*",
      decoration: InputDecoration(
          label: const Text(" رمز عبور"),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obsecureText = !obsecureText;
              });
            },
            icon: Icon(
              obsecureText ? Icons.visibility : Icons.visibility_off,
              color: widget.onBackground.withOpacity(0.6),
            ),
          )),
    );
  }
}
