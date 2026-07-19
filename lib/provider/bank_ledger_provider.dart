import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/report_module/model/bank_ledger_model.dart';

class BankLedgerProvider extends ChangeNotifier {

  static bool isLoading = false;

  BankLedgerModel? bankLedgerModel;
  getBankLedger(
      String? accountId,
      String? dateFrom,
      String? dateTo
      ) async {
    bankLedgerModel = await ApiService.fetchBankLedger(accountId,dateFrom,dateTo);
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
