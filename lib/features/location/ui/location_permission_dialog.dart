import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/location_cubit.dart';
import '../logic/location_state.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onPermissionGranted;

  const LocationPermissionDialog({
    super.key,
    required this.onPermissionGranted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          loaded: (lat, lng, address) {
            onPermissionGranted();
            Navigator.of(context).pop();
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
      child: AlertDialog(
        title: Text("allow_location_access".tr()),
        content: Text("location_access_message".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("not_now".tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LocationCubit>().requestLocationPermission();
            },
            child: Text("allow".tr()),
          ),
        ],
      ),
    );
  }
}
