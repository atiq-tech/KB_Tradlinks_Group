class PurchaseApiModelClass {
  String? productId;
  String? name;
  String? categoryId;
  String? categoryName;
  String? purchaseRate;
  String? salesRate;
  String? quantity;
  String? total;

  PurchaseApiModelClass({
    required this.productId,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.purchaseRate,
    required this.salesRate,
    required this.quantity,
    required this.total,
  });
}