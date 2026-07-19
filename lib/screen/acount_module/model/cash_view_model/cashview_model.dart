import 'package:kbtradlink/screen/acount_module/model/cash_view_model/bank_statement_model.dart';
import 'package:kbtradlink/screen/acount_module/model/cash_view_model/transaction_model.dart';
import 'dart:convert';

class CashViewModel {
  final TransactionSummary transactionSummary;
  final List<BankAccountSummary> bankAccountSummary;

  CashViewModel({
    required this.transactionSummary,
    required this.bankAccountSummary,
  });

  factory CashViewModel.fromJson(String str) => CashViewModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CashViewModel.fromMap(Map<String, dynamic> json) => CashViewModel(
    transactionSummary: TransactionSummary.fromMap(json["transaction_summary"]),
    bankAccountSummary: List<BankAccountSummary>.from(json["bank_account_summary"].map((x) => BankAccountSummary.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "transaction_summary": transactionSummary.toMap(),
    "bank_account_summary": List<dynamic>.from(bankAccountSummary.map((x) => x.toMap())),
  };
}
