import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';

class AllProductProvider extends ChangeNotifier {
static bool isLoading=false;
  List<ProductModel> productList = [];
  getAllProduct() async {
    productList = await ApiService.fetchAllProduct();
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('offff');
      isLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isLoading = true;
    notifyListeners();
  }
}
