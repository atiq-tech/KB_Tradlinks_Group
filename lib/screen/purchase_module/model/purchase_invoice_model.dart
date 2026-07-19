import 'dart:convert';
import 'package:kbtradlink/screen/purchase_module/model/purchase_details_model.dart';

class PurchaseInvoiceModel {
  final List<PurchaseDetailsModel> purchaseDetailsModel;
  final List<PurchaseModel> purchaseModel;

  PurchaseInvoiceModel({
    required this.purchaseDetailsModel,
    required this.purchaseModel,
  });

  factory PurchaseInvoiceModel.fromJson(String str) => PurchaseInvoiceModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseInvoiceModel.fromMap(Map<String, dynamic> json) => PurchaseInvoiceModel(
    purchaseDetailsModel: List<PurchaseDetailsModel>.from(json["purchaseDetails"].map((x) => PurchaseDetailsModel.fromMap(x))),
    purchaseModel: List<PurchaseModel>.from(json["purchases"].map((x) => PurchaseModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "purchaseDetails": List<dynamic>.from(purchaseDetailsModel.map((x) => x.toMap())),
    "purchases": List<dynamic>.from(purchaseModel.map((x) => x.toMap())),
  };
}

class PurchaseModel {
  final String purchaseMasterSlNo;
  final String supplierSlNo;
  final String employeeSlNo;
  final String purchaseMasterInvoiceNo;
  final String purchaseMasterOrderDate;
  final String purchaseMasterPurchaseFor;
  final String purchaseMasterDescription;
  final String purchaseMasterTotalAmount;
  final String purchaseMasterDiscountAmount;
  final String purchaseMasterTax;
  final String purchaseMasterFreight;
  final String purchaseMasterSubTotalAmount;
  final String purchaseMasterPaidAmount;
  final String purchaseMasterDueAmount;
  final String previousDue;
  final String status;
  final String addBy;
  final String addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final String purchaseMasterBranchId;
  final String ownFreight;
  final String supplierName;
  final String supplierMobile;
  final String supplierEmail;
  final String supplierCode;
  final String supplierAddress;
  final String supplierType;

  PurchaseModel({
    required this.purchaseMasterSlNo,
    required this.supplierSlNo,
    required this.employeeSlNo,
    required this.purchaseMasterInvoiceNo,
    required this.purchaseMasterOrderDate,
    required this.purchaseMasterPurchaseFor,
    required this.purchaseMasterDescription,
    required this.purchaseMasterTotalAmount,
    required this.purchaseMasterDiscountAmount,
    required this.purchaseMasterTax,
    required this.purchaseMasterFreight,
    required this.purchaseMasterSubTotalAmount,
    required this.purchaseMasterPaidAmount,
    required this.purchaseMasterDueAmount,
    required this.previousDue,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.purchaseMasterBranchId,
    required this.ownFreight,
    required this.supplierName,
    required this.supplierMobile,
    required this.supplierEmail,
    required this.supplierCode,
    required this.supplierAddress,
    required this.supplierType,
  });

  factory PurchaseModel.fromJson(String str) => PurchaseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseModel.fromMap(Map<String, dynamic> json) => PurchaseModel(
    purchaseMasterSlNo: json["PurchaseMaster_SlNo"],
    supplierSlNo: json["Supplier_SlNo"],
    employeeSlNo: json["Employee_SlNo"],
    purchaseMasterInvoiceNo: json["PurchaseMaster_InvoiceNo"],
    purchaseMasterOrderDate: json["PurchaseMaster_OrderDate"],
    purchaseMasterPurchaseFor: json["PurchaseMaster_PurchaseFor"],
    purchaseMasterDescription: json["PurchaseMaster_Description"],
    purchaseMasterTotalAmount: json["PurchaseMaster_TotalAmount"],
    purchaseMasterDiscountAmount: json["PurchaseMaster_DiscountAmount"],
    purchaseMasterTax: json["PurchaseMaster_Tax"],
    purchaseMasterFreight: json["PurchaseMaster_Freight"],
    purchaseMasterSubTotalAmount: json["PurchaseMaster_SubTotalAmount"],
    purchaseMasterPaidAmount: json["PurchaseMaster_PaidAmount"],
    purchaseMasterDueAmount: json["PurchaseMaster_DueAmount"],
    previousDue: json["previous_due"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    purchaseMasterBranchId: json["PurchaseMaster_BranchID"],
    ownFreight: json["own_freight"],
    supplierName: json["Supplier_Name"],
    supplierMobile: json["Supplier_Mobile"],
    supplierEmail: json["Supplier_Email"],
    supplierCode: json["Supplier_Code"],
    supplierAddress: json["Supplier_Address"],
    supplierType: json["Supplier_Type"],
  );

  Map<String, dynamic> toMap() => {
    "PurchaseMaster_SlNo": purchaseMasterSlNo,
    "Supplier_SlNo": supplierSlNo,
    "Employee_SlNo": employeeSlNo,
    "PurchaseMaster_InvoiceNo": purchaseMasterInvoiceNo,
    "PurchaseMaster_OrderDate": purchaseMasterOrderDate,
    "PurchaseMaster_PurchaseFor": purchaseMasterPurchaseFor,
    "PurchaseMaster_Description": purchaseMasterDescription,
    "PurchaseMaster_TotalAmount": purchaseMasterTotalAmount,
    "PurchaseMaster_DiscountAmount": purchaseMasterDiscountAmount,
    "PurchaseMaster_Tax": purchaseMasterTax,
    "PurchaseMaster_Freight": purchaseMasterFreight,
    "PurchaseMaster_SubTotalAmount": purchaseMasterSubTotalAmount,
    "PurchaseMaster_PaidAmount": purchaseMasterPaidAmount,
    "PurchaseMaster_DueAmount": purchaseMasterDueAmount,
    "previous_due": previousDue,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "PurchaseMaster_BranchID": purchaseMasterBranchId,
    "own_freight": ownFreight,
    "Supplier_Name": supplierName,
    "Supplier_Mobile": supplierMobile,
    "Supplier_Email": supplierEmail,
    "Supplier_Code": supplierCode,
    "Supplier_Address": supplierAddress,
    "Supplier_Type": supplierType,
  };
}
