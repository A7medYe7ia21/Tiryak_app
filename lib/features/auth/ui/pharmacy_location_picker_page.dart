import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../location/logic/location_cubit.dart';
import '../../location/logic/location_state.dart';

class PharmacyLocationPickerPage extends StatefulWidget {
  final Function(double latitude, double longitude, String address)
      onLocationSelected;

  const PharmacyLocationPickerPage({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<PharmacyLocationPickerPage> createState() =>
      _PharmacyLocationPickerPageState();
}

class _PharmacyLocationPickerPageState
    extends State<PharmacyLocationPickerPage> {
  late MapController mapController;
  LatLng? selectedLocation;
  String selectedAddress = '';

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getCurrentLocation();
  }

  void _getCurrentLocation() {
    context.read<LocationCubit>().requestLocationPermission();
  }

  void _handleMapTap(LatLng position) {
    setState(() {
      selectedLocation = position;
    });
    _getAddressFromCoordinates(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final placemarks = await GeocodingPlatform.instance!
          .placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address =
            '${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.country ?? ''}';
        setState(() {
          selectedAddress = address;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_pharmacy_location'.tr()),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildInitialState(),
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (latitude, longitude, address) => Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(latitude, longitude),
                    initialZoom: 15,
                    onTap: (tapPosition, point) => _handleMapTap(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        if (selectedLocation != null)
                          Marker(
                            point: selectedLocation!,
                            width: 50,
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ],
                            ),
                          )
                        else
                          Marker(
                            point: LatLng(latitude, longitude),
                            width: 50,
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedLocation != null ||
                            selectedAddress.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'selected_location'.tr(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedAddress.isNotEmpty
                                          ? selectedAddress
                                          : 'Unknown Location',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '${selectedLocation?.latitude.toStringAsFixed(4) ?? latitude.toStringAsFixed(4)}, '
                                      '${selectedLocation?.longitude.toStringAsFixed(4) ?? longitude.toStringAsFixed(4)}',
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
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        GestureDetector(
                          onTap: selectedLocation != null
                              ? () {
                                  widget.onLocationSelected(
                                    selectedLocation!.latitude,
                                    selectedLocation!.longitude,
                                    selectedAddress,
                                  );
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selectedLocation != null
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'confirm_location'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(message),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_searching, size: 48),
          SizedBox(height: 16),
          Text('getting_location'.tr()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
