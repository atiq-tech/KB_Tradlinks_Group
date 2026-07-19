import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/warehouse_wise_stock_model.dart';

class WarehouseWiseStockProvider extends ChangeNotifier {

  static bool isLoading = false;

  List<WarehouseWiseStockModel> getWarehouseWiseStockList = [];
  getWarehouseWiseStock(String? branchId,) async {
    getWarehouseWiseStockList = await ApiService.fetchBranchWiseStock(branchId);
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