import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_record_model.dart';

class GetPurchasesProvider extends ChangeNotifier {

  static bool isSearchTypeChange = false;

  List<PurchaseRecordModel> getPurchaseslist = [];
  getGetPurchases(
      BuildContext context,
      String? dateFrom,
      String? dateTo,
      String? userFullName,
      ) async {
    getPurchaseslist = await ApiService.fetchGetPurchases(context,dateFrom,dateTo,userFullName);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('offff');
      isSearchTypeChange = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isSearchTypeChange = true;
    notifyListeners();
  }
}