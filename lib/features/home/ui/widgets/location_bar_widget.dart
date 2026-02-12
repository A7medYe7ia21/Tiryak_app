import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tryiak/features/location/logic/location_cubit.dart';
import 'package:tryiak/features/location/logic/location_state.dart';

class LocationBarWidget extends StatelessWidget {
  const LocationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: state.when(
                  initial: () => const Text('جاري جلب الموقع...'),
                  loading: () => const Text('يتم الحصول على موقعك...'),
                  loaded: (latitude, longitude, address) {
                    final city = address['locality'] ?? '';
                    final governorate = address['administrativeArea'] ?? '';
                    final country = address['country'] ?? '';

                    // Build display string: City، Governorate — Country
                    String display;
                    if (city.isNotEmpty &&
                        governorate.isNotEmpty &&
                        country.isNotEmpty) {
                      display = '$city، $governorate — $country';
                    } else if (city.isNotEmpty && governorate.isNotEmpty) {
                      display = '$city، $governorate';
                    } else if (city.isNotEmpty && country.isNotEmpty) {
                      display = '$city — $country';
                    } else if (governorate.isNotEmpty && country.isNotEmpty) {
                      display = '$governorate — $country';
                    } else if (city.isNotEmpty) {
                      display = city;
                    } else if (governorate.isNotEmpty) {
                      display = governorate;
                    } else if (country.isNotEmpty) {
                      display = country;
                    } else {
                      display = 'موقع غير معروف';
                    }

                    return Text(
                      display,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                  error: (message) => Text(
                    'خطأ: $message',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
