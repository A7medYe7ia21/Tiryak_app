import 'package:json_annotation/json_annotation.dart';

part 'medicine_model.g.dart';

@JsonSerializable()
class MedicineModel {
  final String name;
  final String imagePath;
  final String? genericName;
  final String? form;

  MedicineModel({
    required this.name,
    required this.imagePath,
    this.genericName,
    this.form,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineModelToJson(this);
}
