import 'dart:convert';

class BusinessMonitorModel {
  final List<TopCustomer> topCustomers;
  final List<TopProduct> topProducts;
  final List<TopPaidCustomer> topPaidCustomer;

  BusinessMonitorModel({
    required this.topCustomers,
    required this.topProducts,
    required this.topPaidCustomer,
  });

  factory BusinessMonitorModel.fromJson(String str) => BusinessMonitorModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BusinessMonitorModel.fromMap(Map<String, dynamic> json) => BusinessMonitorModel(
    topCustomers: List<TopCustomer>.from(json["topCustomers"].map((x) => TopCustomer.fromMap(x))),
    topProducts: List<TopProduct>.from(json["topProducts"].map((x) => TopProduct.fromMap(x))),
    topPaidCustomer: List<TopPaidCustomer>.from(json["topPaidCustomer"].map((x) => TopPaidCustomer.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "topCustomers": List<dynamic>.from(topCustomers.map((x) => x.toMap())),
    "topProducts": List<dynamic>.from(topProducts.map((x) => x.toMap())),
    "topPaidCustomer": List<dynamic>.from(topPaidCustomer.map((x) => x.toMap())),
  };
}

class TopCustomer {
  final String customerName;
  final String amount;

  TopCustomer({
    required this.customerName,
    required this.amount,
  });

  factory TopCustomer.fromJson(String str) => TopCustomer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopCustomer.fromMap(Map<String, dynamic> json) => TopCustomer(
    customerName: json["customer_name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toMap() => {
    "customer_name": customerName,
    "amount": amount,
  };
}

class TopPaidCustomer {
  final String customerId;
  final String customerName;
  final String salesPaid;
  final String partialPayment;
  final String total;

  TopPaidCustomer({
    required this.customerId,
    required this.customerName,
    required this.salesPaid,
    required this.partialPayment,
    required this.total,
  });

  factory TopPaidCustomer.fromJson(String str) => TopPaidCustomer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopPaidCustomer.fromMap(Map<String, dynamic> json) => TopPaidCustomer(
    customerId: json["customer_id"],
    customerName: json["customer_name"],
    salesPaid: json["sales_paid"],
    partialPayment: json["partial_payment"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "customer_id": customerId,
    "customer_name": customerName,
    "sales_paid": salesPaid,
    "partial_payment": partialPayment,
    "total": total,
  };
}

class TopProduct {
  final String productName;
  final String soldQuantity;

  TopProduct({
    required this.productName,
    required this.soldQuantity,
  });

  factory TopProduct.fromJson(String str) => TopProduct.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopProduct.fromMap(Map<String, dynamic> json) => TopProduct(
    productName: json["product_name"],
    soldQuantity: json["sold_quantity"],
  );

  Map<String, dynamic> toMap() => {
    "product_name": productName,
    "sold_quantity": soldQuantity,
  };
}
