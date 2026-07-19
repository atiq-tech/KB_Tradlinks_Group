import 'dart:convert';

class DistrictModel {
  final String districtSlNo;
  final String districtName;
  final String status;
  final String addBy;
  final String addTime;
  final dynamic updateBy;
  final dynamic updateTime;

  DistrictModel({
    required this.districtSlNo,
    required this.districtName,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
  });

  factory DistrictModel.fromJson(String str) => DistrictModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DistrictModel.fromMap(Map<String, dynamic> json) => DistrictModel(
    districtSlNo: json["District_SlNo"]??"",
    districtName: json["District_Name"]??"",
    status: json["status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
  );

  Map<String, dynamic> toMap() => {
    "District_SlNo": districtSlNo,
    "District_Name": districtName,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
  };
}
