import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/acount_module/model/supplier_payment_model.dart';

class SupplierPaymentProvider extends ChangeNotifier {

  static bool isLoading = false;

  List<SupplierPaymentModel> supplierPaymentList = [];
  getAllSupplierPayment(
      String? dateFrom, String? dateTo
      ) async {
    supplierPaymentList = await ApiService.fetchAllSupplierPayment(dateFrom,dateTo);
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
