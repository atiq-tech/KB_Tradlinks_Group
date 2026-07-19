import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_invoice_model.dart';
import 'package:kbtradlink/screen/sales_module/invoice/model/sales_invoice_model.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiGetSalesInvoice {
  static GetApiGetSalesInvoice(String? salesId,) async {

    String Link = "${baseUrl}api/v1/getSales";
    SalesInvoiceModel? salesInvoiceModel;

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var body = {
        "salesId": "$salesId",
      };
      print('alksdjhfkjasdf $body');
      Response response = await Dio().post(Link,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      print("getSaleslist===::===getSaleslist:${response.data}");

      return SalesInvoiceModel.fromMap(jsonDecode(response.data));

    } catch (e) {
      print("Something is wrong getSaleslist=======:$e");
    }
    return salesInvoiceModel;
  }

  static GetPurchaseInvoice(String? purchaseId,) async {

    String Link = "${baseUrl}api/v1/getPurchases";
    SalesInvoiceModel? salesInvoiceModel;

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var body = {
        "purchaseId": "$purchaseId",
      };
      print('alksdjhfkjasdf $body');
      Response response = await Dio().post(Link,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      print("getSaleslist===::===getSaleslist:${response.data}");

      return PurchaseInvoiceModel.fromMap(jsonDecode(response.data));

    } catch (e) {
      print("Something is wrong getSaleslist=======:$e");
    }
    return salesInvoiceModel;
  }
}
