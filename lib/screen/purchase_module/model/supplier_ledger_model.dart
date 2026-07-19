import 'dart:convert';

class SupplierLedgerModel {
  final String sequence;
  final String id;
  final String date;
  final String description;
  final String bill;
  final String paid;
  final String due;
  final String returned;
  final String cashReceived;
  final int balance;

  SupplierLedgerModel({
    required this.sequence,
    required this.id,
    required this.date,
    required this.description,
    required this.bill,
    required this.paid,
    required this.due,
    required this.returned,
    required this.cashReceived,
    required this.balance,
  });

  factory SupplierLedgerModel.fromJson(String str) => SupplierLedgerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SupplierLedgerModel.fromMap(Map<String, dynamic> json) => SupplierLedgerModel(
    sequence: json["sequence"]??"",
    id: json["id"]??"",
    date: json["date"]??"",
    description: json["description"]??"",
    bill: json["bill"]??"",
    paid: json["paid"]??"",
    due: json["due"]??"",
    returned: json["returned"]??"",
    cashReceived: json["cash_received"]??"",
    balance: json["balance"]??0,
  );

  Map<String, dynamic> toMap() => {
    "sequence": sequence,
    "id": id,
    "date":date,
  "description": description,
    "bill": bill,
    "paid": paid,
    "due": due,
    "returned": returned,
    "cash_received": cashReceived,
    "balance": balance,
  };
}
