import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/acount_module/model/bank_transaction_model.dart';

class BankTransactionProvider extends ChangeNotifier {

  static bool isLoading = false;
  List<BankTransactionModel> bankTransactionList = [];

  getBankTransactionList(accountId, dateFrom, dateTo, transactionType) async {
    bankTransactionList = await ApiService.fetchBankTransactionList(accountId, dateFrom, dateTo, transactionType);
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
