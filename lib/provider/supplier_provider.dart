import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/administation_module/model/supplier_model.dart';

class SupplierProvider extends ChangeNotifier {
  static bool isLoading=false;
  List<SupplierModel> supplierList = [];

  getSupplierList() async {
    supplierList = await ApiService.fetchSupplierList();
    supplierList.insert(0, SupplierModel(displayName: "General Supplier"));
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('offff');
      isLoading=false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isLoading=false;
    notifyListeners();
  }
}
