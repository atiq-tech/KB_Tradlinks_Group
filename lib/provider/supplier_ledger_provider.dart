import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/purchase_module/model/supplier_ledger_model.dart';

class SupplierLedgerProvider extends ChangeNotifier {
  List<SupplierLedgerModel> supplierLedgerList = [];
  static bool isLoading = false;

  getSupplierLedgerList(BuildContext context,
      {String? supplierId,
        String? dateFrom,
        String? dateTo,}) async {
    supplierLedgerList = await ApiService.fetchSupplierLedger(context, supplierId,dateFrom,dateTo);
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