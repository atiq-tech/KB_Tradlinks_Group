import 'dart:convert';

class AllProfitLossModel {
  final String saleMasterSlNo;
  final String saleMasterInvoiceNo;
  final String salseCustomerIdNo;
  final dynamic employeeId;
  final String saleMasterSaleDate;
  final String saleMasterDescription;
  final String saleMasterSaleType;
  final String paymentType;
  final String saleMasterTotalSaleAmount;
  final String saleMasterTotalDiscountAmount;
  final String saleMasterTaxAmount;
  final String saleMasterFreight;
  final String saleMasterSubTotalAmount;
  final String saleMasterPaidAmount;
  final String saleMasterDueAmount;
  final String saleMasterPreviousDue;
  final String status;
  final String isService;
  final String addBy;
  final String addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final String saleMasterBranchid;
  final String customerCode;
  final String customerName;
  final String customerMobile;
  final List<SaleDetail> saleDetails;

  AllProfitLossModel({
    required this.saleMasterSlNo,
    required this.saleMasterInvoiceNo,
    required this.salseCustomerIdNo,
    required this.employeeId,
    required this.saleMasterSaleDate,
    required this.saleMasterDescription,
    required this.saleMasterSaleType,
    required this.paymentType,
    required this.saleMasterTotalSaleAmount,
    required this.saleMasterTotalDiscountAmount,
    required this.saleMasterTaxAmount,
    required this.saleMasterFreight,
    required this.saleMasterSubTotalAmount,
    required this.saleMasterPaidAmount,
    required this.saleMasterDueAmount,
    required this.saleMasterPreviousDue,
    required this.status,
    required this.isService,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.saleMasterBranchid,
    required this.customerCode,
    required this.customerName,
    required this.customerMobile,
    required this.saleDetails,
  });

  factory AllProfitLossModel.fromJson(String str) => AllProfitLossModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AllProfitLossModel.fromMap(Map<String, dynamic> json) => AllProfitLossModel(
    saleMasterSlNo: json["SaleMaster_SlNo"]??"",
    saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"]??"",
    salseCustomerIdNo: json["SalseCustomer_IDNo"]??"",
    employeeId: json["employee_id"],
    saleMasterSaleDate: json["SaleMaster_SaleDate"]??"",
    saleMasterDescription: json["SaleMaster_Description"]??"",
    saleMasterSaleType: json["SaleMaster_SaleType"]??"",
    paymentType: json["payment_type"]??"",
    saleMasterTotalSaleAmount: json["SaleMaster_TotalSaleAmount"]??"",
    saleMasterTotalDiscountAmount: json["SaleMaster_TotalDiscountAmount"]??"",
    saleMasterTaxAmount: json["SaleMaster_TaxAmount"]??"",
    saleMasterFreight: json["SaleMaster_Freight"]??"",
    saleMasterSubTotalAmount: json["SaleMaster_SubTotalAmount"]??"",
    saleMasterPaidAmount: json["SaleMaster_PaidAmount"]??"",
    saleMasterDueAmount: json["SaleMaster_DueAmount"]??"",
    saleMasterPreviousDue: json["SaleMaster_Previous_Due"]??"",
    status: json["Status"]??"",
    isService: json["is_service"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    saleMasterBranchid: json["SaleMaster_branchid"]??"",
    customerCode: json["Customer_Code"]??"",
    customerName: json["Customer_Name"]??"",
    customerMobile: json["Customer_Mobile"]??"",
    saleDetails: json["saleDetails"] ==null? [] : List<SaleDetail>.from(json["saleDetails"].map((x) => SaleDetail.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "SaleMaster_SlNo": saleMasterSlNo,
    "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
    "SalseCustomer_IDNo": salseCustomerIdNo,
    "employee_id": employeeId,
    "SaleMaster_SaleDate": saleMasterSaleDate,
    "SaleMaster_Description": saleMasterDescription,
    "SaleMaster_SaleType": saleMasterSaleType,
    "payment_type": paymentType,
    "SaleMaster_TotalSaleAmount": saleMasterTotalSaleAmount,
    "SaleMaster_TotalDiscountAmount": saleMasterTotalDiscountAmount,
    "SaleMaster_TaxAmount": saleMasterTaxAmount,
    "SaleMaster_Freight": saleMasterFreight,
    "SaleMaster_SubTotalAmount": saleMasterSubTotalAmount,
    "SaleMaster_PaidAmount": saleMasterPaidAmount,
    "SaleMaster_DueAmount": saleMasterDueAmount,
    "SaleMaster_Previous_Due": saleMasterPreviousDue,
    "Status": status,
    "is_service": isService,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "SaleMaster_branchid": saleMasterBranchid,
    "Customer_Code": customerCode,
    "Customer_Name": customerName,
    "Customer_Mobile": customerMobile,
    "saleDetails": List<dynamic>.from(saleDetails.map((x) => x.toMap())),
  };
}

class SaleDetail {
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
  final String purchasedAmount;
  final String profitLoss;

  SaleDetail({
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
    required this.purchasedAmount,
    required this.profitLoss,
  });

  factory SaleDetail.fromJson(String str) => SaleDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleDetail.fromMap(Map<String, dynamic> json) => SaleDetail(
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
    purchasedAmount: json["purchased_amount"]??"",
    profitLoss: json["profit_loss"]??"",
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
    "purchased_amount": purchasedAmount,
    "profit_loss": profitLoss,
  };
}
