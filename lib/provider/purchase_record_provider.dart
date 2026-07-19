import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_record_model.dart';

class PurchaseRecordProvider extends ChangeNotifier {

  static bool isSearchTypeChange = false;

  List<PurchaseRecordModel> getPurchaseRecordlist = [];
  getPurchaseRecord(
      BuildContext context,
      String? dateFrom,
      String? dateTo,
      String? userFullName,
      ) async {
    getPurchaseRecordlist = await ApiService.fetchPurchaseRecord(context,dateFrom,dateTo,userFullName);
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