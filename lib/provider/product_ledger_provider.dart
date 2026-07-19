import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/administation_module/model/product_ledger_model.dart';

class ProductLedgerProvider extends ChangeNotifier {

  static bool isLoading = false;

  List<ProductLedgerModel> productLedgerList = [];
  getProductLedger(
      String? productId,
      String? dateFrom,
      String? dateTo
      ) async {
    productLedgerList = await ApiService.fetchProductLedger(productId,dateFrom,dateTo);
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
