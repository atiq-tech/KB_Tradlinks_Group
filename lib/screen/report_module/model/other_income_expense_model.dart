import 'dart:convert';

class OtherIncomeExpenseModel {
  final String income;
  final String expense;
  final String employeePayment;
  final String damagedAmount;
  final String returnedAmount;

  OtherIncomeExpenseModel({
    required this.income,
    required this.expense,
    required this.employeePayment,
    required this.damagedAmount,
    required this.returnedAmount,
  });

  factory OtherIncomeExpenseModel.fromJson(String str) => OtherIncomeExpenseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toJson());

  factory OtherIncomeExpenseModel.fromMap(Map<String, dynamic> json) => OtherIncomeExpenseModel(
    income: json["income"]??"",
    expense: json["expense"]??"",
    employeePayment: json["employee_payment"]??"",
    damagedAmount: json["damaged_amount"]??"",
    returnedAmount: json["returned_amount"]??"",
  );

  Map<String, dynamic> toMap() => {
    "income": income,
    "expense": expense,
    "employee_payment": employeePayment,
    "damaged_amount": damagedAmount,
    "returned_amount": returnedAmount,
  };
}
