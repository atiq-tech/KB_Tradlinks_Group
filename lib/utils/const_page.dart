
   //String BaseUrl = "http://testapi.happykhata.com/";
   import 'package:flutter/material.dart';

String baseUrl = "http://soft.kbtradelinks.com/";
   //http://kbtrade.bigerp24.com/

   final drawerList = [
      "Sales Entry",
      "Sales Record",
      "Stock Report",
      "Customer Due List",
      "Customer Payment Report",
      "Customer Payment History",
      "Customer List"
   ];
   final drawerList1 = [
      "Purchase Entry",
      "Purchase Record",
      "Supplier Due Report",
      "Supplier Payment Report",
      "ReOrder List"
   ];
   final drawerList2 = [
      "Production Entry",
      "Production Record",
      "Material Purchase",
      "Material Purchase Record",
   ];
   final drawerList3 = [
      "Cash Transaction",
      "Bank Transaction",
      "Customer Payment",
      "Supplier Payment",
      "Cash View",
      "Cash Transaction Report",
      "Bank Transaction Report",
      "Cash Statement",
   ];
   final drawerList4 = [
      "Product Entry",
      "Product Ledger",
      "Customer Entry",
      "Supplier Entry",
   ];
   final drawerList5 = [
      "Profit & Loss",
      "Bank Ledger",
      "Balance Report",
      "Business Monitor",
   ];

   getTextstyle() {
      return  TextStyle(
         // backgroundColor: Colors.indigo.shade100,
          color: Colors.deepPurple.shade900,
         //decoration: TextDecoration.underline,
          //fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w800,
          fontSize: 16.0
      );
   }

   List salesList = [
      {"name": "Sales Entry", "image": "images/sales/sales_entry.png"},
      {"name": "Sales Record", "image": "images/report/sales_record.png"},
      {"name": "Stock Report", "image": "images/report/stock_report.png"},
      {"name": "Customer Due List", "image": "images/cdlist.png"},
      {"name": "Customer Payment Report", "image": "images/supplierd.png"},
      {"name": "Customer Payment History", "image": "images/cpreport.png"},
      {"name": "Customer List", "image": "images/report/customer_payment_report.png"},

      // {"name": "Purchase Entry", "image": "images/sales/purchase_entry.png"},
      // {"name": "Customer Entry", "image": "images/custom.png"},
      // {"name": "Setting", "image": "images/settings.png"},
   ];
   List purchaseNewList = [
      {"name": "Purchase Entry", "image": "images/sales/purchase_entry.png"},
      {"name": "Purchase Record", "image": "images/purchase/pcrd.png"},
      {"name": "Supplier Due Report", "image": "images/purchase/sdr.png"},
      {"name": "Supplier Payment Report", "image": "images/report/customer_payment_report.png"},
      {"name": "Re-Order list", "image": "images/purchase/reord.png"},
   ];
   List accountModuleItems = [
      {"name": "Cash Transaction", "image": "images/ctrans.png"},
      {"name": "Bank Transaction", "image": "images/bank.png"},
      {"name": "Customer Payment", "image": "images/account/customer_payments.png"},
      {"name": "Supplier Payment", "image": "images/account/spayment.png"},
      {"name": "Cash View", "image": "images/account/cv.png"},
      {"name": "Cash Transaction Report", "image": "images/account/ccttr.png"},
      {"name": "Bank Transaction Report", "image": "images/account/bbtr.png"},
      //{"name": "Business Monitor", "image": "images/bnm.png"},
      {"name": "Cash Statement", "image": "images/bsheet.png"},
   ];

   List reportList = [
      {"name": "Profit & Loss", "image": "images/report/ploss.png"},
      {"name": "Bank Ledger", "image": "images/report/bledger.png"},
      {"name": "Balance Report", "image": "images/report/blnc.png"},
      {"name": "Business Monitor", "image": "images/account/bbtr.png"},
   ];

   ///business monitor
   List businessMonitorList = [
      {"name": "Today's Sale", "image": "images/business/tds.png"},
      {"name": "Collection", "image": "images/business/cln.png"},
      {"name": "Monthly Sale", "image": "images/business/tds.png"},
      {"name": "Customer Due", "image": "images/business/cdue.png"},
      {"name": "Cash Balance", "image": "images/business/dollar.png"},
      {"name": "Bank Balance", "image": "images/business/dollar.png"},
      {"name": "Stock Report", "image": "images/business/dollar.png"},
      {"name": "Supplier Due", "image": "images/business/cdue.png"},
   ];
   List Administator = [
      {"name": "Product Entry", "image": "images/administator/ppee.png"},
      {"name": "Product Ledger", "image": "images/administator/ppll.png"},
      {"name": "Customer Entry", "image": "images/administator/custom.png"},
      {"name": "Supplier Entry", "image": "images/administator/ssee.png"},
   ];