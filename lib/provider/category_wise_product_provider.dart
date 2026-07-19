import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';

class CategoryWiseProductProvider extends ChangeNotifier {
///////////Get User Wise Pruchase All////////////////// eita
  static bool isCustomerTypeChange = false;
  List<ProductModel> categoryWiseProductList = [];
  getCategoryWiseProduct({String? isService, String? categoryId, String? branchId}) async {
    categoryWiseProductList = await ApiService.fetchCategoryWiseProduct(isService, categoryId, branchId);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('offff');
      isCustomerTypeChange = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isCustomerTypeChange = true;
    notifyListeners();
  }
}
