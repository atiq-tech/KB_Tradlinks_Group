import 'dart:convert';

class CategoryModel {
  final String productCategorySlNo;
  final String productCategoryName;
  final String productCategoryDescription;
  final String status;
  final String addBy;
  final String addTime;
  final String updateBy;
  final String updateTime;
  final String categoryBranchid;

  CategoryModel({
    required this.productCategorySlNo,
    required this.productCategoryName,
    required this.productCategoryDescription,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.categoryBranchid,
  });

  factory CategoryModel.fromJson(String str) => CategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
    productCategorySlNo: json["ProductCategory_SlNo"]??"",
    productCategoryName: json["ProductCategory_Name"]??"",
    productCategoryDescription: json["ProductCategory_Description"]??"",
    status: json["status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"]??"",
    updateTime: json["UpdateTime"]??"",
    categoryBranchid: json["category_branchid"]??"",
  );

  Map<String, dynamic> toMap() => {
    "ProductCategory_SlNo": productCategorySlNo,
    "ProductCategory_Name": productCategoryName,
    "ProductCategory_Description": productCategoryDescription,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "category_branchid": categoryBranchid,
  };
}
