import 'dart:convert';

class SalesModel {
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
  final String customerAddress;
  final String customerType;
  final dynamic employeeName;
  final String brunchName;

  SalesModel({
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
    required this.customerAddress,
    required this.customerType,
    required this.employeeName,
    required this.brunchName,
  });

  factory SalesModel.fromJson(String str) => SalesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesModel.fromMap(Map<String, dynamic> json) => SalesModel(
    saleMasterSlNo: json["SaleMaster_SlNo"],
    saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
    salseCustomerIdNo: json["SalseCustomer_IDNo"],
    employeeId: json["employee_id"],
    saleMasterSaleDate: json["SaleMaster_SaleDate"],
    saleMasterDescription: json["SaleMaster_Description"],
    saleMasterSaleType: json["SaleMaster_SaleType"],
    paymentType: json["payment_type"],
    saleMasterTotalSaleAmount: json["SaleMaster_TotalSaleAmount"],
    saleMasterTotalDiscountAmount: json["SaleMaster_TotalDiscountAmount"],
    saleMasterTaxAmount: json["SaleMaster_TaxAmount"],
    saleMasterFreight: json["SaleMaster_Freight"],
    saleMasterSubTotalAmount: json["SaleMaster_SubTotalAmount"],
    saleMasterPaidAmount: json["SaleMaster_PaidAmount"],
    saleMasterDueAmount: json["SaleMaster_DueAmount"],
    saleMasterPreviousDue: json["SaleMaster_Previous_Due"],
    status: json["Status"],
    isService: json["is_service"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    saleMasterBranchid: json["SaleMaster_branchid"],
    customerCode: json["Customer_Code"],
    customerName: json["Customer_Name"],
    customerMobile: json["Customer_Mobile"],
    customerAddress: json["Customer_Address"],
    customerType: json["Customer_Type"],
    employeeName: json["Employee_Name"],
    brunchName: json["Brunch_name"],
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
    "Customer_Address": customerAddress,
    "Customer_Type": customerType,
    "Employee_Name": employeeName,
    "Brunch_name": brunchName,
  };
}