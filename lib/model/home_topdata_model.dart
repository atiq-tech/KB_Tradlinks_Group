import 'dart:convert';

class HomeTopDataModel {
  final String todaySale;
  final String monthlySale;
  final String totalDue;
  final String cashBalance;

  HomeTopDataModel({
    required this.todaySale,
    required this.monthlySale,
    required this.totalDue,
    required this.cashBalance,
  });

  factory HomeTopDataModel.fromJson(String str) => HomeTopDataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomeTopDataModel.fromMap(Map<String, dynamic> json) => HomeTopDataModel(
    todaySale: json["todaySale"] is int ? json["todaySale"].toString() : json["todaySale"] ?? "",
    monthlySale: json["monthlySale"]??"",
    totalDue: json["totalDue"]??"",
    cashBalance: json["cashBalance"]??"",
  );

  Map<String, dynamic> toMap() => {
    "todaySale": todaySale,
    "monthlySale": monthlySale,
    "totalDue": totalDue,
    "cashBalance": cashBalance,
  };
}