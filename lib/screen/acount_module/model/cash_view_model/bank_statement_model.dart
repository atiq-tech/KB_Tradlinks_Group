import 'dart:convert';

class BankAccountSummary {
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
  final String totalDeposit;
  final String totalWithdraw;
  final String totalReceivedFromCustomer;
  final String totalPaidToCustomer;
  final String totalPaidToSupplier;
  final String totalReceivedFromSupplier;
  final String balance;

  BankAccountSummary({
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
    required this.totalDeposit,
    required this.totalWithdraw,
    required this.totalReceivedFromCustomer,
    required this.totalPaidToCustomer,
    required this.totalPaidToSupplier,
    required this.totalReceivedFromSupplier,
    required this.balance,
  });

  factory BankAccountSummary.fromJson(String str) => BankAccountSummary.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankAccountSummary.fromMap(Map<String, dynamic> json) => BankAccountSummary(
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
    totalDeposit: json["total_deposit"]??"",
    totalWithdraw: json["total_withdraw"]??"",
    totalReceivedFromCustomer: json["total_received_from_customer"]??"",
    totalPaidToCustomer: json["total_paid_to_customer"]??"",
    totalPaidToSupplier: json["total_paid_to_supplier"]??"",
    totalReceivedFromSupplier: json["total_received_from_supplier"]??"",
    balance: json["balance"]??"",
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
    "total_deposit": totalDeposit,
    "total_withdraw": totalWithdraw,
    "total_received_from_customer": totalReceivedFromCustomer,
    "total_paid_to_customer": totalPaidToCustomer,
    "total_paid_to_supplier": totalPaidToSupplier,
    "total_received_from_supplier": totalReceivedFromSupplier,
    "balance": balance,
  };
}