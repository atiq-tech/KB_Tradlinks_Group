import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/acount_module/model/cash_view_model/cashview_model.dart';

class CashViewProvider extends ChangeNotifier {
  CashViewModel? cashViewModel;
  Future<CashViewModel?>getCashView(
      BuildContext context,
      ) async {
   return cashViewModel = await ApiService.fetchCashView(context);
    //notifyListeners();
  }
}
