import 'package:flutter/foundation.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/report_module/model/other_income_expense_model.dart';

class OtherIncomeExpenseProvider extends ChangeNotifier{
  OtherIncomeExpenseModel? allOtherIncomeExpenselist;
  getOtherIncomeExpenses( context,
      String? customer,
      String? dateFrom,
      String? dateTo,
      String? productId,) async {
    allOtherIncomeExpenselist = await ApiService.GetApiAllOtherIncomeExpense(context,customer,dateFrom,dateTo,productId);
    notifyListeners();
  }

}