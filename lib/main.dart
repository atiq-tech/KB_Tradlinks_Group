import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kbtradlink/provider/account_provider.dart';
import 'package:kbtradlink/provider/all_product_provider.dart';
import 'package:kbtradlink/provider/balance_report_provider.dart';
import 'package:kbtradlink/provider/bank_account_provider.dart';
import 'package:kbtradlink/provider/bank_ledger_provider.dart';
import 'package:kbtradlink/provider/bank_transaction_provider.dart';
import 'package:kbtradlink/provider/branch_provider.dart';
import 'package:kbtradlink/provider/business_monitor_provider.dart';
import 'package:kbtradlink/provider/cash_transaction_provider.dart';
import 'package:kbtradlink/provider/cash_view_provider.dart';
import 'package:kbtradlink/provider/category_provider.dart';
import 'package:kbtradlink/provider/current_stock_provider.dart';
import 'package:kbtradlink/provider/customer_due_provider.dart';
import 'package:kbtradlink/provider/customer_ledger_provider.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:kbtradlink/provider/district_provider.dart';
import 'package:kbtradlink/provider/employee_provider.dart';
import 'package:kbtradlink/provider/customer_payment_provider.dart';
import 'package:kbtradlink/provider/get_sales_provider.dart';
import 'package:kbtradlink/provider/category_wise_product_provider.dart';
import 'package:kbtradlink/provider/home_topdata_provider.dart';
import 'package:kbtradlink/provider/other_income_expense_provider.dart';
import 'package:kbtradlink/provider/product_ledger_provider.dart';
import 'package:kbtradlink/provider/all_profit_loss_provider.dart';
import 'package:kbtradlink/provider/profit_loss_product_provider.dart';
import 'package:kbtradlink/provider/purchase_details_provider.dart';
import 'package:kbtradlink/provider/purchase_invoice_provider.dart';
import 'package:kbtradlink/provider/purchase_record_provider.dart';
import 'package:kbtradlink/provider/purchases_provider.dart';
import 'package:kbtradlink/provider/sale_details_provider.dart';
import 'package:kbtradlink/provider/sales_record_provider.dart';
import 'package:kbtradlink/provider/supplier_due_provider.dart';
import 'package:kbtradlink/provider/supplier_ledger_provider.dart';
import 'package:kbtradlink/provider/supplier_payment_provider.dart';
import 'package:kbtradlink/provider/supplier_provider.dart';
import 'package:kbtradlink/provider/total_stock_provider.dart';
import 'package:kbtradlink/provider/unit_provider.dart';
import 'package:kbtradlink/provider/warehouse_wise_stock_provider.dart';
import 'package:kbtradlink/screen/sales_module/invoice/provider/invoice_provider.dart';
import 'package:kbtradlink/screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // Initialize hive
  await Hive.initFlutter();
  // Registering the adapter

  await Hive.openBox('profile');
  /// Top
  await Hive.openBox('todaySales');
  await Hive.openBox('monthlySales');
  await Hive.openBox('totalDue');
  await Hive.openBox('cashBalance');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AllEmployeeProvider>(create: (_) => AllEmployeeProvider()),
        ChangeNotifierProvider<BranchProvider>(create: (_) => BranchProvider()),
        ChangeNotifierProvider<CategoryProvider>(create: (_) => CategoryProvider()),
        ChangeNotifierProvider<CustomerListProvider>(create: (_) => CustomerListProvider()),
        ChangeNotifierProvider<CategoryWiseProductProvider>(create: (_) => CategoryWiseProductProvider()),
        ChangeNotifierProvider<AllProductProvider>(create: (_) => AllProductProvider()),
        ChangeNotifierProvider<SupplierProvider>(create: (_) => SupplierProvider()),
        ChangeNotifierProvider<AllDistrictProvider>(create: (_) => AllDistrictProvider()),
        ChangeNotifierProvider<BankAccountProvider>(create: (_) => BankAccountProvider()),
        ChangeNotifierProvider<CustomerPaymentProvider>(create: (_) => CustomerPaymentProvider()),
        ChangeNotifierProvider<SupplierPaymentProvider>(create: (_) => SupplierPaymentProvider()),
        ChangeNotifierProvider<CashTransactionProvider>(create: (_) => CashTransactionProvider()),
        ChangeNotifierProvider<AccountProvider>(create: (_) => AccountProvider()),
        ChangeNotifierProvider<BankTransactionProvider>(create: (_) => BankTransactionProvider()),
        ChangeNotifierProvider<CustomerPaymentReportProvider>(create: (_) => CustomerPaymentReportProvider()),
        ChangeNotifierProvider<SupplierLedgerProvider>(create: (_) => SupplierLedgerProvider()),
        ChangeNotifierProvider<CurrentStockProvider>(create: (_) => CurrentStockProvider()),
        ChangeNotifierProvider<TotalStockProvider>(create: (_) => TotalStockProvider()),
        ChangeNotifierProvider<WarehouseWiseStockProvider>(create: (_) => WarehouseWiseStockProvider()),
        ChangeNotifierProvider<GetSalesProvider>(create: (_) => GetSalesProvider()),
        ChangeNotifierProvider<SalesRecordProvider>(create: (_) => SalesRecordProvider()),
        ChangeNotifierProvider<SaleDetailsProvider>(create: (_) => SaleDetailsProvider()),
        ChangeNotifierProvider<SupplierDueProvider>(create: (_) => SupplierDueProvider()),
        ChangeNotifierProvider<CashViewProvider>(create: (_) => CashViewProvider()),
        ChangeNotifierProvider<CustomerDueListProvider>(create: (_) => CustomerDueListProvider()),
        ChangeNotifierProvider<ProductLedgerProvider>(create: (_) => ProductLedgerProvider()),
        ChangeNotifierProvider<AllProfitLossProvider>(create: (_) => AllProfitLossProvider()),
        ChangeNotifierProvider<ProfitLossProductProvider>(create: (_) => ProfitLossProductProvider()),
        ChangeNotifierProvider<UnitProvider>(create: (_) => UnitProvider()),
        ChangeNotifierProvider<GetPurchasesProvider>(create: (_) => GetPurchasesProvider()),
        ChangeNotifierProvider<PurchaseRecordProvider>(create: (_) => PurchaseRecordProvider()),
        ChangeNotifierProvider<PurchaseDetailsProvider>(create: (_) => PurchaseDetailsProvider()),
        ChangeNotifierProvider<OtherIncomeExpenseProvider>(create: (_) => OtherIncomeExpenseProvider()),
        ChangeNotifierProvider<HomeTopDataProvider>(create: (_) => HomeTopDataProvider()),
        ChangeNotifierProvider<SalesInvoiceProvider>(create: (_) => SalesInvoiceProvider()),
        ChangeNotifierProvider<PurchaseInvoiceProvider>(create: (_) => PurchaseInvoiceProvider()),
        ChangeNotifierProvider<BankLedgerProvider>(create: (_) => BankLedgerProvider()),
        ChangeNotifierProvider<BalanceReportProvider>(create: (_) => BalanceReportProvider()),
        ChangeNotifierProvider<BusinessMonitorProvider>(create: (_) => BusinessMonitorProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KB Tradelinks',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnimatedSplashScreen(),
      ),
    );
  }

}
