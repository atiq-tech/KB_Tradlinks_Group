import 'dart:convert';

import 'package:kbtradlink/screen/sales_module/invoice/model/sales_details_model.dart';
import 'package:kbtradlink/screen/sales_module/invoice/model/sales_model.dart';

class SalesInvoiceModel {
  final List<SaleDetailModel> salesDetailsModel;
  final List<SalesModel> salesModel;

  SalesInvoiceModel({
    required this.salesDetailsModel,
    required this.salesModel,
  });

  factory SalesInvoiceModel.fromJson(String str) => SalesInvoiceModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesInvoiceModel.fromMap(Map<String, dynamic> json) => SalesInvoiceModel(
    salesDetailsModel: List<SaleDetailModel>.from(json["saleDetails"].map((x) => SaleDetailModel.fromMap(x))),
    salesModel: List<SalesModel>.from(json["sales"].map((x) => SalesModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "saleDetails": List<dynamic>.from(salesDetailsModel.map((x) => x.toMap())),
    "sales": List<dynamic>.from(salesModel.map((x) => x.toMap())),
  };
}