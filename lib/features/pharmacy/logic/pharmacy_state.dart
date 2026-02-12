import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/request_model.dart';
import '../data/models/pharmacy_stats.dart';

part 'pharmacy_state.freezed.dart';

@freezed
class PharmacyState with _$PharmacyState {
  const factory PharmacyState.initial() = _Initial;
  const factory PharmacyState.loading() = _Loading;
  const factory PharmacyState.loaded({
    required PharmacyStats stats,
    required List<MedicineRequest> newRequests,
    required List<MedicineRequest> pendingRequests,
    required List<MedicineRequest> completedRequests,
  }) = _Loaded;
  const factory PharmacyState.error(String message) = _Error;
}
