import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/report_module/model/profit_loss_model.dart';

class ProfitLossProductProvider extends ChangeNotifier {

  static bool isLoading = false;

  List<ProfitLossProductModel> getProfitLossProductlist = [];
  getProfitLossProduct(
      String? productId,
      String? dateFrom,
      String? dateTo,
      ) async {
    getProfitLossProductlist = await ApiService.fetchProfitLossProduct(productId,dateFrom,dateTo);
    // print('hfg ${getProfitLosslist.length}');
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