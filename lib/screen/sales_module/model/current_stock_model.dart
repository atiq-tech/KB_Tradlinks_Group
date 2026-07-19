import 'dart:convert';

class CurrentStockModel {
  final String inventoryId;
  final String productId;
  final String catId;
  final String purchaseQuantity;
  final String purchaseReturnQuantity;
  final String salesQuantity;
  final String salesReturnQuantity;
  final String damageQuantity;
  final String transferFromQuantity;
  final String transferToQuantity;
  final String branchId;
  final String currentQuantity;
  final String productName;
  final String productCode;
  final String productReOrederLevel;
  final String stockValue;
  final String productCategoryName;
  final dynamic brandName;
  final String unitName;
  final String brunchName;
  final String productPurchaseRate;

  CurrentStockModel({
    required this.inventoryId,
    required this.productId,
    required this.catId,
    required this.purchaseQuantity,
    required this.purchaseReturnQuantity,
    required this.salesQuantity,
    required this.salesReturnQuantity,
    required this.damageQuantity,
    required this.transferFromQuantity,
    required this.transferToQuantity,
    required this.branchId,
    required this.currentQuantity,
    required this.productName,
    required this.productCode,
    required this.productReOrederLevel,
    required this.stockValue,
    required this.productCategoryName,
    required this.brandName,
    required this.unitName,
    required this.brunchName,
    required this.productPurchaseRate,
  });

  factory CurrentStockModel.fromJson(String str) => CurrentStockModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CurrentStockModel.fromMap(Map<String, dynamic> json) => CurrentStockModel(
    inventoryId: json["inventory_id"]??"",
    productId: json["product_id"]??"",
    catId: json["cat_id"]??"",
    purchaseQuantity: json["purchase_quantity"]??"",
    purchaseReturnQuantity: json["purchase_return_quantity"]??"",
    salesQuantity: json["sales_quantity"]??"",
    salesReturnQuantity: json["sales_return_quantity"]??"",
    damageQuantity: json["damage_quantity"]??"",
    transferFromQuantity: json["transfer_from_quantity"]??"",
    transferToQuantity: json["transfer_to_quantity"]??"",
    branchId: json["branch_id"]??"",
    currentQuantity: json["current_quantity"]??"",
    productName: json["Product_Name"]??"",
    productCode: json["Product_Code"]??"",
    productReOrederLevel: json["Product_ReOrederLevel"]??"",
    stockValue: json["stock_value"]??"",
    productCategoryName: json["ProductCategory_Name"]??"",
    brandName: json["brand_name"],
    unitName: json["Unit_Name"]??"",
    brunchName: json["Brunch_name"]??"",
    productPurchaseRate: json["Product_Purchase_Rate"]??"",
  );

  Map<String, dynamic> toMap() => {
    "inventory_id": inventoryId,
    "product_id": productId,
    "cat_id": catId,
    "purchase_quantity": purchaseQuantity,
    "purchase_return_quantity": purchaseReturnQuantity,
    "sales_quantity": salesQuantity,
    "sales_return_quantity": salesReturnQuantity,
    "damage_quantity": damageQuantity,
    "transfer_from_quantity": transferFromQuantity,
    "transfer_to_quantity": transferToQuantity,
    "branch_id": branchId,
    "current_quantity": currentQuantity,
    "Product_Name": productName,
    "Product_Code": productCode,
    "Product_ReOrederLevel": productReOrederLevel,
    "stock_value": stockValue,
    "ProductCategory_Name": productCategoryName,
    "brand_name": brandName,
    "Unit_Name": unitName,
    "Brunch_name": brunchName,
    "Product_Purchase_Rate": productPurchaseRate,
  };
}
