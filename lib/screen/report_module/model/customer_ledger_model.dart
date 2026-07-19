import 'dart:convert';

class CustomerLedgerModel {
  final String sequence;
  final String id;
  final String date;
  final String description;
  final String bill;
  final String paid;
  final String due;
  final String returned;
  final String paidOut;
  final String balance;

  CustomerLedgerModel({
    required this.sequence,
    required this.id,
    required this.date,
    required this.description,
    required this.bill,
    required this.paid,
    required this.due,
    required this.returned,
    required this.paidOut,
    required this.balance,
  });

  factory CustomerLedgerModel.fromJson(String str) => CustomerLedgerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerLedgerModel.fromMap(Map<String, dynamic> json) => CustomerLedgerModel(
    sequence: json["sequence"]??"",
    id: json["id"]??"",
    date: json["date"]??"",
    description: json["description"]??"",
    bill: json["bill"]??"",
    paid: json["paid"]??"",
    due: json["due"]??"",
    returned: json["returned"]??"",
    paidOut: json["paid_out"]??"",
    balance: json["balance"] is int || json["balance"] is double ? json["balance"].toString() : json["balance"] ??"",
  );

  Map<String, dynamic> toMap() => {
    "sequence": sequence,
    "id": id,
    "date": date,
  "description": description,
    "bill": bill,
    "paid": paid,
    "due": due,
    "returned": returned,
    "paid_out": paidOut,
    "balance": balance,
  };
}
