import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/go_router.dart';
import '../logic/auth_cubit.dart';
import 'login_page.dart';
import 'pharmacy_register_step_one_page.dart';
import 'register_step_one_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key, this.isPharmacy = false});
  final bool isPharmacy;

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
    // Clear fields when switching between login and register
    context.read<AuthCubit>().clearAllFields();
  }

  VoidCallback get _loginTapCallback {
    if (widget.isPharmacy) {
      return () => context.go('${AppPath.authGate}?type=pharmacy');
    }
    return togglePages;
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      if (widget.isPharmacy) {
        return PharmacyRegisterStepOnePage(onTap: _loginTapCallback);
      } else {
        return RegisterStepOnePage(onTap: togglePages);
      }
    }
  }
}
