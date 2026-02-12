import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../data/location_model.dart';

class SelectLocationScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;

  const SelectLocationScreen(
      {super.key,
      this.initialLatitude,
      this.initialLongitude,
      this.initialAddress});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? _selected;
  String? _selectedAddress;
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selected = LatLng(widget.initialLatitude!, widget.initialLongitude!);
      _selectedAddress = widget.initialAddress;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        try {
          _mapController.move(_selected!, 13.0);
        } catch (_) {}
      });
    } else {
      _initPosition();
    }
  }

  Future<void> _initPosition() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        try {
          _mapController.move(LatLng(pos.latitude, pos.longitude), 13.0);
        } catch (_) {}
      });
    } catch (_) {}
  }

  Future<void> _onMapTap(LatLng point) async {
    setState(() {
      _selected = point;
      _selectedAddress = null;
    });
    try {
      final placemarks =
          await placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isNotEmpty) {
        final pm = placemarks.first;
        final address = [
          pm.street,
          pm.locality,
          pm.administrativeArea,
          pm.country
        ].where((e) => e != null && e.trim().isNotEmpty).join(', ');
        setState(() {
          _selectedAddress = address;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${'could_not_get_address'.tr()}: $e')));
      }
      setState(() {
        _selectedAddress = null;
      });
    }
  }

  void _confirm() {
    if (_selected == null) return;
    final model = LocationModel(
        latitude: _selected!.latitude,
        longitude: _selected!.longitude,
        address: _selectedAddress);
    Navigator.of(context).pop(model);
  }

  @override
  Widget build(BuildContext context) {
    final center =
        _selected ?? LatLng(30.0444, 31.2357); // Cairo default if no selection
    return Scaffold(
      appBar: AppBar(
        title: Text("select_location".tr()),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 13,
              onTap: (tapPos, point) => _onMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              if (_selected != null)
                MarkerLayer(markers: [
                  Marker(
                    point: _selected!,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 36,
                    ),
                  )
                ]),
            ],
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 20,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_selectedAddress ??
                              'Tap on the map to choose a delivery location.'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _selected == null ? null : _confirm,
                            child: Text("confirm_location".tr()),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
