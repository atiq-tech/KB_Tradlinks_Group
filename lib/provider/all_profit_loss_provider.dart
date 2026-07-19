import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/report_module/model/all_profit_loss_model.dart';

class AllProfitLossProvider extends ChangeNotifier {

  static bool isLoading = false;

  List<AllProfitLossModel> getAllProfitLosslist = [];
  getAllProfitLoss(
      String? customer,
      String? dateFrom,
      String? dateTo,
      ) async {
    getAllProfitLosslist = await ApiService.fetchAllProfitLoss(customer,dateFrom,dateTo);
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