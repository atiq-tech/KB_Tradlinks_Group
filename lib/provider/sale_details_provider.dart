import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/sale_details_model.dart';

class SaleDetailsProvider extends ChangeNotifier {

  static bool isSearchTypeChange = false;

  List<SaleDetailsModel> getSaleDetailsList = [];
  getSaleDetails(
      BuildContext context,
      String? categoryId,
      String? dateFrom,
      String? dateTo,
      String? productId,
      ) async {
    getSaleDetailsList = await ApiService.fetchSaleDetails(context,categoryId,dateFrom,dateTo,productId);
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