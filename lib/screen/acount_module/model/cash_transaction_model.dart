import 'dart:convert';

class CashTransactionModel {
  final String trSlNo;
  final String trId;
  final String trDate;
  final String trType;
  final String trAccountType;
  final String accSlId;
  final String trDescription;
  final String inAmount;
  final String outAmount;
  final String status;
  final String addBy;
  final String addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final String trBranchid;
  final String accName;

  CashTransactionModel({
    required this.trSlNo,
    required this.trId,
    required this.trDate,
    required this.trType,
    required this.trAccountType,
    required this.accSlId,
    required this.trDescription,
    required this.inAmount,
    required this.outAmount,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.trBranchid,
    required this.accName,
  });

  factory CashTransactionModel.fromJson(String str) => CashTransactionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CashTransactionModel.fromMap(Map<String, dynamic> json) => CashTransactionModel(
    trSlNo: json["Tr_SlNo"],
    trId: json["Tr_Id"],
    trDate: json["Tr_date"] ,
    trType: json["Tr_Type"],
    trAccountType: json["Tr_account_Type"],
    accSlId: json["Acc_SlID"],
    trDescription: json["Tr_Description"],
    inAmount: json["In_Amount"],
    outAmount: json["Out_Amount"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime:  json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    trBranchid: json["Tr_branchid"],
    accName: json["Acc_Name"],
  );

  Map<String, dynamic> toMap() => {
    "Tr_SlNo": trSlNo,
    "Tr_Id": trId,
    "Tr_date": trDate,
    "Tr_Type": trType,
    "Tr_account_Type": trAccountType,
    "Acc_SlID": accSlId,
    "Tr_Description": trDescription,
    "In_Amount": inAmount,
    "Out_Amount": outAmount,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "Tr_branchid": trBranchid,
    "Acc_Name": accName,
  };
}
