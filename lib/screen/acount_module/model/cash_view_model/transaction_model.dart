import 'dart:convert';

class TransactionSummary {
  final String receivedSales;
  final String receivedCustomer;
  final String receivedSupplier;
  final String receivedCash;
  final String bankWithdraw;
  final String paidPurchase;
  final String ownFreight;
  final String paidSupplier;
  final String paidCustomer;
  final String paidCash;
  final String bankDeposit;
  final String employeePayment;
  final String totalIn;
  final String totalOut;
  final String cashBalance;

  TransactionSummary({
    required this.receivedSales,
    required this.receivedCustomer,
    required this.receivedSupplier,
    required this.receivedCash,
    required this.bankWithdraw,
    required this.paidPurchase,
    required this.ownFreight,
    required this.paidSupplier,
    required this.paidCustomer,
    required this.paidCash,
    required this.bankDeposit,
    required this.employeePayment,
    required this.totalIn,
    required this.totalOut,
    required this.cashBalance,
  });

  factory TransactionSummary.fromJson(String str) => TransactionSummary.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionSummary.fromMap(Map<String, dynamic> json) => TransactionSummary(
    receivedSales: json["received_sales"]??"",
    receivedCustomer: json["received_customer"]??"",
    receivedSupplier: json["received_supplier"]??"",
    receivedCash: json["received_cash"]??"",
    bankWithdraw: json["bank_withdraw"]??"",
    paidPurchase: json["paid_purchase"]??"",
    ownFreight: json["own_freight"]??"",
    paidSupplier: json["paid_supplier"]??"",
    paidCustomer: json["paid_customer"]??"",
    paidCash: json["paid_cash"]??"",
    bankDeposit: json["bank_deposit"]??"",
    employeePayment: json["employee_payment"]??"",
    totalIn: json["total_in"]??"",
    totalOut: json["total_out"]??"",
    cashBalance: json["cash_balance"]??"",
  );

  Map<String, dynamic> toMap() => {
    "received_sales": receivedSales,
    "received_customer": receivedCustomer,
    "received_supplier": receivedSupplier,
    "received_cash": receivedCash,
    "bank_withdraw": bankWithdraw,
    "paid_purchase": paidPurchase,
    "own_freight": ownFreight,
    "paid_supplier": paidSupplier,
    "paid_customer": paidCustomer,
    "paid_cash": paidCash,
    "bank_deposit": bankDeposit,
    "employee_payment": employeePayment,
    "total_in": totalIn,
    "total_out": totalOut,
    "cash_balance": cashBalance,
  };
}
