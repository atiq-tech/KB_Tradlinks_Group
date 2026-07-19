import 'dart:convert';

class BranchModel {
  final String brunchId;
  final String brunchName;
  final String brunchTitle;
  final String brunchAddress;
  final String brunchSales;
  final String addDate;
  final String addTime;
  final String addBy;
  final String updateBy;
  final String status;
  final dynamic image;
  final String ctiveStatus;

  BranchModel({
    required this.brunchId,
    required this.brunchName,
    required this.brunchTitle,
    required this.brunchAddress,
    required this.brunchSales,
    required this.addDate,
    required this.addTime,
    required this.addBy,
    required this.updateBy,
    required this.status,
    required this.image,
    required this.ctiveStatus,
  });

  factory BranchModel.fromJson(String str) => BranchModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BranchModel.fromMap(Map<String, dynamic> json) => BranchModel(
    brunchId: json["brunch_id"]??"",
    brunchName: json["Brunch_name"]??"",
    brunchTitle: json["Brunch_title"]??"",
    brunchAddress: json["Brunch_address"]??"",
    brunchSales: json["Brunch_sales"]??"",
    addDate: json["add_date"]??"",
    addTime: json["add_time"]??"",
    addBy: json["add_by"]??"",
    updateBy: json["update_by"]??"",
    status: json["status"]??"",
    image: json["image"],
    ctiveStatus: json["ctive_status"]??"",
  );

  Map<String, dynamic> toMap() => {
    "brunch_id": brunchId,
    "Brunch_name": brunchName,
    "Brunch_title": brunchTitle,
    "Brunch_address": brunchAddress,
    "Brunch_sales": brunchSales,
    "add_date": addDate,
    "add_time": addTime,
    "add_by": addBy,
    "update_by": updateBy,
    "status": status,
    "image": image,
    "ctive_status": ctiveStatus,
  };
}
