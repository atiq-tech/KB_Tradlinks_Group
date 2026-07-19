import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/purchase_invoice_provider.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_details_model.dart';
import 'package:kbtradlink/screen/purchase_module/model/purchase_invoice_model.dart';
import 'package:kbtradlink/utils/save_pdf_file.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';

class PurchaseInvoicePage extends StatefulWidget {
  const PurchaseInvoicePage({super.key, required this.purchaseId});

  final String purchaseId;
  @override
  State<PurchaseInvoicePage> createState() => _PurchaseInvoicePageState();
}

class _PurchaseInvoicePageState extends State<PurchaseInvoicePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<CounterProvider>(context, listen: false).getSalesInvoice(
    //   context, widget.salesId,
    // );
    print('asfhkkjlasdfh ${widget.purchaseId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Purchase Invoice"),
      body: FutureBuilder(
          future: Provider.of<PurchaseInvoiceProvider>(context)
              .getPurchaseInvoice(context, widget.purchaseId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              createPdf(snapshot.data);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                            ),
                            child: const Text("Save As PDF"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text("Supplier Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                Text(
                                  "Supplier Id: ${snapshot.data?.purchaseModel[0].supplierCode}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Supplier Name: ${snapshot.data?.purchaseModel[0].supplierName}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Supplier Address: ${snapshot.data?.purchaseModel[0].supplierAddress}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Supplier Mobile: ${snapshot.data?.purchaseModel[0].supplierMobile}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Purchase By:  ${snapshot.data?.purchaseModel[0].addBy}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Invoice No: ${snapshot.data?.purchaseModel[0].purchaseMasterInvoiceNo}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  "Purchase Date: ${Utils.formatFrontEndDate(snapshot.data?.purchaseModel[0].purchaseMasterOrderDate)}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Divider(),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 20.0,
                          dataRowMaxHeight: double.infinity,
                          showCheckboxColumn: true,
                          border: TableBorder.all(
                            color: Colors.black54,
                            width: 1,
                          ),
                          dataTextStyle: const TextStyle(
                              fontSize: 12, color: Colors.black),
                          columns: const [
                            // Set the name of the column
                            DataColumn(
                              label: Text('SL'),
                            ),
                            DataColumn(
                              label: Text('Product'),
                            ),
                            DataColumn(
                              label: Text('Category'),
                            ),
                            DataColumn(
                              label: Text('Branch'),
                            ),
                            DataColumn(
                              label: Text('Qnty'),
                            ),
                            DataColumn(
                              label: Text('Unit Price'),
                            ),
                            DataColumn(
                              label: Text('Total'),
                            ),
                          ],
                          rows: List.generate(
                              snapshot.data!.purchaseDetailsModel.length, (int index) {
                            return DataRow(cells: <DataCell>[
                              DataCell(
                                Center(child: Text("${index + 1}")),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 150,
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data?.purchaseDetailsModel[index].productName}',
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '${snapshot.data?.purchaseDetailsModel[index].productCategoryName}',
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '${snapshot.data?.purchaseDetailsModel[index].branchName}',
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                  '${snapshot.data?.purchaseDetailsModel[index].purchaseDetailsTotalQuantity} ${snapshot.data?.purchaseDetailsModel[index].unitName}',
                                )),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                  '${snapshot.data?.purchaseDetailsModel[index].purchaseDetailsRate}',
                                )),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                  '${snapshot.data?.purchaseDetailsModel[index].purchaseDetailsTotalAmount}',
                                )),
                              ),
                            ]);
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Visibility(
                              visible: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Previous Due: ${snapshot.data?.purchaseModel[0].previousDue}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Current Due: ${snapshot.data?.purchaseModel[0].purchaseMasterDueAmount}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Divider(
                                      color: Colors.black, endIndent: 60),
                                  Text(
                                    'fgsfg',
                                    // "Total Due: ${double.parse("${double.parse('${widget.purchaseRecordModel.previousDue}') + double.parse('${widget.purchaseRecordModel.purchaseDetails!.saleMasterDueAmount}')}").toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Sub Total:  ${snapshot.data?.purchaseModel[0].purchaseMasterSubTotalAmount}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Vat: ${snapshot.data?.purchaseModel[0].purchaseMasterTax}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Discount: ${snapshot.data?.purchaseModel[0].purchaseMasterDiscountAmount}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Transport Cost: ${snapshot.data?.purchaseModel[0].purchaseMasterFreight}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Own Transport Cost: ${snapshot.data?.purchaseModel[0].ownFreight}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                // Text(
                                //   "Previous Due: ${snapshot.data?.purchaseModel[0].previousDue}",
                                //   style: const TextStyle(
                                //       fontSize: 12,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                const Divider(color: Colors.black, indent: 80),
                                Text(
                                  // "Total: ${double.parse("${snapshot.data?.saleMasterTotalSaleAmount}")+double.parse("${snapshot.data?.saleMasterPreviousDue}")+double.parse("${snapshot.data?.saleMasterFreight}")}",
                                  "Total: ${snapshot.data?.purchaseModel[0].purchaseMasterTotalAmount}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Paid:  ${snapshot.data?.purchaseModel[0].purchaseMasterPaidAmount}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Divider(color: Colors.black, indent: 100),
                                Text(
                                  "Due: ${snapshot.data?.purchaseModel[0].purchaseMasterDueAmount}",
                                  // "Due: ${(double.parse("${snapshot.data?.saleMasterTotalSaleAmount}")+double.parse("${snapshot.data?.saleMasterPreviousDue}") + double.parse("${snapshot.data?.saleMasterFreight}")) - double.parse("${snapshot.data?.saleMasterPaidAmount}")}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Previous Due: ${snapshot.data?.purchaseModel[0].previousDue}",
                                  // "Due: ${(double.parse("${snapshot.data?.saleMasterTotalSaleAmount}")+double.parse("${snapshot.data?.saleMasterPreviousDue}") + double.parse("${snapshot.data?.saleMasterFreight}")) - double.parse("${snapshot.data?.saleMasterPaidAmount}")}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Total Due: ${double.parse("${snapshot.data?.purchaseModel[0].previousDue}")+double.parse("${snapshot.data?.purchaseModel[0].purchaseMasterDueAmount}")}",
                                  // "Due: ${(double.parse("${snapshot.data?.saleMasterTotalSaleAmount}")+double.parse("${snapshot.data?.saleMasterPreviousDue}") + double.parse("${snapshot.data?.saleMasterFreight}")) - double.parse("${snapshot.data?.saleMasterPaidAmount}")}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        "Total Due Amount In Word: ${converter.convertDouble(double.parse("${snapshot.data?.purchaseModel[0].previousDue}")+double.parse("${snapshot.data?.purchaseModel[0].purchaseMasterDueAmount}"))}".toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        // contextMenuBuilder: (context, editableTextState) {
                        //   return AdaptiveTextSelectionToolbar(
                        //       anchors: editableTextState.contextMenuAnchors,
                        //       children: [
                        //         InkWell(
                        //           onTap: (){},
                        //           child: SizedBox(
                        //             width: 200.0,
                        //             child: Text('Note'),
                        //           ),
                        //         )
                        //       ]);
                        // },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Note: ${snapshot.data?.purchaseModel[0].purchaseMasterDescription}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  var converter = NumberToCharacterConverter('en');
  final pdf = pw.Document();
  int apiLevel = 0;

  createPdf(PurchaseInvoiceModel? purchaseInvoiceModel) async {
    final tableHeaders = [
      'Sl.',
      'Product',
      'Category',
      'Branch',
      'Qnty',
      'Unit Price',
      'Total',
    ];

    final tableData =
        purchaseInvoiceModel!.purchaseDetailsModel.map((PurchaseDetailsModel e) {
      return [
        purchaseInvoiceModel.purchaseDetailsModel.indexOf(e) + 1,
        utf8.decode(utf8.encode(e.productName)),
        e.productCategoryName,
        e.branchName,
        e.purchaseDetailsTotalQuantity,
        e.purchaseDetailsRate,
        e.purchaseDetailsTotalAmount,
      ];
    }).toList();

    final iconImage =
        (await rootBundle.load('images/app_logo.png')).buffer.asUint8List();

    // final data = await rootBundle.load("fonts/noto_serif.ttf");
    // final  dataint = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);

    final font = await rootBundle.load('fonts/nikosh.ttf');
    final ttf = pw.Font.ttf(font);

    // final ttf = pw.Font.ttf(data);

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    final androidInfo = await deviceInfoPlugin.androidInfo;
    apiLevel = androidInfo.version.sdkInt;
    PermissionStatus storagePermission;
    print("apiLevel $apiLevel");

    if (apiLevel < 33) {
      storagePermission = await Permission.storage.request();

      if (storagePermission == PermissionStatus.granted) {
        try {
          pdf.addPage(
            pw.MultiPage(
              pageFormat: PdfPageFormat.a4,
              build: (context) {
                return [
                  ///top header
                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Image(
                            pw.MemoryImage(iconImage),
                            height: 80,
                            width: 200,
                          ),
                          pw.SizedBox(width: 10 * PdfPageFormat.mm),
                          pw.Column(
                            mainAxisSize: pw.MainAxisSize.min,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'KB-TradeLink',
                                style: pw.TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'ডিগ্রী কলেজ রোড, \nশৈলকূপা ঝিনাইদাহ-৭৩২০',
                                style: pw.TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: pw.FontWeight.bold,
                                  // font: ttf,
                                  font: ttf,
                                  color: PdfColors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5 * PdfPageFormat.mm),
                      pw.Container(
                        height: 1,
                        width: double.infinity,
                        color: PdfColors.black,
                      ),
                      pw.SizedBox(height: 3),
                      pw.Container(
                        height: 1,
                        width: double.infinity,
                        color: PdfColors.black,
                      ),
                      pw.SizedBox(height: 3 * PdfPageFormat.mm),
                    ],
                  ),

                  ///mid data table
                  pw.Divider(color: PdfColors.grey),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'Sales Invoice',
                      style: pw.TextStyle(
                          fontSize: 20.0, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Divider(color: PdfColors.grey),
                  pw.SizedBox(height: 3 * PdfPageFormat.mm),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 5,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Text("Supplier Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                            pw.Row(children: [
                              pw.Text(
                                "Supplier Id: ",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                purchaseInvoiceModel.purchaseModel[0].supplierCode,
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Supplier Name: ",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                utf8.decode(utf8
                                    .encode(purchaseInvoiceModel.purchaseModel[0].supplierName,)),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  font: ttf,
                                ),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Supplier Address: ",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                utf8.decode(utf8.encode(
                                    purchaseInvoiceModel.purchaseModel[0].supplierAddress)),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  font: ttf,
                                ),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Supplier Mobile: ",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                purchaseInvoiceModel.purchaseModel[0].supplierMobile,
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 5,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    "Sales By: ",
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    purchaseInvoiceModel.purchaseModel[0].addBy,
                                    style: const pw.TextStyle(fontSize: 12),
                                  ),
                                ]),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    "Invoice No: ",
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                      purchaseInvoiceModel.purchaseModel[0]
                                          .purchaseMasterInvoiceNo,
                                      style: const pw.TextStyle(fontSize: 12),
                                      textAlign: pw.TextAlign.right),
                                ]),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    "Order Date ",
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    Utils.formatFrontEndDate(purchaseInvoiceModel.purchaseModel[0]
                                        .purchaseMasterOrderDate),
                                    style: const pw.TextStyle(fontSize: 12),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 3 * PdfPageFormat.mm),
                  pw.Divider(),
                  pw.SizedBox(height: 3 * PdfPageFormat.mm),
                  pw.TableHelper.fromTextArray(
                    headers: tableHeaders,
                    data: tableData,
                    border: pw.TableBorder.all(color: PdfColors.black),
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                    cellStyle: pw.TextStyle(
                      font: ttf,
                    ),
                    // headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    cellHeight: 30.0,
                    cellAlignments: {
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                    },
                  ),
                  pw.SizedBox(height: 3 * PdfPageFormat.mm),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(flex: 5, child: pw.Container()
                        /*child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Text("Supplier Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                            pw.Text(
                              "Previous Due: ${salesInvoiceModel
                                  .saleMasterPreviousDue}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Text(
                              "Current Due: ${salesInvoiceModel
                                  .saleMasterDueAmount}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Divider(color: PdfColors.black, endIndent: 60),
                            pw.Text(
                              "Total Due: ${double.parse("${double.parse(
                                  salesInvoiceModel
                                      .saleMasterPreviousDue) + double.parse(
                                  salesInvoiceModel
                                      .saleMasterDueAmount)}").toStringAsFixed(
                                  2)}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                          ],
                        ),*/
                      ),
                      pw.Expanded(
                        flex: 5,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              "Total:  ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterSubTotalAmount}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Vat: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterTax}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Discount: ${purchaseInvoiceModel.purchaseModel[0]
                                  .purchaseMasterDiscountAmount}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Transport Cost: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterFreight}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Own Transport Cost: ${purchaseInvoiceModel.purchaseModel[0].ownFreight}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Divider(color: PdfColors.black, indent: 100),
                            pw.Text(
                              "Total: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterTotalAmount}",
                              // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Paid: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterPaidAmount}",
                              // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Divider(color: PdfColors.black, indent: 100),

                            pw.Text(
                              "Due: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterDueAmount}",
                              // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Previous Due: ${purchaseInvoiceModel.purchaseModel[0].previousDue}",
                              // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Total: ${double.parse("${purchaseInvoiceModel.purchaseModel[0].previousDue}")+double.parse("${purchaseInvoiceModel.purchaseModel[0].purchaseMasterDueAmount}")}",
                              // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 20,
                  ),
                  pw.Text(
                      "Total Due Amount In Word: ${converter.convertDouble(double.parse("${purchaseInvoiceModel.purchaseModel[0].previousDue}")+double.parse("${purchaseInvoiceModel.purchaseModel[0].purchaseMasterDueAmount}"))}".toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Text(
                      "Note: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterDescription}",
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(height: 15 * PdfPageFormat.mm),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(children: [
                          pw.Text('Received by',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 14))
                        ]),
                        pw.Column(children: [
                          pw.Text('Check by',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 14))
                        ]),
                        pw.Column(children: [
                          pw.Text('Authorized by',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 14))
                        ]),
                      ]),
                  pw.SizedBox(height: 10 * PdfPageFormat.mm),
                  pw.Text('** THANK YOU FOR YOUR BUSINESS **',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.SizedBox(height: 2 * PdfPageFormat.mm),
                  pw.Divider(),
                ];
              },
              footer: (context) {
                return pw.Column(children: [
                  pw.SizedBox(height: 5 * PdfPageFormat.mm),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Row(children: [
                          pw.Text(Utils.formatBackEndDate(DateTime.now())),
                          pw.SizedBox(width: 10),
                          pw.Text(DateFormat.jm().format(DateTime.now())),
                        ]),
                        pw.Text("Developed by: : Link-Up Technologoy"
                            "\nContact no: 01911978897"),
                      ])
                ]);
              },
            ),
          );

          final bytes = await pdf.save();

          SaveFile.saveAndLaunchFile(
              bytes,
              'kbtrade_invoice${purchaseInvoiceModel.purchaseModel[0].purchaseMasterInvoiceNo}.pdf',
              apiLevel,
              context);
        } catch (e) {
          print("Error $e ");

          /*apiLevel >= 33
            ? ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Already saved in your device"),
                ),
              )
            :*/
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Already saved in your device"),
              action: SnackBarAction(
                label: "Open",
                onPressed: () {
                  OpenFile.open(
                      '/storage/emulated/0/Download/kbtrade_invoice${purchaseInvoiceModel.purchaseModel[0].purchaseMasterInvoiceNo}.pdf');
                },
              ),
            ),
          );
          //   print("Saved already");
        }
      } else if (storagePermission.isDenied) {
        Utils.toastMsg("Required Storage Permission");
        openAppSettings();
      } else if (storagePermission.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else if (apiLevel >= 33) {
      try {
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return [
                ///top header
                pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.Image(
                          pw.MemoryImage(iconImage),
                          height: 80,
                          width: 200,
                        ),
                        pw.SizedBox(width: 10 * PdfPageFormat.mm),
                        pw.Column(
                          mainAxisSize: pw.MainAxisSize.min,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'KB-TradeLink',
                              style: pw.TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'ডিগ্রী কলেজ রোড, \nশৈলকূপা ঝিনাইদাহ-৭৩২০',
                              style: pw.TextStyle(
                                fontSize: 14.0,
                                fontWeight: pw.FontWeight.bold,
                                // font: ttf,
                                font: ttf,
                                color: PdfColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5 * PdfPageFormat.mm),
                    pw.Container(
                      height: 1,
                      width: double.infinity,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 3),
                    pw.Container(
                      height: 1,
                      width: double.infinity,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 3 * PdfPageFormat.mm),
                  ],
                ),

                ///mid data table
                pw.Divider(color: PdfColors.grey),
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'Sales Invoice',
                    style: pw.TextStyle(
                        fontSize: 20.0, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Divider(color: PdfColors.grey),
                pw.SizedBox(height: 3 * PdfPageFormat.mm),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Text("Supplier Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                          pw.Row(children: [
                            pw.Text(
                              "Supplier Id: ",
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              purchaseInvoiceModel.purchaseModel[0].supplierCode,
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ]),
                          pw.Row(children: [
                            pw.Text(
                              "Supplier Name: ",
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              utf8.decode(utf8
                                  .encode(purchaseInvoiceModel.purchaseModel[0].supplierName,)),
                              style: pw.TextStyle(
                                fontSize: 12,
                                font: ttf,
                              ),
                            ),
                          ]),
                          pw.Row(children: [
                            pw.Text(
                              "Supplier Address: ",
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              utf8.decode(utf8.encode(
                                  purchaseInvoiceModel.purchaseModel[0].supplierAddress)),
                              style: pw.TextStyle(
                                fontSize: 12,
                                font: ttf,
                              ),
                            ),
                          ]),
                          pw.Row(children: [
                            pw.Text(
                              "Supplier Mobile: ",
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              purchaseInvoiceModel.purchaseModel[0].supplierMobile,
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Sales By: ",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  purchaseInvoiceModel.purchaseModel[0].addBy,
                                  style: const pw.TextStyle(fontSize: 12),
                                ),
                              ]),
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Invoice No: ",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                    purchaseInvoiceModel.purchaseModel[0]
                                        .purchaseMasterInvoiceNo,
                                    style: const pw.TextStyle(fontSize: 12),
                                    textAlign: pw.TextAlign.right),
                              ]),
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Order Date ",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  Utils.formatFrontEndDate(purchaseInvoiceModel.purchaseModel[0]
                                      .purchaseMasterOrderDate),
                                  style: const pw.TextStyle(fontSize: 12),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 3 * PdfPageFormat.mm),
                pw.Divider(),
                pw.SizedBox(height: 3 * PdfPageFormat.mm),
                pw.TableHelper.fromTextArray(
                  headers: tableHeaders,
                  data: tableData,
                  border: pw.TableBorder.all(color: PdfColors.black),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  cellStyle: pw.TextStyle(
                    font: ttf,
                  ),
                  // headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  cellHeight: 30.0,
                  cellAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.center,
                  },
                ),
                pw.SizedBox(height: 3 * PdfPageFormat.mm),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(flex: 5, child: pw.Container()
                      /*child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Text("Supplier Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                            pw.Text(
                              "Previous Due: ${salesInvoiceModel
                                  .saleMasterPreviousDue}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Text(
                              "Current Due: ${salesInvoiceModel
                                  .saleMasterDueAmount}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Divider(color: PdfColors.black, endIndent: 60),
                            pw.Text(
                              "Total Due: ${double.parse("${double.parse(
                                  salesInvoiceModel
                                      .saleMasterPreviousDue) + double.parse(
                                  salesInvoiceModel
                                      .saleMasterDueAmount)}").toStringAsFixed(
                                  2)}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                          ],
                        ),*/
                    ),
                    pw.Expanded(
                      flex: 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "Total:  ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterSubTotalAmount}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "Vat: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterTax}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "Discount: ${purchaseInvoiceModel.purchaseModel[0]
                                .purchaseMasterDiscountAmount}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "Transport Cost: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterFreight}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "Own Transport Cost: ${purchaseInvoiceModel.purchaseModel[0].ownFreight}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Divider(color: PdfColors.black, indent: 100),
                          pw.Text(
                            "Total: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterTotalAmount}",
                            // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "Paid: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterPaidAmount}",
                            // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Divider(color: PdfColors.black, indent: 100),

                          pw.Text(
                            "Due: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterDueAmount}",
                            // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "Previous Due: ${purchaseInvoiceModel.purchaseModel[0].previousDue}",
                            // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "Total: ${double.parse("${purchaseInvoiceModel.purchaseModel[0].previousDue}")+double.parse("${purchaseInvoiceModel.purchaseModel[0].purchaseMasterDueAmount}")}",
                            // "Due: ${(double.parse("${purchaseRecordModel.saleMasterTotalSaleAmount}")+double.parse("${purchaseRecordModel.saleMasterPreviousDue}") + double.parse("${purchaseRecordModel.saleMasterFreight}")) - double.parse("${purchaseRecordModel.saleMasterPaidAmount}")}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 20,
                ),
                pw.Text(
                    "Total Due Amount In Word: ${converter.convertDouble(double.parse("${purchaseInvoiceModel.purchaseModel[0].previousDue}")+double.parse("${purchaseInvoiceModel.purchaseModel[0].purchaseMasterDueAmount}"))}".toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                    "Note: ${purchaseInvoiceModel.purchaseModel[0].purchaseMasterDescription}",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.SizedBox(height: 15 * PdfPageFormat.mm),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(children: [
                        pw.Text('Received by',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 14))
                      ]),
                      pw.Column(children: [
                        pw.Text('Check by',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 14))
                      ]),
                      pw.Column(children: [
                        pw.Text('Authorized by',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 14))
                      ]),
                    ]),
                pw.SizedBox(height: 10 * PdfPageFormat.mm),
                pw.Text('** THANK YOU FOR YOUR BUSINESS **',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 2 * PdfPageFormat.mm),
                pw.Divider(),
              ];
            },
            footer: (context) {
              return pw.Column(children: [
                pw.SizedBox(height: 5 * PdfPageFormat.mm),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(children: [
                        pw.Text(Utils.formatBackEndDate(DateTime.now())),
                        pw.SizedBox(width: 10),
                        pw.Text(DateFormat.jm().format(DateTime.now())),
                      ]),
                      pw.Text("Developed by: : Link-Up Technologoy"
                          "\nContact no: 01911978897"),
                    ])
              ]);
            },
          ),
        );

        final bytes = await pdf.save();

        SaveFile.saveAndLaunchFile(
            bytes,
            'kbtrade_invoice${purchaseInvoiceModel.purchaseModel[0].purchaseMasterInvoiceNo}.pdf',
            apiLevel,
            context);
      } catch (e) {
        print("Error $e ");

        /*apiLevel >= 33
            ? ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Already saved in your device"),
                ),
              )
            :*/
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Already saved in your device"),
            action: SnackBarAction(
              label: "Open",
              onPressed: () {
                OpenFile.open(
                    '/storage/emulated/0/Download/kbtrade_invoice${purchaseInvoiceModel.purchaseModel[0].purchaseMasterInvoiceNo}.pdf');
              },
            ),
          ),
        );
        //   print("Saved already");
      }
    }
  }
}
