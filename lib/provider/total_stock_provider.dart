import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/total_stock_model.dart';

class TotalStockProvider extends ChangeNotifier {

  static bool isLoading = false;
  List<TotalStockModel> getTotalStocklist = [];
  getTotalStock(
    BuildContext context,
    String? productId,
    String? categoryId,
    String? productIdb,
  ) async {
    getTotalStocklist = await ApiService.fetchTotalStock(context, productId, categoryId, productIdb);
    off();
    notifyListeners();
  }

  off() {
    print('offff');
    isLoading = false;
    notifyListeners();
  }

  on() {
    print('onnn');
    isLoading = true;
    notifyListeners();
  }
}
