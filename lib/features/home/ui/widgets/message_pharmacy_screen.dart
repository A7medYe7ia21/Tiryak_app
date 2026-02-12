import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tryiak/features/location/ui/select_location_screen.dart';
import 'package:tryiak/features/location/data/location_model.dart';

class MessagePharmacyScreen extends StatefulWidget {
  final LocationModel? initialLocation;

  const MessagePharmacyScreen({
    super.key,
    this.initialLocation,
  });

  @override
  State<MessagePharmacyScreen> createState() => _MessagePharmacyScreenState();
}

class _MessagePharmacyScreenState extends State<MessagePharmacyScreen> {
  int _deliveryOptionIndex = 0;
  LocationModel? _selectedLocation;

  XFile? _prescriptionFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  Future<void> _pickPrescription() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text("take_photo".tr()),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() => _prescriptionFile = picked);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: Text("choose_from_gallery".tr()),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() => _prescriptionFile = picked);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text("cancel".tr()),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removePrescription() {
    setState(() {
      _prescriptionFile = null;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("message_pharmacy".tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "delivery_options".tr(),
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _deliveryOptionIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _deliveryOptionIndex == 0
                            ? Colors.blue.shade50
                            : Colors.white,
                        border: Border.all(
                          color: _deliveryOptionIndex == 0
                              ? Colors.blue
                              : Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "delivery".tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _deliveryOptionIndex == 0
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "to_your_address".tr(),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _deliveryOptionIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _deliveryOptionIndex == 1
                              ? Colors.blue
                              : Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "pickup".tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _deliveryOptionIndex == 1
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            "from_pharmacy".tr(),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (_deliveryOptionIndex == 0) ...[
              Text(
                "delivery_address".tr(),
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedLocation?.address ??
                                '123 Main Street, Cairo, Egypt',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final result =
                            await Navigator.of(context).push<LocationModel?>(
                          MaterialPageRoute(
                            builder: (_) => SelectLocationScreen(
                              initialLatitude: _selectedLocation?.latitude,
                              initialLongitude: _selectedLocation?.longitude,
                              initialAddress: _selectedLocation?.address,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            _selectedLocation = result;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue[700],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("choose_on_map".tr()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
            Text(
              "${'note_to_pharmacy'.tr()} (${'optional'.tr()})",
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "any_special_instructions".tr(),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "${'prescription'.tr()} (${'optional'.tr()})",
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                GestureDetector(
                  onTap: _pickPrescription,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _prescriptionFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file, color: Colors.grey[600]),
                              const SizedBox(height: 6),
                              Text(
                                "upload_prescription".tr(),
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_prescriptionFile!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                  ),
                ),
                if (_prescriptionFile != null)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: _removePrescription,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.close, size: 18),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF75DDFA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("send_message".tr()),
          ),
        ),
      ),
    );
  }
}
