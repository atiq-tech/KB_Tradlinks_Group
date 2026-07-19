import 'dart:convert';

class UnitModel {
  final String unitSlNo;
  final String unitName;
  final String status;
  final String addBy;
  final String addTime;
  final dynamic updateBy;
  final dynamic updateTime;

  UnitModel({
    required this.unitSlNo,
    required this.unitName,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
  });

  factory UnitModel.fromJson(String str) => UnitModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnitModel.fromMap(Map<String, dynamic> json) => UnitModel(
    unitSlNo: json["Unit_SlNo"]??"",
    unitName: json["Unit_Name"]??"",
    status: json["status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
  );

  Map<String, dynamic> toMap() => {
    "Unit_SlNo": unitSlNo,
    "Unit_Name": unitName,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
  };
}
