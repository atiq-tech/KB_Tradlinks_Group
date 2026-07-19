import 'dart:convert';

class SupplierPaymentModel {
  final String sPaymentId;
  final String sPaymentDate;
  final String sPaymentInvoice;
  final String sPaymentCustomerId;
  final String sPaymentTransactionType;
  final String sPaymentAmount;
  final String sPaymentPaymentby;
  final String accountId;
  final String sPaymentNotes;
  final String sPaymentBrunchid;
  final String sPaymentStatus;
  final String sPaymentAddby;
  final String sPaymentAddDAte;
  final dynamic updateBy;
  final dynamic sPaymentUpdateDAte;
  final String supplierCode;
  final String supplierName;
  final String supplierMobile;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String transactionType;
  final String paymentBy;

  SupplierPaymentModel({
    required this.sPaymentId,
    required this.sPaymentDate,
    required this.sPaymentInvoice,
    required this.sPaymentCustomerId,
    required this.sPaymentTransactionType,
    required this.sPaymentAmount,
    required this.sPaymentPaymentby,
    required this.accountId,
    required this.sPaymentNotes,
    required this.sPaymentBrunchid,
    required this.sPaymentStatus,
    required this.sPaymentAddby,
    required this.sPaymentAddDAte,
    required this.updateBy,
    required this.sPaymentUpdateDAte,
    required this.supplierCode,
    required this.supplierName,
    required this.supplierMobile,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.transactionType,
    required this.paymentBy,
  });

  factory SupplierPaymentModel.fromJson(String str) => SupplierPaymentModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SupplierPaymentModel.fromMap(Map<String, dynamic> json) => SupplierPaymentModel(
    sPaymentId: json["SPayment_id"]??"",
    sPaymentDate: json["SPayment_date"]??"",
    sPaymentInvoice: json["SPayment_invoice"]??"",
    sPaymentCustomerId: json["SPayment_customerID"]??"",
    sPaymentTransactionType: json["SPayment_TransactionType"]??"",
    sPaymentAmount: json["SPayment_amount"]??"",
    sPaymentPaymentby: json["SPayment_Paymentby"]??"",
    accountId: json["account_id"]??"",
    sPaymentNotes: json["SPayment_notes"]??"",
    sPaymentBrunchid: json["SPayment_brunchid"]??"",
    sPaymentStatus: json["SPayment_status"]??"",
    sPaymentAddby: json["SPayment_Addby"]??"",
    sPaymentAddDAte: json["SPayment_AddDAte"]??"",
    updateBy: json["update_by"],
    sPaymentUpdateDAte: json["SPayment_UpdateDAte"],
    supplierCode: json["Supplier_Code"]??"",
    supplierName: json["Supplier_Name"]??"",
    supplierMobile: json["Supplier_Mobile"]??"",
    accountName: json["account_name"]??"",
    accountNumber: json["account_number"]??"",
    bankName: json["bank_name"]??"",
    transactionType: json["transaction_type"]??"",
    paymentBy: json["payment_by"]??"",
  );

  Map<String, dynamic> toMap() => {
    "SPayment_id": sPaymentId,
    "SPayment_date": sPaymentDate,
    "SPayment_invoice": sPaymentInvoice,
    "SPayment_customerID": sPaymentCustomerId,
    "SPayment_TransactionType": sPaymentTransactionType,
    "SPayment_amount": sPaymentAmount,
    "SPayment_Paymentby": sPaymentPaymentby,
    "account_id": accountId,
    "SPayment_notes": sPaymentNotes,
    "SPayment_brunchid": sPaymentBrunchid,
    "SPayment_status": sPaymentStatus,
    "SPayment_Addby": sPaymentAddby,
    "SPayment_AddDAte": sPaymentAddDAte,
    "update_by": updateBy,
    "SPayment_UpdateDAte": sPaymentUpdateDAte,
    "Supplier_Code": supplierCode,
    "Supplier_Name": supplierName,
    "Supplier_Mobile": supplierMobile,
    "account_name": accountName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "transaction_type": transactionType,
    "payment_by": paymentBy,
  };
}
