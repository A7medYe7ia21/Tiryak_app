import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

ToastificationItem showCustomToast({
  required BuildContext context,
  required ToastificationType toastType,
  required String title,
  required String description,
  IconData? icon,
  Color? primaryColor,
  Color? backgroundColor,
  Color? foregroundColor,
}) {
  final defaultColors = {
    ToastificationType.success: Colors.green,
    ToastificationType.warning: Colors.orange,
    ToastificationType.error: Colors.red,
    ToastificationType.info: Colors.blue,
  };

  final color = primaryColor ?? defaultColors[toastType] ?? Colors.grey;

  return toastification.show(
    context: context,
    type: toastType,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(milliseconds: 1500),
    title: Text(title),
    description: Text(description),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    icon: Icon(icon ?? Icons.notifications),
    showIcon: true,
    primaryColor: color,
    backgroundColor: backgroundColor ?? Colors.white,
    foregroundColor: foregroundColor ?? Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: false,
    closeButton: ToastCloseButton(
      showType: CloseButtonShowType.onHover,
      buttonBuilder: (context, onClose) {
        return OutlinedButton.icon(
          onPressed: onClose,
          icon: const Icon(Icons.close, size: 20),
          label: const Text('Close'),
        );
      },
    ),
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: false,
  );
}

void showSuccessToast({
  required BuildContext context,
  required String message,
}) {
  showCustomToast(
    context: context,
    toastType: ToastificationType.success,
    title: 'Success',
    description: message,
    icon: Icons.check_circle,
    primaryColor: Colors.green,
  );
}

void showErrorToast({
  required BuildContext context,
  required String message,
}) {
  showCustomToast(
    context: context,
    toastType: ToastificationType.error,
    title: 'Error',
    description: message,
    icon: Icons.error,
    primaryColor: Colors.red,
  );
}

void showWarningToast({
  required BuildContext context,
  required String message,
}) {
  showCustomToast(
    context: context,
    toastType: ToastificationType.warning,
    title: 'Warning',
    description: message,
    icon: Icons.warning,
    primaryColor: Colors.orange,
  );
}

void showInfoToast({
  required BuildContext context,
  required String message,
}) {
  showCustomToast(
    context: context,
    toastType: ToastificationType.info,
    title: 'Info',
    description: message,
    icon: Icons.info,
    primaryColor: Colors.blue,
  );
}
