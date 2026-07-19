import 'dart:convert';

class BankAccountModel {
  final String accountId;
  final String accountName;
  final String accountNumber;
  final String accountType;
  final String bankName;
  final String branchName;
  final String initialBalance;
  final String description;
  final String savedBy;
  final String savedDatetime;
  final String updatedBy;
  final String updatedDatetime;
  final String branchId;
  final String status;
  final String statusText;

  BankAccountModel({
    required this.accountId,
    required this.accountName,
    required this.accountNumber,
    required this.accountType,
    required this.bankName,
    required this.branchName,
    required this.initialBalance,
    required this.description,
    required this.savedBy,
    required this.savedDatetime,
    required this.updatedBy,
    required this.updatedDatetime,
    required this.branchId,
    required this.status,
    required this.statusText,
  });

  factory BankAccountModel.fromJson(String str) => BankAccountModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankAccountModel.fromMap(Map<String, dynamic> json) => BankAccountModel(
    accountId: json["account_id"]??"",
    accountName: json["account_name"]??"",
    accountNumber: json["account_number"]??"",
    accountType: json["account_type"]??"",
    bankName: json["bank_name"]??"",
    branchName: json["branch_name"]??"",
    initialBalance: json["initial_balance"]??"",
    description: json["description"]??"",
    savedBy: json["saved_by"]??"",
    savedDatetime: json["saved_datetime"]??"",
    updatedBy: json["updated_by"]??"",
    updatedDatetime: json["updated_datetime"]??"",
    branchId: json["branch_id"]??"",
    status: json["status"]??"",
    statusText: json["status_text"]??"",
  );

  Map<String, dynamic> toMap() => {
    "account_id": accountId,
    "account_name": accountName,
    "account_number": accountNumber,
    "account_type": accountType,
    "bank_name": bankName,
    "branch_name": branchName,
    "initial_balance": initialBalance,
    "description": description,
    "saved_by": savedBy,
    "saved_datetime": savedDatetime,
    "updated_by": updatedBy,
    "updated_datetime": updatedDatetime,
    "branch_id": branchId,
    "status": status,
    "status_text": statusText,
  };
}
