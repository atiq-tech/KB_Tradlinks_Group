import 'dart:convert';

class CustomerPaymentModel {
  final String cPaymentId;
  final String cPaymentDate;
  final String cPaymentInvoice;
  final String cPaymentCustomerId;
  final String cPaymentTransactionType;
  final String cPaymentAmount;
  final String outAmount;
  final String cPaymentPaymentby;
  final dynamic accountId;
  final String cPaymentNotes;
  final String cPaymentBrunchid;
  final String cPaymentPreviousDue;
  final String cPaymentAddby;
  final String cPaymentAddDAte;
  final String cPaymentStatus;
  final dynamic updateBy;
  final dynamic cPaymentUpdateDAte;
  final String customerCode;
  final String customerName;
  final String customerMobile;
  final String customerType;
  final dynamic accountName;
  final dynamic accountNumber;
  final dynamic bankName;
  final String transactionType;
  final String paymentBy;

  CustomerPaymentModel({
    required this.cPaymentId,
    required this.cPaymentDate,
    required this.cPaymentInvoice,
    required this.cPaymentCustomerId,
    required this.cPaymentTransactionType,
    required this.cPaymentAmount,
    required this.outAmount,
    required this.cPaymentPaymentby,
    required this.accountId,
    required this.cPaymentNotes,
    required this.cPaymentBrunchid,
    required this.cPaymentPreviousDue,
    required this.cPaymentAddby,
    required this.cPaymentAddDAte,
    required this.cPaymentStatus,
    required this.updateBy,
    required this.cPaymentUpdateDAte,
    required this.customerCode,
    required this.customerName,
    required this.customerMobile,
    required this.customerType,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.transactionType,
    required this.paymentBy,
  });

  factory CustomerPaymentModel.fromJson(String str) => CustomerPaymentModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerPaymentModel.fromMap(Map<String, dynamic> json) => CustomerPaymentModel(
    cPaymentId: json["CPayment_id"]??"",
    cPaymentDate: json["CPayment_date"]??"",
    cPaymentInvoice: json["CPayment_invoice"]??"",
    cPaymentCustomerId: json["CPayment_customerID"]??""??"",
    cPaymentTransactionType: json["CPayment_TransactionType"]??"",
    cPaymentAmount: json["CPayment_amount"]??"",
    outAmount: json["out_amount"]??"",
    cPaymentPaymentby: json["CPayment_Paymentby"]??"",
    accountId: json["account_id"],
    cPaymentNotes: json["CPayment_notes"]??"",
    cPaymentBrunchid: json["CPayment_brunchid"]??"",
    cPaymentPreviousDue: json["CPayment_previous_due"]??"",
    cPaymentAddby: json["CPayment_Addby"]??"",
    cPaymentAddDAte: json["CPayment_AddDAte"]??"",
    cPaymentStatus: json["CPayment_status"]??"",
    updateBy: json["update_by"],
    cPaymentUpdateDAte: json["CPayment_UpdateDAte"],
    customerCode: json["Customer_Code"]??"",
    customerName: json["Customer_Name"]??"",
    customerMobile: json["Customer_Mobile"]??"",
    customerType: json["Customer_Type"]??"",
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    bankName: json["bank_name"],
    transactionType: json["transaction_type"]??"",
    paymentBy: json["payment_by"]??"",
  );

  Map<String, dynamic> toMap() => {
    "CPayment_id": cPaymentId,
    "CPayment_date": cPaymentDate,
    "CPayment_invoice": cPaymentInvoice,
    "CPayment_customerID": cPaymentCustomerId,
    "CPayment_TransactionType": cPaymentTransactionType,
    "CPayment_amount": cPaymentAmount,
    "out_amount": outAmount,
    "CPayment_Paymentby": cPaymentPaymentby,
    "account_id": accountId,
    "CPayment_notes": cPaymentNotes,
    "CPayment_brunchid": cPaymentBrunchid,
    "CPayment_previous_due": cPaymentPreviousDue,
    "CPayment_Addby": cPaymentAddby,
    "CPayment_AddDAte": cPaymentAddDAte,
    "CPayment_status": cPaymentStatus,
    "update_by": updateBy,
    "CPayment_UpdateDAte": cPaymentUpdateDAte,
    "Customer_Code": customerCode,
    "Customer_Name": customerName,
    "Customer_Mobile": customerMobile,
    "Customer_Type": customerType,
    "account_name": accountName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "transaction_type": transactionType,
    "payment_by": paymentBy,
  };
}
