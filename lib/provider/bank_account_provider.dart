import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/acount_module/model/bank_account_model.dart';

class BankAccountProvider extends ChangeNotifier {

  List<BankAccountModel> bankAccountList = [];
  Future<List<BankAccountModel>>getBankAccountList() async {
    bankAccountList = await ApiService.fetchBankAccountList();
    // notifyListeners();
    return bankAccountList;
  }
}
