import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/views/widgets/custom_elevated_button.dart';
import 'package:e_commerce/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/app_colors.dart';
import '../../view_models/auth_cubit/auth_cubit.dart';
import '../widgets/custom_social_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login Account",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    "Please login with registered account.",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 40.0),
                  CustomTextField(
                    controller: _emailController,
                    label: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  CustomTextField(
                    controller: _passController,
                    label: "Password",
                    hintText: "Enter your password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscureText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ////i will handle it with cubit ,do not frogot bisheeer
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.grey,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: loginCubit,
                    listenWhen: (previous, current) =>
                        current is AuthDone || current is AuthError,
                    listener: (context, state) {
                      if (state is AuthDone) {
                        Navigator.of(context).pushNamed(AppRoutes.homeRoute);
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AuthDone ||
                        current is AuthError ||
                        current is AuthLoading,
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CustomElevatedButton(isLoading: true);
                      } else {
                        return CustomElevatedButton(
                          text: "Sign in",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await loginCubit.loginWithYourInfo(
                                _emailController.text,
                                _passController.text,
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32.0),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "Or using other method",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.grey),
                        ),
                        const SizedBox(height: 24.0),
                        CustomSocialWidget(
                          title: 'Sign in with Facebook',
                          socialImage:
                              'https://www.freepnglogos.com/uploads/facebook-logo-design-1.png',
                          onTap: () {},
                        ),
                        const SizedBox(height: 16.0),
                        BlocConsumer<AuthCubit, AuthState>(
                          bloc: loginCubit,
                          listenWhen: (previous, current) =>
                              current is GoogleAuthDone ||
                              current is GoogleAuthError,
                          listener: (context, state) {
                            if (state is GoogleAuthDone) {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.homeRoute);
                            } else if (state is GoogleAuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          buildWhen: (previous, current) =>
                              current is GoogleAuthDone ||
                              current is GoogleAuthError ||
                              current is GoogleAuthLoading,
                          builder: (context, state) {
                            if (state is GoogleAuthLoading) {
                              return CustomSocialWidget(isLoading: true);
                            }
                            return CustomSocialWidget(
                              title: 'Sign in with Google',
                              socialImage:
                                  'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png',
                              onTap: () async =>
                                  await loginCubit.authenticateWithGoogle(),
                            );
                          },
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.registerRoute);
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
