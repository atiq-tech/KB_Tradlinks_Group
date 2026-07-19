import 'package:flutter/material.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_invoice_model.dart';
import 'package:kbtradlink/screen/sales_module/invoice/api/invoice_api.dart';
class PurchaseInvoiceProvider extends ChangeNotifier {

  PurchaseInvoiceModel? purchaseInvoiceModel;
  Future<PurchaseInvoiceModel?>getPurchaseInvoice(context,
      String? purchaseId,
      ) async {
    purchaseInvoiceModel = await ApiGetSalesInvoice.GetPurchaseInvoice(purchaseId);
    return purchaseInvoiceModel;
  }
}