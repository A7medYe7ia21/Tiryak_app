import 'package:flutter_bloc/flutter_bloc.dart';
import 'pharmacy_state.dart';
import '../data/models/request_model.dart';
import '../data/models/pharmacy_stats.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit() : super(const PharmacyState.initial());

  void loadPharmacyData() {
    emit(const PharmacyState.loading());

    try {
      // Mock data - replace with actual API calls
      final mockRequests = _generateMockRequests();

      final newRequests = mockRequests.where((r) => r.status == 'new').toList();
      final pendingRequests =
          mockRequests.where((r) => r.status == 'pending').toList();
      final completedRequests =
          mockRequests.where((r) => r.status == 'completed').toList();

      final stats = PharmacyStats(
        newRequests: newRequests.length,
        pendingRequests: pendingRequests.length,
        completedToday: completedRequests.length,
        totalRequests: mockRequests.length,
        responseRate: 85.0,
      );

      emit(PharmacyState.loaded(
        stats: stats,
        newRequests: newRequests,
        pendingRequests: pendingRequests,
        completedRequests: completedRequests,
      ));
    } catch (e) {
      emit(PharmacyState.error(e.toString()));
    }
  }

  void updateRequestStatus(String requestId, String newStatus) {
    state.when(
      initial: () {},
      loading: () {},
      error: (_) {},
      loaded: (stats, newRequests, pendingRequests, completedRequests) {
        final allRequests = [
          ...newRequests,
          ...pendingRequests,
          ...completedRequests,
        ];

        // Update the request
        final updatedRequests = allRequests.map((r) {
          if (r.id == requestId) {
            return r.copyWith(status: newStatus, updatedAt: DateTime.now());
          }
          return r;
        }).toList();

        // Recategorize
        final newReqs =
            updatedRequests.where((r) => r.status == 'new').toList();
        final pendingReqs =
            updatedRequests.where((r) => r.status == 'pending').toList();
        final completedReqs =
            updatedRequests.where((r) => r.status == 'completed').toList();

        final updatedStats = PharmacyStats(
          newRequests: newReqs.length,
          pendingRequests: pendingReqs.length,
          completedToday: completedReqs.length,
          totalRequests: updatedRequests.length,
          responseRate: stats.responseRate,
        );

        emit(PharmacyState.loaded(
          stats: updatedStats,
          newRequests: newReqs,
          pendingRequests: pendingReqs,
          completedRequests: completedReqs,
        ));
      },
    );
  }

  List<MedicineRequest> _generateMockRequests() {
    return [
      MedicineRequest(
        id: '1',
        patientName: 'Ahmed Ali',
        medicineName: 'Panadol',
        medicineGenericName: 'Paracetamol',
        medicineForm: 'Tablet • 500mg',
        medicineImage: 'assets/images/Panadol.jpg',
        quantity: 2,
        deliveryType: 'delivery',
        address: '123 Main Street, Cairo',
        latitude: 30.0444,
        longitude: 31.2357,
        distance: 0.8,
        note: 'Please deliver before 5 PM',
        status: 'new',
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      MedicineRequest(
        id: '2',
        patientName: 'Sara Mohamed',
        medicineName: 'Augmentin',
        medicineGenericName: 'Amoxicillin + Clavulanic Acid',
        medicineForm: 'Tablet • 625mg',
        medicineImage: 'assets/images/Augmentin.jpg',
        quantity: 1,
        deliveryType: 'delivery',
        address: '456 Tahrir Square, Cairo',
        latitude: 30.0444,
        longitude: 31.2357,
        distance: 1.2,
        status: 'new',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MedicineRequest(
        id: '3',
        patientName: 'Mahmoud Hassan',
        medicineName: 'Ventolin',
        medicineGenericName: 'Salbutamol',
        medicineForm: 'Inhaler • 100mcg',
        medicineImage: 'assets/med1.png',
        quantity: 1,
        deliveryType: 'pickup',
        distance: 0.5,
        note: 'Urgent prescription',
        prescriptionUrl: 'prescription_url',
        status: 'new',
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      MedicineRequest(
        id: '4',
        patientName: 'Fatma Ibrahim',
        medicineName: 'Brufen',
        medicineGenericName: 'Ibuprofen',
        medicineForm: 'Tablet • 400mg',
        medicineImage: 'assets/images/Brufen.jpg',
        quantity: 3,
        deliveryType: 'delivery',
        address: '789 Nile Street, Giza',
        latitude: 30.0444,
        longitude: 31.2357,
        distance: 1.5,
        status: 'new',
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      MedicineRequest(
        id: '5',
        patientName: 'Omar Khaled',
        medicineName: 'Zantac',
        medicineGenericName: 'Ranitidine',
        medicineForm: 'Tablet • 150mg',
        medicineImage: 'assets/med1.png',
        quantity: 1,
        deliveryType: 'pickup',
        distance: 2.1,
        status: 'new',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      MedicineRequest(
        id: '6',
        patientName: 'Laila Sayed',
        medicineName: 'Adol',
        medicineGenericName: 'Tramadol',
        medicineForm: 'Tablet • 50mg',
        quantity: 1,
        deliveryType: 'delivery',
        address: '321 Heliopolis, Cairo',
        latitude: 30.0444,
        longitude: 31.2357,
        distance: 3.2,
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MedicineRequest(
        id: '7',
        patientName: 'Youssef Ahmed',
        medicineName: 'Panadol',
        medicineGenericName: 'Paracetamol',
        medicineForm: 'Tablet • 500mg',
        quantity: 2,
        deliveryType: 'delivery',
        address: '111 Zamalek, Cairo',
        latitude: 30.0444,
        longitude: 31.2357,
        distance: 1.8,
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      MedicineRequest(
        id: '8',
        patientName: 'Heba Mostafa',
        medicineName: 'Brufen',
        medicineGenericName: 'Ibuprofen',
        medicineForm: 'Tablet • 400mg',
        quantity: 1,
        deliveryType: 'pickup',
        distance: 0.9,
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }
}
