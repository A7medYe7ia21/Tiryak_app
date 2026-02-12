import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../logic/home_cubit.dart';
import '../logic/home_state.dart';
import '../data/model/medicine_model.dart';
import 'widgets/home_banner_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/location_bar_widget.dart';
// search screen is resolved via GoRouter (AppPath.search) so import here isn't required
// import '../../search/ui/search_screen.dart';
import 'package:tryiak/core/router/go_router.dart' as app_paths;
import 'medicine_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => HomeCubit()..initialize(),
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => state.when(
              initial: () => const Center(
                child: CircularProgressIndicator(),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (message) => Center(
                child: Text(message),
              ),
              loaded: (banners, categories, medicines) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: theme.brightness == Brightness.light
                            ? const BoxDecoration(
                                color: Color(0xFF75DDFA),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              )
                            : null,
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 12,
                          right: 12,
                          bottom: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              "welcome_to_tiryak".tr(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SearchBarWidget(
                              searchController: _searchController,
                              onSearch: (query) {
                                context
                                    .read<HomeCubit>()
                                    .searchMedicines(query);
                              },
                              onTap: () {
                                context.go(
                                    '${app_paths.AppPath.search}?autofocus=true');
                              },
                              inHeader: true,
                            ),
                            const SizedBox(height: 8),
                            const LocationBarWidget(),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HomeBannerWidget(banners: banners),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "popular_medicines".tr(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: medicines.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final dynamic item = medicines[index];
                          // medicines can be either MedicineModel (after migration)
                          // or Map<String, dynamic> (older state). Handle both safely.
                          String imagePath = '';
                          String name = '';

                          // additional lines to show under the name
                          String subtitle = '';
                          String subInfo = '';

                          if (item is MedicineModel) {
                            imagePath = item.imagePath;
                            name = item.name;
                            // Show form on the first secondary line, then generic name
                            subtitle = item.form ?? '';
                            subInfo = item.genericName ?? '';
                          } else if (item is Map) {
                            imagePath = (item['imagePath'] ??
                                item['image'] ??
                                '') as String;
                            name = (item['name'] ?? '') as String;

                            // For map-shaped items prefer showing form first,
                            // then the generic name underneath.
                            subtitle = (item['form'] ??
                                item['type'] ??
                                item['dosage'] ??
                                item['strength'] ??
                                '') as String;
                            subInfo = (item['genericName'] ??
                                item['subtitle'] ??
                                item['description'] ??
                                '') as String;
                          }

                          return GestureDetector(
                            onTap: () {
                              // Navigate to details screen, converting Map -> MedicineModel if needed
                              MedicineModel med;
                              if (item is MedicineModel) {
                                med = item;
                              } else if (item is Map) {
                                med = MedicineModel(
                                  name: (item['name'] ?? '') as String,
                                  imagePath: (item['imagePath'] ??
                                      item['image'] ??
                                      '') as String,
                                  genericName: (item['genericName'] ??
                                      item['subtitle'] ??
                                      item['description'] ??
                                      '') as String?,
                                  form: (item['form'] ??
                                      item['dosage'] ??
                                      item['strength'] ??
                                      item['type'] ??
                                      '') as String?,
                                );
                              } else {
                                med = MedicineModel(
                                    name: name, imagePath: imagePath);
                              }

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    MedicineDetailsScreen(medicine: med),
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (imagePath.isNotEmpty)
                                    Image.asset(
                                      imagePath,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  else
                                    Container(
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                          Icons.image_not_supported,
                                          size: 36,
                                          color: Colors.grey),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 6),
                                        // First secondary line (e.g. generic name)
                                        if (subtitle.isNotEmpty)
                                          Text(
                                            subtitle,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: Colors.green[700],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        if (subtitle.isNotEmpty)
                                          const SizedBox(height: 5),
                                        // Second secondary line (e.g. form • strength / dosage)
                                        if (subInfo.isNotEmpty)
                                          Text(
                                            subInfo,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: Colors.green[700],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
