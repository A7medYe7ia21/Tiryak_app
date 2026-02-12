import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../data/model/medicine_model.dart';
import 'create_request_screen.dart';

class MedicineDetailsScreen extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineDetailsScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("medicine_details".tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: medicine.imagePath.isNotEmpty
                  ? Image.asset(
                      medicine.imagePath,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 64),
                    ),
            ),
            const SizedBox(height: 16),

            // Title & generic
            Text(
              medicine.name,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            if ((medicine.genericName ?? '').isNotEmpty)
              Text(
                medicine.genericName!,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey[700]),
              ),

            const SizedBox(height: 12),

            // Two small info chips (form and strength/info)
            Row(
              children: [
                if ((medicine.form ?? '').isNotEmpty)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("form".tr(),
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[700])),
                          const SizedBox(height: 6),
                          Text(medicine.form!,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.blue[700])),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                // placeholder for strength or other info if needed
                // In this simplified UI we reuse form as second info if present
                // (real data model can be extended later)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("strength".tr(),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[700])),
                        const SizedBox(height: 6),
                        Text(medicine.form ?? '-',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.green[700])),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description card (placeholder)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18),
                      const SizedBox(width: 8),
                      Text("description".tr(),
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No description available.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // space at bottom so content isn't hidden by bottom button
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to create request screen with the current medicine
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CreateRequestScreen(medicine: medicine)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF75DDFA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("request_this_medicine".tr()),
            ),
          ),
        ),
      ),
    );
  }
}
