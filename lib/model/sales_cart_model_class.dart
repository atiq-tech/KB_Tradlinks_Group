class SalesApiModelClass {
  String? productId;
  String? categoryName;
  String? name;
  String? salesRate;
  String? vat;
  String? quantity;
  String? total;
  String? purchaseRate;

  SalesApiModelClass({
    required this.productId,
    required this.categoryName,
    required this.name,
    required this.salesRate,
    required this.vat,
    required this.quantity,
    required this.total,
    required this.purchaseRate,
  });
}
// Material Purchase
class MaterialPurchaseModelClass {
  String? Mate_productId;
  String? categoryName;
  String? name;
  //String? salesRate;
  String? vat;
  String? quantity;
  String? total;
  String? purchaseRate;

  MaterialPurchaseModelClass({
    required this.Mate_productId,
    required this.categoryName,
    required this.name,
    //required this.salesRate,
    required this.vat,
    required this.quantity,
    required this.total,
    required this.purchaseRate,
  });
}
