import 'dart:convert';

class BankLedgerModel {
  final String previousBalance;
  final List<Transaction> transactions;

  BankLedgerModel({
    required this.previousBalance,
    required this.transactions,
  });

  factory BankLedgerModel.fromJson(String str) => BankLedgerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankLedgerModel.fromMap(Map<String, dynamic> json) => BankLedgerModel(
    previousBalance: json["previousBalance"]??"",
    transactions: json["transactions"] ==null || json["transactions"]==[]
        ? []
        : List<Transaction>.from(json["transactions"].map((x) => Transaction.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "previousBalance": previousBalance,
    "transactions": List<dynamic>.from(transactions.map((x) => x.toMap())),
  };
}

class Transaction {
  final String sequence;
  final String id;
  final String description;
  final String accountId;
  final String transactionDate;
  final String transactionType;
  final String deposit;
  final String withdraw;
  final String note;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String branchName;
  final String balance;

  Transaction({
    required this.sequence,
    required this.id,
    required this.description,
    required this.accountId,
    required this.transactionDate,
    required this.transactionType,
    required this.deposit,
    required this.withdraw,
    required this.note,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
    required this.balance,
  });

  factory Transaction.fromJson(String str) => Transaction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
    sequence: json["sequence"]??"",
    id: json["id"]??"",
    description: json["description"]??"",
    accountId: json["account_id"]??"",
    transactionDate: json["transaction_date"]??"",
    transactionType: json["transaction_type"]??"",
    deposit: json["deposit"]??"",
    withdraw: json["withdraw"]??"",
    note: json["note"]??"",
    accountName: json["account_name"]??"",
    accountNumber: json["account_number"]??"",
    bankName: json["bank_name"]??"",
    branchName: json["branch_name"]??"",
    balance:json["balance"] is int ? json["balance"].toString() : json["balance"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "sequence": sequence,
    "id": id,
    "description": description,
    "account_id": accountId,
    "transaction_date": transactionDate,
    "transaction_type": transactionType,
    "deposit": deposit,
    "withdraw": withdraw,
    "note": note,
    "account_name": accountName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "branch_name": branchName,
    "balance": balance,
  };
}
