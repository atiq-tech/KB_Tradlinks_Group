import 'dart:convert';

class ProductLedgerModel {
  final String sequence;
  final String id;
  final String date;
  final String description;
  final String rate;
  final String inQuantity;
  final String outQuantity;
  final int stock;

  ProductLedgerModel({
    required this.sequence,
    required this.id,
    required this.date,
    required this.description,
    required this.rate,
    required this.inQuantity,
    required this.outQuantity,
    required this.stock,
  });

  factory ProductLedgerModel.fromJson(String str) => ProductLedgerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductLedgerModel.fromMap(Map<String, dynamic> json) => ProductLedgerModel(
    sequence: json["sequence"]??"",
    id: json["id"]??"",
    date: json["date"]??"",
    description: json["description"]??"",
    rate: json["rate"]??"",
    inQuantity: json["in_quantity"]??"",
    outQuantity: json["out_quantity"]??"",
    stock: json["stock"]??0,
  );

  Map<String, dynamic> toMap() => {
    "sequence": sequence,
    "id": id,
    "date": date,
    "description": description,
    "rate": rate,
    "in_quantity": inQuantity,
    "out_quantity": outQuantity,
    "stock": stock,
  };
}
