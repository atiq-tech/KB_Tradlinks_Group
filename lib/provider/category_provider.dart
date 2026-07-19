import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  getCategoryData() async {
    categoryList = await ApiService.fetchAllCategory();
    // return provideCategoryWiseStockList;
    notifyListeners();
  }
}
