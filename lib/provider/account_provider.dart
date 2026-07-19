
import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/acount_module/model/account_model.dart';

class AccountProvider extends ChangeNotifier {
  List<AccountModel> accountList = [];

  Future<List<AccountModel>>getAccountList() async {
    accountList = await ApiService.fetchAccountList();
    // notifyListeners();
    return accountList;
  }
}
