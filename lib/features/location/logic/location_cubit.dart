import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationState.initial());

  Future<void> requestLocationPermission() async {
    emit(LocationState.loading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationState.error('Location services are disabled.'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationState.error('Location permissions are denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
            LocationState.error('Location permissions are permanently denied'));
        return;
      }

      // Get current location
      await getCurrentLocation();
    } catch (e) {
      emit(LocationState.error(e.toString()));
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = {
          'street': placemark.street,
          'subLocality': placemark.subLocality,
          'locality': placemark.locality,
          'administrativeArea': placemark.administrativeArea,
          'country': placemark.country,
          'postalCode': placemark.postalCode,
        };

        emit(LocationState.loaded(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        ));
      }
    } catch (e) {
      emit(LocationState.error(e.toString()));
    }
  }
}
