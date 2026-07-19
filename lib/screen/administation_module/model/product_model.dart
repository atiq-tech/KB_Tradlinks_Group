import 'dart:convert';

class ProductModel {
  final String productSlNo;
  final String productCode;
  final String productName;
  final String productCategoryId;
  final String color;
  final String brand;
  final String size;
  final String vat;
  final String productReOrederLevel;
  final String productPurchaseRate;
  final String productSellingPrice;
  final String productMinimumSellingPrice;
  final String productWholesaleRate;
  final String oneCartunEqual;
  final String isService;
  final String unitId;
  final String status;
  final String addBy;
  final String addTime;
  final String updateBy;
  final String updateTime;
  final String productBranchid;
  final String displayText;
  final String productCategoryName;
  final dynamic brandName;
  final String unitName;

  ProductModel({
    required this.productSlNo,
    required this.productCode,
    required this.productName,
    required this.productCategoryId,
    required this.color,
    required this.brand,
    required this.size,
    required this.vat,
    required this.productReOrederLevel,
    required this.productPurchaseRate,
    required this.productSellingPrice,
    required this.productMinimumSellingPrice,
    required this.productWholesaleRate,
    required this.oneCartunEqual,
    required this.isService,
    required this.unitId,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.productBranchid,
    required this.displayText,
    required this.productCategoryName,
    required this.brandName,
    required this.unitName,
  });

  factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
    productSlNo: json["Product_SlNo"]??"",
    productCode: json["Product_Code"]??"",
    productName: json["Product_Name"]??"",
    productCategoryId: json["ProductCategory_ID"]??"",
    color: json["color"]??"",
    brand: json["brand"]??"",
    size: json["size"]??"",
    vat: json["vat"]??"",
    productReOrederLevel: json["Product_ReOrederLevel"]??"",
    productPurchaseRate: json["Product_Purchase_Rate"]??"",
    productSellingPrice: json["Product_SellingPrice"]??"",
    productMinimumSellingPrice: json["Product_MinimumSellingPrice"]??"",
    productWholesaleRate: json["Product_WholesaleRate"]??"",
    oneCartunEqual: json["one_cartun_equal"]??"",
    isService: json["is_service"]??"",
    unitId: json["Unit_ID"]??"",
    status: json["status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"]??"",
    updateTime: json["UpdateTime"]??"",
    productBranchid: json["Product_branchid"]??"",
    displayText: json["display_text"]??"",
    productCategoryName: json["ProductCategory_Name"]??"",
    brandName: json["brand_name"],
    unitName: json["Unit_Name"]??"",
  );

  Map<String, dynamic> toMap() => {
    "Product_SlNo": productSlNo,
    "Product_Code": productCode,
    "Product_Name": productName,
    "ProductCategory_ID": productCategoryId,
    "color": color,
    "brand": brand,
    "size": size,
    "vat": vat,
    "Product_ReOrederLevel": productReOrederLevel,
    "Product_Purchase_Rate": productPurchaseRate,
    "Product_SellingPrice": productSellingPrice,
    "Product_MinimumSellingPrice": productMinimumSellingPrice,
    "Product_WholesaleRate": productWholesaleRate,
    "one_cartun_equal": oneCartunEqual,
    "is_service": isService,
    "Unit_ID": unitId,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "Product_branchid": productBranchid,
    "display_text": displayText,
    "ProductCategory_Name": productCategoryName,
    "brand_name": brandName,
    "Unit_Name": unitName,
  };
}
