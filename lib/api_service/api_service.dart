import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kbtradlink/model/home_topdata_model.dart';
import 'package:kbtradlink/screen/acount_module/model/account_model.dart';
import 'package:kbtradlink/screen/acount_module/model/bank_account_model.dart';
import 'package:kbtradlink/screen/acount_module/model/bank_transaction_model.dart';
import 'package:kbtradlink/screen/acount_module/model/cash_transaction_model.dart';
import 'package:kbtradlink/screen/acount_module/model/cash_view_model/cashview_model.dart';
import 'package:kbtradlink/screen/acount_module/model/customer_payment_model.dart';
import 'package:kbtradlink/screen/acount_module/model/supplier_payment_model.dart';
import 'package:kbtradlink/screen/administation_module/model/product_ledger_model.dart';
import 'package:kbtradlink/screen/administation_module/model/unit_model.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_details_model.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_record_model.dart';
import 'package:kbtradlink/screen/report_module/model/all_profit_loss_model.dart';
import 'package:kbtradlink/screen/report_module/model/balance_report_model.dart';
import 'package:kbtradlink/screen/report_module/model/bank_ledger_model.dart';
import 'package:kbtradlink/screen/report_module/model/busniess_monitor_model.dart';
import 'package:kbtradlink/screen/report_module/model/customer_ledger_model.dart';
import 'package:kbtradlink/screen/purchase_module/model/supplier_due_model.dart';
import 'package:kbtradlink/screen/purchase_module/model/supplier_ledger_model.dart';
import 'package:kbtradlink/screen/report_module/model/other_income_expense_model.dart';
import 'package:kbtradlink/screen/report_module/model/profit_loss_model.dart';
import 'package:kbtradlink/screen/sales_module/model/branch_model.dart';
import 'package:kbtradlink/screen/sales_module/model/category_model.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';
import 'package:kbtradlink/screen/sales_module/model/current_stock_model.dart';
import 'package:kbtradlink/screen/sales_module/model/customer_due_model.dart';
import 'package:kbtradlink/screen/sales_module/model/distric_model.dart';
import 'package:kbtradlink/screen/sales_module/model/employee_model.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';
import 'package:kbtradlink/screen/administation_module/model/supplier_model.dart';
import 'package:kbtradlink/screen/sales_module/model/get_sales_model.dart';
import 'package:kbtradlink/screen/sales_module/model/sale_details_model.dart';
import 'package:kbtradlink/screen/sales_module/model/sales_record_model.dart';
import 'package:kbtradlink/screen/sales_module/model/total_stock_model.dart';
import 'package:kbtradlink/screen/sales_module/model/warehouse_wise_stock_model.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:http/http.dart'as http;

import 'package:shared_preferences/shared_preferences.dart';

class ApiService{

  //==================All Employee List=======================
  static fetchAllEmployee(String? dateFrom, String? dateTo, String? customerId,
      String? employeeId, String? productId, String? userFullName) async {

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

    String link = "${baseUrl}api/v1/getEmployees";

    // String basicAuth = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjI0IiwibmFtZSI6IkxpbmsgVXAgQXBpIiwidXNlcnR5cGUiOiJtIiwiaW1hZ2VfbmFtZSI6IjEuanBnIiwiYnJhbmNoIjoiMSJ9.v-zzAx2iYpfsyB-fna8_QHUkQGZpndgpAaYLRSSQ-8k';
    try {
      Response response = await Dio().post(link,
          data: {
            // "dateFrom": "$dateFrom", "dateTo": "$dateTo"
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "customerId": "$customerId",
            "employeeId": "$employeeId",
            "productId": "$productId",
            "userFullName": "$userFullName"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = jsonDecode(response.data);

      print("All Employee $item");

      return List.from(item).map((e) => EmployeeModel.fromMap(e)).toList();

    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================Branch List =======================
  static fetchAllBranch() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getBranches";
      Response response = await Dio().post(
          url,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('Branch List $data');
      return List.from(data["data"]).map((e) => BranchModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================Customer List=======================
  static fetchCustomerList(context, String? customerType) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getCustomers";
      Response response = await Dio().post(url,
          data: {
            "customerType": "$customerType",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('Customer List $data');
      return List.from(data).map((e) => CustomerModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================All Category API=======================
  static fetchAllCategory() async {

      SharedPreferences? sharedPreferences;
      sharedPreferences = await SharedPreferences.getInstance();

      try {
        String url = "${baseUrl}api/v1/getCategories";
        Response response = await Dio().post(url,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${sharedPreferences.getString("token")}",
            }));

        var data = jsonDecode(response.data);
        print("All Category ${data}");
        return List.from(data).map((e) => CategoryModel.fromMap(e)).toList();

      } catch (e) {
        print(e);
      }
      return null;
    }

  ////////////////////////////////////Get All Product//////////////////
  static fetchCategoryWiseProduct(String? isService, String? categoryId, String? branchId) async {
    String link = "${baseUrl}api/v1/getProducts";

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      // AllProductModelClass allProductModelClass;
      Response response = await Dio().post(link,
          data: {"stockFilter": "$isService", "catId": "$categoryId","branchId": "$branchId",},          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = jsonDecode(response.data);

      print("Category wise all Product $item");

      return List.from(item).map((e) => ProductModel.fromMap(e)).toList();

    } catch (e) {
      print(e);
    }
    return null;
  }

  ////////////////////////////////////Get All Product//////////////////
  static fetchAllProduct() async {
    String link = "${baseUrl}api/v1/getAllProducts";

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      // AllProductModelClass allProductModelClass;
      Response response = await Dio().post(link,
          // data: {"stockFilter": "$isService", "catId": "$categoryId","branchId": "$branchId",},
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = jsonDecode(response.data);

      print("All Product $item");

      return List.from(item).map((e) => ProductModel.fromMap(e)).toList();

    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================Customer List=======================
  static fetchSupplierList() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getSuppliers";
      Response response = await Dio().post(url,
          // data: {
          //   "customerType": "$customerType",
          // },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('Suppliers List $data');
      return List.from(data).map((e) => SupplierModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================District List=======================
  static fetchAllDistrict() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getDistricts";
      Response response = await Dio().post(url,
          // data: {
          //   "customerType": "$customerType",
          // },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('District List $data');
      return List.from(data).map((e) => DistrictModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================BankAccount List=======================
  static fetchBankAccountList() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getBankAccounts";
      Response response = await Dio().post(
          url,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('Bank Accounts List $data');
      return List.from(data).map((e) => BankAccountModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================All Customer Payment List=======================
  static fetchAllCustomerPayment(
      String? customerId,
      String? dateFrom,
      String? dateTo,
      String? paymentType,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    print("asdfasdfads $customerId $dateFrom $dateTo $paymentType");
    try {
      String url = "${baseUrl}api/v1/getCustomerPayments";
      Response response = await Dio().post(
          url,
          data: {
            "customerId": "$customerId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "paymentType": "$paymentType",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('All Customer Payment Accounts List $data');
      return List.from(data).map((e) => CustomerPaymentModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================All Supplier Payment List=======================
  static fetchAllSupplierPayment(
      String? dateFrom, String? dateTo
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getSupplierPayments";
      Response response = await Dio().post(
          url,
          data: {
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('All Supplier Payment Accounts List $data');
      return List.from(data).map((e) => SupplierPaymentModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================Account List=======================
  static fetchAccountList() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getAccounts";
      Response response = await Dio().post(
          url,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('Accounts List $data');
      return List.from(data).map((e) => AccountModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //================== CashTransaction List =======================
  static fetchCashTransactionList(
      String? accountId,
      String? dateFrom,
      String? dateTo,
      String? transactionType,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

    print("asdfasdfadgasds $accountId $dateFrom $dateTo $transactionType");

    try {
      String url = "${baseUrl}api/v1/getCashTransactions";
      Response response = await Dio().post(
          url,
          data: {
            "accountId": "$accountId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "transactionType": "$transactionType",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var data = jsonDecode(response.data);
      print('CashTransaction List $data');
      return List.from(data).map((e) => CashTransactionModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  // //================== AddCashTransactions List =======================
  static bool isLoading = false;

  // static fetchAddCashTransactions(
  //     BuildContext context,
  //     String? accSlid,
  //     int? inAmount,
  //     int? outAmount,
  //     String? trDescription,
  //     String? trId,
  //     int? trSlno,
  //     String? trType,
  //     String? trAccountType,
  //     String? trDate,
  //     ) async {
  //   String Link = "${baseUrl}api/v1/addCashTransaction";
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     Response response = await Dio().post(Link,
  //         data: {
  //           "Acc_SlID": "$accSlid",
  //           "In_Amount": inAmount,
  //           "Out_Amount": outAmount,
  //           "Tr_Description": "$trDescription",
  //           "Tr_Id": "$trId",
  //           "Tr_SlNo": trSlno,
  //           "Tr_Type": "$trType",
  //           "Tr_account_Type": "$trAccountType",
  //           "Tr_date": "$trDate"
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     if(data['success']==true){
  //       print("CashTransactions CashTransactions:::${data}");
  //       isLoading = false;
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.black,
  //           content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.white, fontSize: 16),))));
  //     }
  //     else{
  //       isLoading = false;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.black,
  //           content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.red, fontSize: 16),))));
  //     }
  //
  //   } catch (e) {
  //     isLoading = false;
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.black,
  //         content: Center(child: Text("${e}",style: const TextStyle(color: Colors.red, fontSize: 16),))));
  //     print("Something is wrong all Add CashTransactions list=======:$e");
  //   }
  // }

  //================== BankTransaction List =======================
  static fetchBankTransactionList(String accountId, String dateFrom, String dateTo, String transactionType) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    print("sdfgsdgsdfg $accountId $dateFrom $dateTo $transactionType");

    try {
      String url = "${baseUrl}api/v1/getBankTransactions";
      Response response = await Dio().post(
          url,
          data: {
            "accountId": accountId,
            "dateFrom": dateFrom,
            "dateTo": dateTo,
            "transactionType": transactionType,
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var data = jsonDecode(response.data);
      print('BankTransaction List $data');
      return List.from(data).map((e) => BankTransactionModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  //==================AddBankTransactions API=======================
  // static fetchAddBankTransactions(
  //     context,
  //     String? account_id,
  //     String? amount,
  //     String? note,
  //     String? transaction_date,
  //     int? transaction_id,
  //     String? transaction_type,
  //     ) async {
  //   String Link = "${baseUrl}api/v1/addBankTransaction";
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     Response response = await Dio().post(Link,
  //         data: {
  //           "account_id": "$account_id",
  //           "amount": "$amount",
  //           "note": "$note",
  //           "transaction_date": "$transaction_date",
  //           "transaction_id": "$transaction_id",
  //           "transaction_type": "$transaction_type",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     if(data['success']==true){
  //       print("CashTransactions CashTransactions:::${data}");
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.black,
  //           content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.white, fontSize: 16),))));
  //     }
  //     else{
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.black,
  //           content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.red, fontSize: 16),))));
  //     }
  //
  //     print("Add bank Transactions length is ${data}");
  //   } catch (e) {
  //     print("Something is wrong all Add bank Transactions list=======:$e");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.black,
  //         content: Center(child: Text(e.toString(),style: const TextStyle(color: Colors.red, fontSize: 16),))));
  //   }
  // }
  //==================Sales Module ==> Customer Payment Report API=======================

  static fetchCustomerLedger(
      context,
      String? customerId,
      String? dateFrom,
      String? dateTo,
      ) async {
    String apiUrl = "${baseUrl}api/v1/getCustomerLedger";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(apiUrl,
          data: {
            "customerId": "$customerId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      var box = await Hive.openBox('profile');
      box.put("preBal", data["previousBalance"]);

      return List.from(data["payments"]).map((e) => CustomerLedgerModel.fromMap(e)).toList();
    } catch (e) {
     // isCustomerPaymentLoading = false;
      print("Api: Something is wrong customerledgerList=======:$e");
    }
    return null;
  }
  //==================Sales Module ==> Customer Payment Report API=======================

  static bool isCustomerPaymentLoading = false;
  static fetchSupplierLedger(
      context,
      String? supplierId,
      String? dateFrom,
      String? dateTo,
      ) async {
    String apiUrl = "${baseUrl}api/v1/getSupplierLedger";
    print("supplierId====$supplierId=====dateFrom==$dateFrom=====dateTo====$dateTo");

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(apiUrl,
          data: {
            "supplierId": "$supplierId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      var box = await Hive.openBox('profile');
      box.put("spreBal", data["previousBalance"]);

      print('ashjkfhjkasd $data');

      return List.from(data["payments"]).map((e) => SupplierLedgerModel.fromMap(e)).toList();
    } catch (e) {
      // isCustomerPaymentLoading = false;
      print("Api: Something is wrong SupplierLedgerList=======:$e");
    }
    return null;
  }

  static fetchProductLedger(String? productId, String? dateFrom, String? dateTo,) async {

    String apiUrl = "${baseUrl}api/v1/getProductLedger";

    print("supplierId====$productId=====dateFrom==$dateFrom=====dateTo====$dateTo");

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(apiUrl,
          data: {
            "productId": "$productId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);

      print('ashjkfhjkasd $data');

      return List.from(data["ledger"]).map((e) => ProductLedgerModel.fromMap(e)).toList();
    } catch (e) {
      // isCustomerPaymentLoading = false;
      print("Api: Something is wrong SupplierLedgerList=======:$e");
    }
    return null;
  }

///getCurrentStock api
  static fetchCurrentStock(BuildContext context, String stockType) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getCurrentStock";
      Response response = await Dio().post(url,
          data: {
            "stockType":stockType
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);

      // sharedPreferences.clear();

      var jsonDataList = List.from(data["stock"]).map((e) => CurrentStockModel.fromMap(e)).toList();
      await sharedPreferences.setString('data',jsonEncode(jsonDataList));
      // print("sdgfkl jglksd ${sharedPreferences.getString('data')}");

      print('CurrentStock List $data');
      return List.from(data["stock"]).map((e) => CurrentStockModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================TotalStock List=======================
  static fetchTotalStock(BuildContext
      context,
      String? productId,
      String? categoryId,
      String? productIdb,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

    print('askdflhaksjdfh $productId $categoryId $productIdb');

    try {
      print('TotalStock productId $productId');
      print('TotalStock categoryId $categoryId');
      String url = "${baseUrl}api/v1/getTotalStock";
      Response response = await Dio().post(url,
          data: {
            "productId": "$productId",
            "categoryId": "$categoryId",
            "productIdb": "$productIdb",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('TotalStock List $data');

      return List.from(data["stock"]).map((e) => TotalStockModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================GetSales List=======================
  static fetchGetSales(BuildContext
  context,
      String? customerId,
      String? dateFrom,
      String? dateTo,
      String? employeeId,
      String? userFullName,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      print('GetSales customerId $customerId');
      print('GetSales dateFrom $dateFrom');
      print('GetSales dateTo $dateTo');
      print('GetSales employeeId $employeeId');
      print('GetSales userFullName $userFullName');
      String url = "${baseUrl}api/v1/getSales";
      Response response = await Dio().post(url,
          data: {
            "customerId": "$customerId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "employeeId": "$employeeId",
            "userFullName": "$userFullName"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('GetSales List $data');

      return List.from(data["sales"]).map((e) => GetSalesModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================SalesRecord List=======================
  static fetchSalesRecord(BuildContext
  context,
      String? customerId,
      String? dateFrom,
      String? dateTo,
      String? employeeId,
      String? userFullName,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      print('SalesRecord customerId $customerId');
      print('SalesRecord dateFrom $dateFrom');
      print('SalesRecord dateTo $dateTo');
      print('SalesRecord employeeId $employeeId');
      print('SalesRecord userFullName $userFullName');
      String url = "${baseUrl}api/v1/getSalesRecord";
      Response response = await Dio().post(url,
          data: {
            "customerId": "$customerId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "employeeId": "$employeeId",
            "userFullName": "$userFullName"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('SalesRecord List $data');

      return List.from(data).map((e) => SalesRecordModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================SaleDetails List=======================
  static fetchSaleDetails(BuildContext
  context,
      String? categoryId,
      String? dateFrom,
      String? dateTo,
      String? productId,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      print('SaleDetails categoryId $categoryId');
      print('SaleDetails dateFrom $dateFrom');
      print('SaleDetails dateTo $dateTo');
      print('SaleDetails productId $productId');
      String url = "${baseUrl}api/v1/getSaleDetails";
      Response response = await Dio().post(url,
          data: {
            "categoryId": "$categoryId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "productId": "$productId",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('SaleDetails List $data');

      return List.from(data).map((e) => SaleDetailsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================getSupplierDue List=======================
  static fetchSupplierDue(BuildContext
  context,
      String? supplierId,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      print('getSupplierDue supplierId $supplierId');

      String url = "${baseUrl}api/v1/getSupplierDue";
      Response response = await Dio().post(url,
          data: {
            "supplierId": "$supplierId",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('supplierdue List $data');

      return List.from(data).map((e) => SupplierDueModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================Cash View List=======================
  static fetchCashView(BuildContext
  context,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {

      String url = "${baseUrl}api/v1/getCashView";
      Response response = await Dio().post(url,
          // data: {
          //   "supplierId": "$supplierId",
          // },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('Cash View List $data');

      return  CashViewModel.fromMap(data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================Add Customer Payment=======================
  // static getApiAllAddCustomerPayment(
  //     context,
  //     String? cpaymentPaymentby,
  //     String? cpaymentTransactiontype,
  //     String? cpaymentAmount,
  //     String? cpaymentCustomerid,
  //     String? cpaymentDate,
  //     int? cpaymentId,
  //     String? cpaymentNotes,
  //     String? cpaymentPreviousDue,
  //     String? accountId,
  //     ) async {
  //   String Link = "${baseUrl}api/v1/addCustomerPayment";
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     Response response = await Dio().post(Link,
  //         data: {
  //           "CPayment_Paymentby": "$cpaymentPaymentby",
  //           "CPayment_TransactionType": "$cpaymentTransactiontype",
  //           "CPayment_amount": "$cpaymentAmount",
  //           "CPayment_customerID": "$cpaymentCustomerid",
  //           "CPayment_date": "$cpaymentDate",
  //           "CPayment_id":cpaymentId,
  //           "CPayment_notes": "$cpaymentNotes",
  //           "CPayment_previous_due": "$cpaymentPreviousDue",
  //           "account_id": "$accountId"
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //
  //     var data = jsonDecode(response.data);
  //     if(data['success'] == true){
  //       // isBtnClkkk = false;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.black,
  //           duration: const Duration(seconds: 1),
  //           content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.white),))));
  //     }else{
  //       // isBtnClkkk = false;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.black,
  //           duration: const Duration(seconds: 1),
  //           content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.red),))));
  //     }
  //     print("Add Customer Payment length is ${data}");
  //   } catch (e) {
  //     print("Something is wrong AAAAdd CCCCustomer PPPayment=======:$e");
  //     // isBtnClkkk = false;
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.black,
  //         duration: const Duration(seconds: 1),
  //         content: Center(child: Text(e.toString(),style: const TextStyle(color: Colors.red),))));
  //   }
  // }
  //==================addSupplierPayment=======================
  static bool isBtnClk = false;
  // static getApiAllAddSupplierPayment(
  //     context,
  //     String? spaymentPaymentby,
  //     String? spaymentTransactiontype,
  //     String? spaymentAmount,
  //     String? spaymentCustomerid,
  //     String? spaymentDate,
  //     int? spaymentId,
  //     String? spaymentNotes,
  //     String? accountId,
  //     ) async {
  //   String Link = "${baseUrl}api/v1/addSupplierPayment";
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     Response response = await Dio().post(Link,
  //         data: {
  //           "SPayment_Paymentby": "$spaymentPaymentby",
  //           "SPayment_TransactionType": "$spaymentTransactiontype",
  //           "SPayment_amount": "$spaymentAmount",
  //           "SPayment_customerID": "$spaymentCustomerid",
  //           "SPayment_date": "$spaymentDate",
  //           "SPayment_id": spaymentId,
  //           "SPayment_notes": "$spaymentNotes",
  //           "account_id": "$accountId"
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //
  //     var data = jsonDecode(response.data);
  //     if(data['success'] == true){
  //       isBtnClk = false;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.black,
  //           duration: const Duration(seconds: 1),
  //           content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.white),))));
  //     }else{
  //       isBtnClk = false;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.black,
  //           duration: const Duration(seconds: 1),
  //           content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.red),))));
  //     }
  //
  //   } catch (e) {
  //     isBtnClk = false;
  //     print("Something is wrong AAAAdd Supplier PPPayment=======:$e");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.black,
  //         duration: const Duration(seconds: 1),
  //         content: Center(child: Text(e.toString(),style: const TextStyle(color: Colors.red),))));
  //   }
  // }
  //==================getCustomerDue List=======================
  static fetchCustomerDue(String? customerId, String? customerType) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

    print('ersfgsdfgsdfg $customerId $customerType');

    try {
      String url = "${baseUrl}api/v1/getCustomerDue";
      Response response = await Dio().post(url,
          data: {
            "customerId": "$customerId",
            "customerType": "$customerType"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);

      var jsonDataList = List.from(data).map((e) => CustomerDueModel.fromMap(e)).toList();
      await sharedPreferences.setString('dueData',jsonEncode(jsonDataList));

      print('CustomerDue List $data');

      return List.from(data).map((e) => CustomerDueModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================getBranchWiseStock List=======================
  static fetchBranchWiseStock(String? branchId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final body =  {
      "branchId": "$branchId",
    };
    print('sdfgsdfgsdff $branchId $body');
    try {
      String url = "${baseUrl}api/v1/get_branch_wise_stock";
      Response response = await Dio().post(url,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode("${response.data}");
      print('WarehouseWiseStock List $data');

      return List.from(data["stock"]).map((e) => WarehouseWiseStockModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
//==============get_profit_loss List=======================
  static fetchAllProfitLoss(
      String? customer,
      String? dateFrom,
      String? dateTo,

      ) async {
    print('ProfitLossProduct $customer  $dateFrom $dateTo ');

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/get_profit_loss";
      Response response = await Dio().post(url,
          data: {
            "customer": "$customer",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode("${response.data}");
      print('Profit Loss List $data');

      return List.from(data).map((e) => AllProfitLossModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  //==================getProfitLossProduct List=======================
  static fetchProfitLossProduct(
      String? productId,
      String? dateFrom,
      String? dateTo,

      ) async {
    print('ProfitLossProduct $productId  $dateFrom $dateTo ');

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      String url = "${baseUrl}api/v1/getProfitLossProduct";
      Response response = await Dio().post(url,
          data: {
            "productId": "$productId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode("${response.data}");
      print('Profit Loss Product List $data');

      return List.from(data).map((e) => ProfitLossProductModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================getBranchWiseStock List=======================
  static fetchUnit() async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

    String url = "${baseUrl}api/v1/getUnits";
    Response response = await Dio().post(url,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));

    var data = jsonDecode(response.data);
    print('Unit List $data');

    return List.from(data).map((e) => UnitModel.fromMap(e)).toList();
  }

//==================addProduct=======================
//   static addProduct(
//       context,
//       String? productId,
//       String? productCode,
//       String? productName,
//       String? productPurchaseRate,
//       String? reorderList,
//       String? salesPrice,
//       String? productSlNo,
//       String? productWholesaleRate,
//       String? unitId,
//       String? brand,
//       bool? isService,
//       String? vat,
//       ) async {
//     String url = "${baseUrl}api/v1/addProduct";
//     SharedPreferences? sharedPreferences;
//     sharedPreferences = await SharedPreferences.getInstance();
//     try {
//       Response response = await Dio().post(url,
//           data: {
//             "ProductCategory_ID":"$productId",
//             "Product_Code":"$productCode",
//             "Product_Name":"$productName",
//             "Product_Purchase_Rate":"$productPurchaseRate",
//             "Product_ReOrederLevel":"$reorderList",
//             "Product_SellingPrice":"$salesPrice",
//             "Product_SlNo":"$productSlNo",
//             "Product_WholesaleRate":"$productWholesaleRate",
//             "Unit_ID":"$unitId",
//             "brand":"$brand",
//             "is_service":isService,
//             "vat":"$vat"
//           },
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer ${sharedPreferences.getString("token")}",
//           }));
//       print(
//           "AddProduct AddProduct AddProduct:${response.data}");
//       print("===========++++++=============");
//       print("AddProduct AddProduct AddProduct");
//       print("============+++++++++++++++=========");
//
//       var data = jsonDecode(response.data);
//       Provider.of<AllProductProvider>(context, listen: false).getAllProduct();
//       print("AddProduct AddProduct length is ${data}");
//       print("success============> ${data["success"]}");
//       print("message =================> ${data["message"]}");
//       print("productionId ================>  ${data["productionId"]}");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: const Color.fromARGB(255, 4, 108, 156),
//           duration: const Duration(seconds: 1), content: Center(child: Text("${data["message"]}"))));
//
//     } catch (e) {
//       print("Something is wrong AddProduct=======:$e");
//     }
//   }
  //==================GetPurchases List=======================
  static fetchGetPurchases(BuildContext
  context,
      String? dateFrom,
      String? dateTo,
      String? userFullName,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    print('GetPurchases dateFrom $dateFrom');
    print('GetPurchases dateTo $dateTo');
    print('GetPurchases userFullName $userFullName');
    try {
      String url = "${baseUrl}api/v1/getPurchases";
      Response response = await Dio().post(url,
          data: {
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "userFullName": "$userFullName"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var data = jsonDecode(response.data);
      print('GetSales List $data');
      return List.from(data["purchases"]).map((e) => PurchaseRecordModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  //==================GetPurchaseRecord List=======================
  static fetchPurchaseRecord(BuildContext
  context,
      String? dateFrom,
      String? dateTo,
      String? userFullName,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    print('ASFAFASDFasm $dateFrom $dateTo $userFullName');

    try {
      String url = "${baseUrl}api/v1/getPurchaseRecord";
      Response response = await Dio().post(url,
          data: {
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "userFullName": "$userFullName",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var data = jsonDecode(response.data);
      print('PurchaseRecord List $data');
      return List.from(data).map((e) => PurchaseRecordModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  //==================GetPurchaseDetails List=======================
  static fetchPurchaseDetails(BuildContext
  context,
      String? categoryId,
      String? dateFrom,
      String? dateTo,
      String? productId,
      String? supplierId,
      ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    print('ASFAFASDFasm $categoryId $dateFrom $dateTo $productId $supplierId');

    try {
      String url = "${baseUrl}api/v1/getPurchaseDetails";
      Response response = await Dio().post(url,
          data: {
            "categoryId":"$categoryId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
            "productId": "$productId",
            "supplierId": "$supplierId",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var data = jsonDecode(response.data);
      print('PurchaseDetails List $data');
      return List.from(data).map((e) => PurchaseDetailsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  //==================OtherIncomeExpense List=======================
  static GetApiAllOtherIncomeExpense(
      context,
      String? customer,
      String? dateFrom,
      String? dateTo,
      String? productId,
      ) async {
    var datas;
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
     print("allOtherIncomeExpenselist===================$customer $dateFrom $dateTo $productId");

    try {
      var Response = await http
          .post(body: jsonEncode({
        "customer": "$customer",
        "dateFrom": "$dateFrom",
        "dateTo": "$dateTo",
        "productId": "$productId",

      }),Uri.parse("${baseUrl}api/v1/getOtherIncomeExpense"), headers: {
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      });
      var data = jsonDecode(Response.body);
      print("allOtherIncomeExpenselist++++++++====================${data}");
      datas = OtherIncomeExpenseModel.fromMap(data);

      print(
          "allOtherIncomeExpenselist ======+++++++++++++++++++++++++++=${datas}");
    } catch (e) {
      print("Something is wrong all Other Income Expense list=======:$e");
    }
    return datas;
  }
  //==================HomeTopData======================
  static fetchHomeTopData(context) async {
    String Link = "${baseUrl}api/v1/getTopData";

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
     try {
      Response response = await Dio().get(
        Link,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      print('hot top fetches data: ${response.data}');

      return HomeTopDataModel.fromMap(jsonDecode(response.data));
    } catch (e) {
      print("Something is wrong getSaleslist=======:$e");
    }
    return HomeTopDataModel;
  }
  //==================BankLegder======================
  static fetchBankLedger(String? accountId, String? dateFrom, String? dateTo,) async {

    String apiUrl = "${baseUrl}api/v1/getBankLedger";

    print("supplierId====$accountId=====dateFrom==$dateFrom=====dateTo====$dateTo");

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(apiUrl,
          data: {
            "accountId": "$accountId",
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);

      print('ashjkfhjkasd $data');

      return BankLedgerModel.fromMap(data);
    } catch (e) {
      // isCustomerPaymentLoading = false;
      print("Api: Something is wrong BankLedgerList=======:$e");
    }
    return null;
  }

  //==================BankLegder======================
  static fetchBusinessMonitor(String dateFrom, String dateTo,) async {

    String apiUrl = "${baseUrl}api/v1/getGraphData";
    print("dateFrom==$dateFrom=====dateTo====$dateTo");

    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(apiUrl,
          data: {
            "dateFrom": "$dateFrom",
            "dateTo": "$dateTo",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      print('ashjkfhjkasd $data');

      return BusinessMonitorModel.fromMap(data);
    } catch (e) {
      // isCustomerPaymentLoading = false;
      print("Api: Something is wrong BankLedgerList=======:$e");
    }
    return null;
  }

  //==================getBalanceReport List=======================
  static fetchGetBalanceReport(String date,) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    print('BalanceReport date $date');
    //try {
      String url = "${baseUrl}api/v1/getBalanceReport";
      Response response = await Dio().post(url,
          data: {
            "date": "$date",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var data = jsonDecode(response.data);
      print('BalanceReport statements List $data');
     return BalanceReportModel.fromMap(data["statements"]);
   // }
   //  catch (e) {
   //    print("BalanceReport BalanceReport $e");
   //  }
   // return null;
  }

}