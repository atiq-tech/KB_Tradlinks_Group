import 'dart:convert';

class SaleDetailsModel {
  final String saleDetailsSlNo;
  final String saleMasterIdNo;
  final String productIdNo;
  final String catId;
  final String saleDetailsTotalQuantity;
  final String purchaseRate;
  final String saleDetailsRate;
  final String saleDetailsDiscount;
  final dynamic discountAmount;
  final String saleDetailsTax;
  final String saleDetailsTotalAmount;
  final String status;
  final String addBy;
  final String addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final String saleDetailsBranchId;
  final String productCode;
  final String productName;
  final String productCategoryName;
  final String unitName;
  final String saleMasterInvoiceNo;
  final String saleMasterSaleDate;
  final String customerCode;
  final String customerName;

  SaleDetailsModel({
    required this.saleDetailsSlNo,
    required this.saleMasterIdNo,
    required this.productIdNo,
    required this.catId,
    required this.saleDetailsTotalQuantity,
    required this.purchaseRate,
    required this.saleDetailsRate,
    required this.saleDetailsDiscount,
    required this.discountAmount,
    required this.saleDetailsTax,
    required this.saleDetailsTotalAmount,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.saleDetailsBranchId,
    required this.productCode,
    required this.productName,
    required this.productCategoryName,
    required this.unitName,
    required this.saleMasterInvoiceNo,
    required this.saleMasterSaleDate,
    required this.customerCode,
    required this.customerName,
  });

  factory SaleDetailsModel.fromJson(String str) => SaleDetailsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleDetailsModel.fromMap(Map<String, dynamic> json) => SaleDetailsModel(
    saleDetailsSlNo: json["SaleDetails_SlNo"]??"",
    saleMasterIdNo: json["SaleMaster_IDNo"]??"",
    productIdNo: json["Product_IDNo"]??"",
    catId: json["cat_id"]??"",
    saleDetailsTotalQuantity: json["SaleDetails_TotalQuantity"]??"",
    purchaseRate: json["Purchase_Rate"]??"",
    saleDetailsRate: json["SaleDetails_Rate"]??"",
    saleDetailsDiscount: json["SaleDetails_Discount"]??"",
    discountAmount: json["Discount_amount"],
    saleDetailsTax: json["SaleDetails_Tax"]??"",
    saleDetailsTotalAmount: json["SaleDetails_TotalAmount"]??"",
    status: json["Status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    saleDetailsBranchId: json["SaleDetails_BranchId"]??"",
    productCode: json["Product_Code"]??"",
    productName: json["Product_Name"]??"",
    productCategoryName: json["ProductCategory_Name"]??"",
    unitName: json["Unit_Name"]??"",
    saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"]??"",
    saleMasterSaleDate: json["SaleMaster_SaleDate"],
    customerCode: json["Customer_Code"]??"",
    customerName: json["Customer_Name"]??"",
  );

  Map<String, dynamic> toMap() => {
    "SaleDetails_SlNo": saleDetailsSlNo,
    "SaleMaster_IDNo": saleMasterIdNo,
    "Product_IDNo": productIdNo,
    "cat_id": catId,
    "SaleDetails_TotalQuantity": saleDetailsTotalQuantity,
    "Purchase_Rate": purchaseRate,
    "SaleDetails_Rate": saleDetailsRate,
    "SaleDetails_Discount": saleDetailsDiscount,
    "Discount_amount": discountAmount,
    "SaleDetails_Tax": saleDetailsTax,
    "SaleDetails_TotalAmount": saleDetailsTotalAmount,
    "Status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "SaleDetails_BranchId": saleDetailsBranchId,
    "Product_Code": productCode,
    "Product_Name": productName,
    "ProductCategory_Name": productCategoryName,
    "Unit_Name": unitName,
    "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
    "SaleMaster_SaleDate": saleMasterSaleDate,
    "Customer_Code": customerCode,
    "Customer_Name": customerName,
  };
}
