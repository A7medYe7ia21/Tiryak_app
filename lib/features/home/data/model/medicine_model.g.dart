// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineModel _$MedicineModelFromJson(Map<String, dynamic> json) =>
    MedicineModel(
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      genericName: json['genericName'] as String?,
      form: json['form'] as String?,
    );

Map<String, dynamic> _$MedicineModelToJson(MedicineModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'imagePath': instance.imagePath,
      'genericName': instance.genericName,
      'form': instance.form,
    };
