// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineRequest _$MedicineRequestFromJson(Map<String, dynamic> json) =>
    MedicineRequest(
      id: json['_id'] as String,
      patientName: json['patientName'] as String,
      medicineName: json['medicineName'] as String,
      medicineGenericName: json['medicineGenericName'] as String?,
      medicineForm: json['medicineForm'] as String?,
      medicineImage: json['medicineImage'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      deliveryType: json['deliveryType'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      note: json['note'] as String?,
      prescriptionUrl: json['prescriptionUrl'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MedicineRequestToJson(MedicineRequest instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'patientName': instance.patientName,
      'medicineName': instance.medicineName,
      'medicineGenericName': instance.medicineGenericName,
      'medicineForm': instance.medicineForm,
      'medicineImage': instance.medicineImage,
      'quantity': instance.quantity,
      'deliveryType': instance.deliveryType,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'note': instance.note,
      'prescriptionUrl': instance.prescriptionUrl,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
