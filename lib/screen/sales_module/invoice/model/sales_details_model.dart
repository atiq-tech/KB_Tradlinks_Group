import 'dart:convert';

class SaleDetailModel {
    final String saleDetailsSlNo;
    final String saleMasterIdNo;
    final String productIdNo;
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
    final String productName;
    final String productCategoryName;
    final String unitName;

    SaleDetailModel({
        required this.saleDetailsSlNo,
        required this.saleMasterIdNo,
        required this.productIdNo,
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
        required this.productName,
        required this.productCategoryName,
        required this.unitName,
    });

    factory SaleDetailModel.fromJson(String str) => SaleDetailModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SaleDetailModel.fromMap(Map<String, dynamic> json) => SaleDetailModel(
        saleDetailsSlNo: json["SaleDetails_SlNo"],
        saleMasterIdNo: json["SaleMaster_IDNo"],
        productIdNo: json["Product_IDNo"],
        saleDetailsTotalQuantity: json["SaleDetails_TotalQuantity"],
        purchaseRate: json["Purchase_Rate"],
        saleDetailsRate: json["SaleDetails_Rate"],
        saleDetailsDiscount: json["SaleDetails_Discount"],
        discountAmount: json["Discount_amount"],
        saleDetailsTax: json["SaleDetails_Tax"],
        saleDetailsTotalAmount: json["SaleDetails_TotalAmount"],
        status: json["Status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        saleDetailsBranchId: json["SaleDetails_BranchId"],
        productName: json["Product_Name"],
        productCategoryName: json["ProductCategory_Name"],
        unitName: json["Unit_Name"],
    );

    Map<String, dynamic> toMap() => {
        "SaleDetails_SlNo": saleDetailsSlNo,
        "SaleMaster_IDNo": saleMasterIdNo,
        "Product_IDNo": productIdNo,
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
        "Product_Name": productName,
        "ProductCategory_Name": productCategoryName,
        "Unit_Name": unitName,
    };
}