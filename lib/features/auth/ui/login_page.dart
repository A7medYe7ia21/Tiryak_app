import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../../core/helpers/extensions.dart';

import '../../../core/helpers/app_regex.dart';
import '../data/model/login_request_body.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';
import 'forgot_password_page.dart';
import 'widgets/app_header.dart';
import 'widgets/my_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.onTap});
  final void Function()? onTap;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void login(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    final String email = authCubit.emailController.text;
    final String password = authCubit.passwordController.text;

    final LoginRequestBody requestBody = LoginRequestBody(
      email: email,
      password: password,
    );

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(requestBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Clear registration-specific fields when entering login page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().nameController.clear();
      context.read<AuthCubit>().phoneNumberController.clear();
      context.read<AuthCubit>().confirmPasswordController.clear();
    });

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 15,
                        children: [
                          AppHeader(
                            icon: Ionicons.medical,
                            title: 'welcome_back'.tr(),
                            subtitle: 'sign_in_to_continue'.tr(),
                          ),
                          MyTextField(
                            controller:
                                context.read<AuthCubit>().emailController,
                            hintText: "email".tr(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please_enter_email".tr();
                              }
                              if (!AppRegex.isEmailValid(value)) {
                                return 'please_enter_valid_name'.tr();
                              }
                              return null;
                            },
                          ),
                          MyTextField(
                            controller:
                                context.read<AuthCubit>().passwordController,
                            hintText: "password".tr(),
                            obscureText: context
                                .watch<AuthCubit>()
                                .loginPasswordObsecure,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please_enter_password".tr();
                              }
                              return null;
                            },
                            suffixIcon: GestureDetector(
                              onTap: () {
                                BlocProvider.of<AuthCubit>(context)
                                    .toggleLoginPasswordObsecure();
                              },
                              child: Icon(
                                context.watch<AuthCubit>().loginPasswordObsecure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      context.push(ForgotPasswordPage()),
                                  child: Text(
                                    "forgot_password".tr(),
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                login(context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "login".tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "or_continue_with".tr(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await context
                                    .read<AuthCubit>()
                                    .signInWithGoogle();
                              },
                              icon: Image.asset(
                                'assets/images/google.png',
                                width: 20,
                                height: 20,
                              ),
                              label: Text(
                                'continue_with_google'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Text(
                                "dont_have_account".tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              GestureDetector(
                                onTap: onTap,
                                child: Text(
                                  "register_now".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ), 
      ),
    ); // Closing BlocListener
  }
}
