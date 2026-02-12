import 'package:json_annotation/json_annotation.dart';

part 'request_model.g.dart';

@JsonSerializable()
class MedicineRequest {
  @JsonKey(name: '_id')
  final String id;
  final String patientName;
  final String medicineName;
  final String? medicineGenericName;
  final String? medicineForm;
  final String? medicineImage;
  final int quantity;
  final String deliveryType; // 'delivery' or 'pickup'
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? distance; // Distance in km
  final String? note;
  final String? prescriptionUrl;
  final String status; // 'new', 'pending', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? updatedAt;

  MedicineRequest({
    required this.id,
    required this.patientName,
    required this.medicineName,
    this.medicineGenericName,
    this.medicineForm,
    this.medicineImage,
    required this.quantity,
    required this.deliveryType,
    this.address,
    this.latitude,
    this.longitude,
    this.distance,
    this.note,
    this.prescriptionUrl,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory MedicineRequest.fromJson(Map<String, dynamic> json) =>
      _$MedicineRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineRequestToJson(this);

  MedicineRequest copyWith({
    String? id,
    String? patientName,
    String? medicineName,
    String? medicineGenericName,
    String? medicineForm,
    String? medicineImage,
    int? quantity,
    String? deliveryType,
    String? address,
    double? latitude,
    double? longitude,
    double? distance,
    String? note,
    String? prescriptionUrl,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicineRequest(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      medicineName: medicineName ?? this.medicineName,
      medicineGenericName: medicineGenericName ?? this.medicineGenericName,
      medicineForm: medicineForm ?? this.medicineForm,
      medicineImage: medicineImage ?? this.medicineImage,
      quantity: quantity ?? this.quantity,
      deliveryType: deliveryType ?? this.deliveryType,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      note: note ?? this.note,
      prescriptionUrl: prescriptionUrl ?? this.prescriptionUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
