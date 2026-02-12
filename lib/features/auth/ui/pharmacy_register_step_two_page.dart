import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../data/model/pharmacy_register_request_body.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';
import 'pharmacy_location_picker_page.dart';
import 'widgets/app_header.dart';
import 'widgets/my_textfield.dart';
import 'widgets/password_validations.dart';

class PharmacyRegisterStepTwoPage extends StatefulWidget {
  PharmacyRegisterStepTwoPage({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  State<PharmacyRegisterStepTwoPage> createState() =>
      _PharmacyRegisterStepTwoPageState();
}

class _PharmacyRegisterStepTwoPageState
    extends State<PharmacyRegisterStepTwoPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  double? selectedLatitude;
  double? selectedLongitude;
  String selectedAddress = '';
  bool isRegistering = false;

  void registerPharmacy(BuildContext context) async {
    if (isRegistering) return; // Prevent multiple submissions

    setState(() {
      isRegistering = true;
    });

    final authCubit = context.read<AuthCubit>();
    final String username = authCubit.nameController.text;
    final String email = authCubit.emailController.text;
    final String phoneNumber = authCubit.phoneNumberController.text;
    final String password = authCubit.passwordController.text;
    final String confirmPassword = authCubit.confirmPasswordController.text;
    final String pharmacyName = authCubit.pharmacyNameController.text;
    final String address = selectedAddress;

    if (username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        pharmacyName.isEmpty ||
        selectedLatitude == null ||
        selectedLongitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("fill_all_fields".tr()),
          backgroundColor: Colors.red[600],
        ),
      );
      setState(() {
        isRegistering = false;
      });
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("passwords_dont_match".tr()),
          backgroundColor: Colors.red[600],
        ),
      );
      setState(() {
        isRegistering = false;
      });
      return;
    }

    final requestBody = PharmacyRegisterRequestBody(
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      role: 'pharmacy',
      pharmacyName: pharmacyName,
      address: address,
      location: {
        'coordinates': [selectedLongitude!, selectedLatitude!],
      },
    );

    await authCubit.registerPharmacy(requestBody);

    setState(() {
      isRegistering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final canRegister = authCubit.hasLowercase &&
        authCubit.hasUppercase &&
        authCubit.hasSpecialCharacters &&
        authCubit.hasNumber &&
        authCubit.hasMinLength;
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
            title: Text('register_pharmacy'.tr()),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 15,
                      children: [
                        SizedBox(height: 20),
                        AppHeader(
                          icon: Ionicons.location,
                          title: 'pharmacy_details'.tr(),
                          subtitle: 'enter_location_details'.tr(),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PharmacyLocationPickerPage(
                                  onLocationSelected:
                                      (latitude, longitude, address) {
                                    setState(() {
                                      selectedLatitude = latitude;
                                      selectedLongitude = longitude;
                                      selectedAddress = address;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedLatitude != null &&
                                        selectedLongitude != null
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedLatitude != null &&
                                              selectedLongitude != null
                                          ? 'location_selected'.tr()
                                          : 'select_on_map'.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    if (selectedLatitude != null &&
                                        selectedLongitude != null)
                                      Text(
                                        '${selectedLatitude?.toStringAsFixed(4)}, ${selectedLongitude?.toStringAsFixed(4)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.7),
                                            ),
                                      ),
                                  ],
                                ),
                                Icon(
                                  Icons.map,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                              return "passwords_dont_match".tr();
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
                          onTap: isRegistering
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  if (selectedLatitude == null ||
                                      selectedLongitude == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text("select_on_map".tr()),
                                        backgroundColor: Colors.red[600],
                                      ),
                                    );
                                    return;
                                  }
                                  if (!canRegister) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "password_requirements".tr()),
                                        backgroundColor: Colors.red[600],
                                      ),
                                    );
                                    return;
                                  }
                                  final isFormValid =
                                      formKey.currentState!.validate();
                                  if (isFormValid) {
                                    registerPharmacy(context);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("fill_all_fields".tr()),
                                        backgroundColor: Colors.red[600],
                                      ),
                                    );
                                  }
                                },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary
                                  .withOpacity(isRegistering ? 0.6 : 1.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: isRegistering
                                  ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .onTertiary,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "register_pharmacy".tr(),
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
                              onTap: widget.onTap,
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
