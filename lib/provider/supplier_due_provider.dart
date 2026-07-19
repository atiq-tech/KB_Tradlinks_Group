import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/purchase_module/model/supplier_due_model.dart';

class SupplierDueProvider extends ChangeNotifier {

  static bool isSupplierTypeChange = false;

  List<SupplierDueModel> getSupplierDuelist = [];
  getSupplierDue(
      BuildContext context,
      String? supplierId,
      ) async {
    getSupplierDuelist = await ApiService.fetchSupplierDue(context,supplierId);
    off();
    notifyListeners();
  }

  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('offff');
      isSupplierTypeChange = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isSupplierTypeChange = true;
    notifyListeners();
  }
}