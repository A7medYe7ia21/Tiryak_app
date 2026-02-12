import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../data/model/sign_up_request_body.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';
import 'widgets/app_header.dart';
import 'widgets/my_textfield.dart';
import 'widgets/password_validations.dart';

class RegisterStepTwoPage extends StatelessWidget {
  RegisterStepTwoPage({super.key, required this.onTap});
  final void Function()? onTap;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool allPasswordRulesPassed(AuthState state) {
    return state is PasswordValidationsState &&
        state.hasLowercase &&
        state.hasUppercase &&
        state.hasSpecialCharacters &&
        state.hasNumber &&
        state.hasMinLength;
  }

  void register(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();
    final String name = context.read<AuthCubit>().nameController.text;
    final String email = context.read<AuthCubit>().emailController.text;
    final String phoneNumber =
        context.read<AuthCubit>().phoneNumberController.text;
    final String password = context.read<AuthCubit>().passwordController.text;
    final String confirmPassword =
        context.read<AuthCubit>().confirmPasswordController.text;

    final SignupRequestBody requestBody = SignupRequestBody(
      username: name,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        await authCubit.register(requestBody);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canRegister = allPasswordRulesPassed(context.read<AuthCubit>().state);
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
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Clear password fields when going back
                context.read<AuthCubit>().passwordController.clear();
                context.read<AuthCubit>().confirmPasswordController.clear();
                Navigator.pop(context);
              },
            ),
            title: Text('create_account'.tr()),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              reverse: true,
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
                          icon: Ionicons.lock_closed,
                          title: 'set_password'.tr(),
                          subtitle: 'create_secure_password'.tr(),
                        ),
                        MyTextField(
                          controller:
                              context.read<AuthCubit>().passwordController,
                          hintText: "password".tr(),
                          obscureText:
                              context.watch<AuthCubit>().loginPasswordObsecure,
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
                        MyTextField(
                          controller: context
                              .read<AuthCubit>()
                              .confirmPasswordController,
                          hintText: "confirm_password".tr(),
                          obscureText: context
                              .watch<AuthCubit>()
                              .registerPasswordConfirmationObsecure,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please_confirm_password".tr();
                            }
                            if (value !=
                                context
                                    .read<AuthCubit>()
                                    .passwordController
                                    .text) {
                              return "passwords_do_not_match".tr();
                            }
                            return null;
                          },
                          suffixIcon: GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthCubit>(context)
                                  .toggleRegisterPasswordConfirmationObsecure();
                            },
                            child: Icon(
                              context
                                      .watch<AuthCubit>()
                                      .registerPasswordConfirmationObsecure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        PasswordValidations(
                          hasLowerCase: context.watch<AuthCubit>().hasLowercase,
                          hasUpperCase: context.watch<AuthCubit>().hasUppercase,
                          hasSpecialCharacters:
                              context.watch<AuthCubit>().hasSpecialCharacters,
                          hasNumber: context.watch<AuthCubit>().hasNumber,
                          hasMinLength: context.watch<AuthCubit>().hasMinLength,
                        ),
                        GestureDetector(
                          onTap: () {
                            final isFormValid =
                                formKey.currentState!.validate();
                            if (isFormValid && canRegister) {
                              register(context);
                            }
                            if (!isFormValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("fill_all_fields".tr()),
                                ),
                              );
                            } else if (!canRegister) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("password_requirements".tr()),
                                ),
                              );
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
                                "sign_up".tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              "already_have_account".tr(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            GestureDetector(
                              onTap: onTap,
                              child: Text(
                                "login".tr(),
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
        ),
      ),
    ); 
  }
}
