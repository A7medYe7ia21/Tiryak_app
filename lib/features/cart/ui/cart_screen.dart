import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("cart_screen".tr()),
      ),
      body: Center(
        child: Text("welcome_to_cart".tr()),
      ),
    );
  }
}
