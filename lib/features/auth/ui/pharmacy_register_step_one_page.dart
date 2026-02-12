import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ionicons/ionicons.dart';

import '../../../core/helpers/app_regex.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';
import 'pharmacy_register_step_two_page.dart';
import 'widgets/app_header.dart';
import 'widgets/my_textfield.dart';

class PharmacyRegisterStepOnePage extends StatelessWidget {
  PharmacyRegisterStepOnePage({super.key, required this.onTap});
  final void Function()? onTap;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void nextStep(BuildContext context) {
    final isFormValid = formKey.currentState!.validate();
    if (isFormValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PharmacyRegisterStepTwoPage(onTap: onTap),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("fill_all_fields".tr()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          icon: Ionicons.medkit,
                          title: 'register_pharmacy'.tr(),
                          subtitle: 'enter_account_details'.tr(),
                        ),
                        MyTextField(
                          controller: context.read<AuthCubit>().nameController,
                          hintText: "username".tr(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_valid_username'.tr();
                            }
                            return null;
                          },
                        ),
                        MyTextField(
                          controller: context.read<AuthCubit>().emailController,
                          hintText: "email".tr(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_valid_email'.tr();
                            }
                            if (!AppRegex.isEmailValid(value)) {
                              return 'please_enter_valid_email'.tr();
                            }
                            return null;
                          },
                        ),
                        IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: "phone_number".tr(),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'EG',
                          onChanged: (phone) {
                            context
                                .read<AuthCubit>()
                                .phoneNumberController
                                .text = phone.completeNumber;
                          },
                          validator: (phone) {
                            if (phone == null || phone.completeNumber.isEmpty) {
                              return "please_enter_valid_phone".tr();
                            }
                            return null;
                          },
                        ),
                        MyTextField(
                          controller:
                              context.read<AuthCubit>().pharmacyNameController,
                          hintText: "pharmacy_name".tr(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_pharmacy_name'.tr();
                            }
                            return null;
                          },
                        ),
                        GestureDetector(
                          onTap: () => nextStep(context),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "next".tr(),
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
