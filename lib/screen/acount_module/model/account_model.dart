import 'dart:convert';

class AccountModel {
  final String accSlNo;
  final String branchId;
  final String accCode;
  final String accTrType;
  final String accName;
  final String accType;
  final String accDescription;
  final String status;
  final String addBy;
  final String addTime;
  final dynamic updateBy;
  final dynamic updateTime;

  AccountModel({
    required this.accSlNo,
    required this.branchId,
    required this.accCode,
    required this.accTrType,
    required this.accName,
    required this.accType,
    required this.accDescription,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
  });

  factory AccountModel.fromJson(String str) => AccountModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccountModel.fromMap(Map<String, dynamic> json) => AccountModel(
    accSlNo: json["Acc_SlNo"]??"",
    branchId: json["branch_id"]??"",
    accCode: json["Acc_Code"]??"",
    accTrType: json["Acc_Tr_Type"]??"",
    accName: json["Acc_Name"]??"",
    accType: json["Acc_Type"]??"",
    accDescription: json["Acc_Description"]??"",
    status: json["status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
  );

  Map<String, dynamic> toMap() => {
    "Acc_SlNo": accSlNo,
    "branch_id": branchId,
    "Acc_Code": accCode,
    "Acc_Tr_Type": accTrType,
    "Acc_Name": accName,
    "Acc_Type": accType,
    "Acc_Description": accDescription,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
  };
}
