import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/report_module/model/balance_report_model.dart';

class BalanceReportProvider extends ChangeNotifier {

  static bool isLoading = false;

  BalanceReportModel? balanceReportModel;
  getBalanceReport(String date) async {
    balanceReportModel = await ApiService.fetchGetBalanceReport(date);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
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