import 'dart:convert';

class WarehouseWiseStockModel {
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
  final String selectSumCurrentQuantityAsCurrentQuantity;
  final String productName;
  final String productCode;
  final String productReOrederLevel;
  final String productPurchaseRate;
  final String stockValue;
  final String productCategoryName;
  final dynamic brandName;
  final String unitName;
  final List<Brance> brances;
  final String totalQty;

  WarehouseWiseStockModel({
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
    required this.selectSumCurrentQuantityAsCurrentQuantity,
    required this.productName,
    required this.productCode,
    required this.productReOrederLevel,
    required this.productPurchaseRate,
    required this.stockValue,
    required this.productCategoryName,
    required this.brandName,
    required this.unitName,
    required this.brances,
    required this.totalQty,
  });

  factory WarehouseWiseStockModel.fromJson(String str) => WarehouseWiseStockModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WarehouseWiseStockModel.fromMap(Map<String, dynamic> json) => WarehouseWiseStockModel(
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
    selectSumCurrentQuantityAsCurrentQuantity: json["(select sum(current_quantity) as current_quantity)"]??"",
    productName: json["Product_Name"]??"",
    productCode: json["Product_Code"]??"",
    productReOrederLevel: json["Product_ReOrederLevel"]??"",
    productPurchaseRate: json["Product_Purchase_Rate"]??"",
    stockValue: json["stock_value"]??"",
    productCategoryName: json["ProductCategory_Name"]??"",
    brandName: json["brand_name"]??"",
    unitName: json["Unit_Name"]??"",
    brances: List<Brance>.from(json["brances"].map((x) => Brance.fromMap(x))),
    totalQty: json["totalQty"] is double || json["totalQty"] is int ? "${json["totalQty"]}".toString() : json["totalQty"] ?? 0,
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
    "(select sum(current_quantity) as current_quantity)": selectSumCurrentQuantityAsCurrentQuantity,
    "Product_Name": productName,
    "Product_Code": productCode,
    "Product_ReOrederLevel": productReOrederLevel,
    "Product_Purchase_Rate": productPurchaseRate,
    "stock_value": stockValue,
    "ProductCategory_Name": productCategoryName,
    "brand_name": brandName,
    "Unit_Name": unitName,
    "brances": List<dynamic>.from(brances.map((x) => x.toMap())),
    "totalQty": totalQty,
  };
}

class Brance {
  final String brunchId;
  final String brunchName;
  final String currentQuantity;

  Brance({
    required this.brunchId,
    required this.brunchName,
    required this.currentQuantity,
  });

  factory Brance.fromJson(String str) => Brance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Brance.fromMap(Map<String, dynamic> json) => Brance(
    brunchId: json["brunch_id"]??"",
    brunchName: json["Brunch_name"]??"",
    currentQuantity: json["current_quantity"]??"",
  );

  Map<String, dynamic> toMap() => {
    "brunch_id": brunchId,
    "Brunch_name": brunchName,
    "current_quantity": currentQuantity,
  };
}
