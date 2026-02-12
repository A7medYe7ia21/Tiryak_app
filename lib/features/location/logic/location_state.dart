import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_state.freezed.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState.initial() = _Initial;
  const factory LocationState.loading() = _Loading;
  const factory LocationState.loaded({
    required double latitude,
    required double longitude,
    required Map<String, String?> address,
  }) = _Loaded;
  const factory LocationState.error(String message) = _Error;
}
