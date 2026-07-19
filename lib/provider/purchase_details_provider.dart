import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_details_model.dart';

class PurchaseDetailsProvider extends ChangeNotifier {

  static bool isSearchTypeChange = false;

  List<PurchaseDetailsModel> getPurchaseDetailslist = [];
  getPurchaseDetails(
      BuildContext context,
      String? categoryId,
      String? dateFrom,
      String? dateTo,
      String? productId,
      String? supplierId,
      ) async {
    getPurchaseDetailslist = await ApiService.fetchPurchaseDetails(context,categoryId,dateFrom,dateTo,productId,supplierId);
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