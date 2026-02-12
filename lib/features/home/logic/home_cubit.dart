import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tryiak/features/location/data/location_model.dart';
import '../data/model/medicine_model.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial());

  List<MedicineModel> _allMedicines = [];
  String _currentCategory = '';
  String _searchQuery = '';

  LocationModel? selectedLocation;

  void initialize() {
    emit(const HomeState.loading());

    try {
      final medicines = [
        MedicineModel(
            name: "Panadol",
            imagePath: "assets/images/Panadol.jpg",
            genericName: "Paracetamol",
            form: "Tablet • 500mg"),
        MedicineModel(
            name: "Brufen",
            imagePath: "assets/images/Brufen.jpg",
            genericName: "Ibuprofen",
            form: "Tablet • 400mg"),
        MedicineModel(
            name: "Augmentin",
            imagePath: "assets/images/Augmentin.jpg",
            genericName: "Amoxicillin + Clavulanic acid",
            form: "Tablet • 625mg"),
        MedicineModel(
            name: "Adol",
            imagePath: "assets/med1.png",
            genericName: "Tramadol",
            form: "Tablet • 50mg"),
        MedicineModel(
            name: "Cataflam",
            imagePath: "assets/med1.png",
            genericName: "Diclofenac",
            form: "Tablet • 50mg"),
        MedicineModel(
            name: "Voltaren",
            imagePath: "assets/med1.png",
            genericName: "Diclofenac",
            form: "Gel • 10g"),
      ];

      final banners = [
        "assets/delivery.png",
        "assets/delivery.png",
        "assets/delivery.png",
      ];

      final categories = [
        {"title": "Beauty", "image": "assets/med1.png"},
        {"title": "Homecare", "image": "assets/med1.png"},
        {"title": "Fashion", "image": "assets/med1.png"},
        {"title": "Kitchen", "image": "assets/med1.png"},
      ];

      _allMedicines = medicines;

      emit(HomeState.loaded(
        banners: banners,
        categories: categories,
        medicines: _allMedicines,
      ));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  void setLocation(LocationModel location) {
    selectedLocation = location;
    state.maybeWhen(
      loaded: (banners, categories, medicines) {
        emit(HomeState.loaded(
          banners: banners,
          categories: categories,
          medicines: medicines,
        ));
      },
      orElse: () {},
    );
  }

  void searchMedicines(String query) {
    _searchQuery = query.toLowerCase();
    _filterMedicines();
  }

  void filterByCategory(String category) {
    _currentCategory = category;
    _filterMedicines();
  }

  void _filterMedicines() {
    state.maybeWhen(
      loaded: (banners, categories, medicines) {
        var filteredMedicines = List<MedicineModel>.from(_allMedicines);

        if (_currentCategory.isNotEmpty) {
          filteredMedicines = filteredMedicines
              .where((m) =>
                  m.name.toLowerCase().contains(_currentCategory.toLowerCase()))
              .toList();
        }

        if (_searchQuery.isNotEmpty) {
          filteredMedicines = filteredMedicines.where((m) {
            final q = _searchQuery;
            final nameMatch = m.name.toLowerCase().contains(q);
            final genericMatch =
                (m.genericName ?? '').toLowerCase().contains(q);
            final formMatch = (m.form ?? '').toLowerCase().contains(q);
            return nameMatch || genericMatch || formMatch;
          }).toList();
        }

        emit(HomeState.loaded(
          banners: banners,
          categories: categories,
          medicines: filteredMedicines,
        ));
      },
      orElse: () {},
    );
  }
}
