import 'dart:convert';

class BankTransactionModel {
  final String transactionId;
  final String accountId;
  final String transactionDate;
  final String transactionType;
  final String amount;
  final String note;
  final String savedBy;
  final String savedDatetime;
  final String branchId;
  final String status;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String branchName;

  BankTransactionModel({
    required this.transactionId,
    required this.accountId,
    required this.transactionDate,
    required this.transactionType,
    required this.amount,
    required this.note,
    required this.savedBy,
    required this.savedDatetime,
    required this.branchId,
    required this.status,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
  });

  factory BankTransactionModel.fromJson(String str) => BankTransactionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankTransactionModel.fromMap(Map<String, dynamic> json) => BankTransactionModel(
    transactionId: json["transaction_id"]??"",
    accountId: json["account_id"]??"",
    transactionDate: json["transaction_date"]??"",
    transactionType: json["transaction_type"]??"",
    amount: json["amount"]??"",
    note: json["note"]??"",
    savedBy: json["saved_by"]??"",
    savedDatetime: json["saved_datetime"]??"",
    branchId: json["branch_id"]??"",
    status: json["status"]??"",
    accountName: json["account_name"]??"",
    accountNumber: json["account_number"]??"",
    bankName: json["bank_name"]??"",
    branchName: json["branch_name"]??"",
  );

  Map<String, dynamic> toMap() => {
    "transaction_id": transactionId,
    "account_id": accountId,
    "transaction_date": transactionDate,
    "transaction_type": transactionType,
    "amount": amount,
    "note": note,
    "saved_by": savedBy,
    "saved_datetime": savedDatetime,
    "branch_id": branchId,
    "status": status,
    "account_name": accountName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "branch_name": branchName,
  };
}
