import 'dart:convert';

class PurchaseDetailsModel {
  final String purchaseDetailsSlNo;
  final String purchaseMasterIdNo;
  final String productIdNo;
  final String catId;
  final String purchaseDetailsTotalQuantity;
  final String purchaseDetailsRate;
  final String purchaseCost;
  final String purchaseDetailsDiscount;
  final String purchaseDetailsTotalAmount;
  final String status;
  final dynamic addBy;
  final dynamic addTime;
  final String updateBy;
  final String updateTime;
  final String purchaseDetailsBranchId;
  final String productName;
  final String productCategoryName;
  final String purchaseMasterInvoiceNo;
  final String purchaseMasterOrderDate;
  final String supplierCode;
  final String supplierName;
  final String branchName;
  final String unitName;

  PurchaseDetailsModel({
    required this.purchaseDetailsSlNo,
    required this.purchaseMasterIdNo,
    required this.productIdNo,
    required this.catId,
    required this.purchaseDetailsTotalQuantity,
    required this.purchaseDetailsRate,
    required this.purchaseCost,
    required this.purchaseDetailsDiscount,
    required this.purchaseDetailsTotalAmount,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.purchaseDetailsBranchId,
    required this.productName,
    required this.productCategoryName,
    required this.purchaseMasterInvoiceNo,
    required this.purchaseMasterOrderDate,
    required this.supplierCode,
    required this.supplierName,
    required this.branchName,
    required this.unitName,
  });

  factory PurchaseDetailsModel.fromJson(String str) => PurchaseDetailsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PurchaseDetailsModel.fromMap(Map<String, dynamic> json) => PurchaseDetailsModel(
    purchaseDetailsSlNo: json["PurchaseDetails_SlNo"]??"",
    purchaseMasterIdNo: json["PurchaseMaster_IDNo"]??"",
    productIdNo: json["Product_IDNo"]??"",
    catId: json["cat_id"]??"",
    purchaseDetailsTotalQuantity: json["PurchaseDetails_TotalQuantity"]??"",
    purchaseDetailsRate: json["PurchaseDetails_Rate"]??"",
    purchaseCost: json["purchase_cost"]??"",
    purchaseDetailsDiscount: json["PurchaseDetails_Discount"]??"",
    purchaseDetailsTotalAmount: json["PurchaseDetails_TotalAmount"]??"",
    status: json["Status"]??"",
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"]??"",
    updateTime: json["UpdateTime"]??"",
    purchaseDetailsBranchId: json["PurchaseDetails_branchID"]??"",
    productName: json["Product_Name"]??"",
    productCategoryName: json["ProductCategory_Name"]??"",
    purchaseMasterInvoiceNo: json["PurchaseMaster_InvoiceNo"]??"",
    purchaseMasterOrderDate: json["PurchaseMaster_OrderDate"]??"",
    supplierCode: json["Supplier_Code"]??"",
    supplierName: json["Supplier_Name"]??"",
    branchName: json["Brunch_name"]??"",
    unitName: json["Unit_Name"]??"",
  );

  Map<String, dynamic> toMap() => {
    "PurchaseDetails_SlNo": purchaseDetailsSlNo,
    "PurchaseMaster_IDNo": purchaseMasterIdNo,
    "Product_IDNo": productIdNo,
    "cat_id": catId,
    "PurchaseDetails_TotalQuantity": purchaseDetailsTotalQuantity,
    "PurchaseDetails_Rate": purchaseDetailsRate,
    "purchase_cost": purchaseCost,
    "PurchaseDetails_Discount": purchaseDetailsDiscount,
    "PurchaseDetails_TotalAmount": purchaseDetailsTotalAmount,
    "Status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "PurchaseDetails_branchID": purchaseDetailsBranchId,
    "Product_Name": productName,
    "ProductCategory_Name": productCategoryName,
    "PurchaseMaster_InvoiceNo": purchaseMasterInvoiceNo,
    "PurchaseMaster_OrderDate": purchaseMasterOrderDate,
    "Supplier_Code": supplierCode,
    "Supplier_Name": supplierName,
    "Brunch_name": branchName,
    "Unit_Name": unitName,
  };
}
