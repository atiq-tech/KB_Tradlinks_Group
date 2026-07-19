import 'dart:convert';

class CustomerDueModel {
  final String customerSlNo;
  final String customerName;
  final String customerCode;
  final String customerAddress;
  final String customerMobile;
  final String billAmount;
  final String invoicePaid;
  final String cashReceived;
  final String paidOutAmount;
  final String returnedAmount;
  final String paidAmount;
  final String dueAmount;

  CustomerDueModel({
    required this.customerSlNo,
    required this.customerName,
    required this.customerCode,
    required this.customerAddress,
    required this.customerMobile,
    required this.billAmount,
    required this.invoicePaid,
    required this.cashReceived,
    required this.paidOutAmount,
    required this.returnedAmount,
    required this.paidAmount,
    required this.dueAmount,
  });

  factory CustomerDueModel.fromJson(String str) => CustomerDueModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerDueModel.fromMap(Map<String, dynamic> json) => CustomerDueModel(
    customerSlNo: json["Customer_SlNo"]??"",
    customerName: json["Customer_Name"]??"",
    customerCode: json["Customer_Code"]??"",
    customerAddress: json["Customer_Address"]??"",
    customerMobile: json["Customer_Mobile"]??"",
    billAmount: json["billAmount"]??"",
    invoicePaid: json["invoicePaid"]??"",
    cashReceived: json["cashReceived"]??"",
    paidOutAmount: json["paidOutAmount"]??"",
    returnedAmount: json["returnedAmount"]??"",
    paidAmount: json["paidAmount"]??"",
    dueAmount: json["dueAmount"]??"",
  );

  Map<String, dynamic> toMap() => {
    "Customer_SlNo": customerSlNo,
    "Customer_Name": customerName,
    "Customer_Code": customerCode,
    "Customer_Address": customerAddress,
    "Customer_Mobile": customerMobile,
    "billAmount": billAmount,
    "invoicePaid": invoicePaid,
    "cashReceived": cashReceived,
    "paidOutAmount": paidOutAmount,
    "returnedAmount": returnedAmount,
    "paidAmount": paidAmount,
    "dueAmount": dueAmount,
  };
}
