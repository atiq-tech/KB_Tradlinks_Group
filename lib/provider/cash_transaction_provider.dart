import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/acount_module/model/cash_transaction_model.dart';

class CashTransactionProvider extends ChangeNotifier {
  static bool isLoading = false;

  List<CashTransactionModel> cashTransactionList = [];
   getCashTransactionList(
       String? accountId,
       String? dateFrom,
       String? dateTo,
       String? transactionType,
       ) async {
     cashTransactionList = await ApiService.fetchCashTransactionList(accountId,dateFrom,dateTo,transactionType);
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
