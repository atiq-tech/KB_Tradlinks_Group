import 'dart:convert';

class SupplierDueModel {
  final String supplierSlNo;
  final String supplierCode;
  final String supplierName;
  final String supplierMobile;
  final String supplierAddress;
  final String bill;
  final String invoicePaid;
  final String cashPaid;
  final String cashReceived;
  final String returned;
  final String paid;
  final String due;

  SupplierDueModel({
    required this.supplierSlNo,
    required this.supplierCode,
    required this.supplierName,
    required this.supplierMobile,
    required this.supplierAddress,
    required this.bill,
    required this.invoicePaid,
    required this.cashPaid,
    required this.cashReceived,
    required this.returned,
    required this.paid,
    required this.due,
  });

  factory SupplierDueModel.fromJson(String str) => SupplierDueModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SupplierDueModel.fromMap(Map<String, dynamic> json) => SupplierDueModel(
    supplierSlNo: json["Supplier_SlNo"]??"",
    supplierCode: json["Supplier_Code"]??"",
    supplierName: json["Supplier_Name"]??"",
    supplierMobile: json["Supplier_Mobile"]??"",
    supplierAddress: json["Supplier_Address"]??"",
    bill: json["bill"]??"",
    invoicePaid: json["invoicePaid"]??"",
    cashPaid: json["cashPaid"]??"",
    cashReceived: json["cashReceived"]??"",
    returned: json["returned"]??"",
    paid: json["paid"]??"",
    due: json["due"]??"",
  );

  Map<String, dynamic> toMap() => {
    "Supplier_SlNo": supplierSlNo,
    "Supplier_Code": supplierCode,
    "Supplier_Name": supplierName,
    "Supplier_Mobile": supplierMobile,
    "Supplier_Address": supplierAddress,
    "bill": bill,
    "invoicePaid": invoicePaid,
    "cashPaid": cashPaid,
    "cashReceived": cashReceived,
    "returned": returned,
    "paid": paid,
    "due": due,
  };
}
