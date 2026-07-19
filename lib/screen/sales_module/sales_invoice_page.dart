import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/screen/sales_module/invoice/model/sales_details_model.dart';
import 'package:kbtradlink/screen/sales_module/invoice/model/sales_invoice_model.dart';
import 'package:kbtradlink/screen/sales_module/invoice/provider/invoice_provider.dart';
import 'package:kbtradlink/utils/save_pdf_file.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:device_info_plus/device_info_plus.dart';

class SalesInvoicePage extends StatefulWidget {
  const SalesInvoicePage({super.key, required this.salesId});

  final String salesId;

  @override
  State<SalesInvoicePage> createState() => _SalesInvoicePageState();
}

class _SalesInvoicePageState extends State<SalesInvoicePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<CounterProvider>(context, listen: false).getSalesInvoice(
    //   context, widget.salesId,
    // );
    print('asfhkkjlasdfh ${widget.salesId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Sales Invoice"),
        body: FutureBuilder(
          future: Provider.of<SalesInvoiceProvider>(context).getSalesInvoice(context, widget.salesId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                                // Text("Customer Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                Text(
                                  "Customer Id: ${snapshot.data?.salesModel[0].customerCode}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Customer Name: ${snapshot.data?.salesModel[0].customerName}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Customer Address: ${snapshot.data?.salesModel[0].customerAddress}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Customer Mobile: ${snapshot.data?.salesModel[0].customerMobile}",
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
                                  "Sales By:  ${snapshot.data?.salesModel[0].addBy}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Invoice No: ${snapshot.data?.salesModel[0].saleMasterInvoiceNo}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  "Order Date: ${Utils.formatFrontEndDate(snapshot.data?.salesModel[0].saleMasterSaleDate)}",
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
                          dataRowHeight: 20.0,
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
                              label: Text('Description'),
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
                              snapshot.data!.salesDetailsModel.length,
                              (int index) {
                            return DataRow(cells: <DataCell>[
                              DataCell(
                                Center(child: Text("${index + 1}")),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '${snapshot.data?.salesDetailsModel[index].productName}',
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                  '${snapshot.data?.salesDetailsModel[index].saleDetailsTotalQuantity}',
                                )),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                  '${snapshot.data?.salesDetailsModel[index].saleDetailsRate}',
                                )),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                  '${snapshot.data?.salesDetailsModel[index].saleDetailsTotalAmount}',
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
                                    "Previous Due: ${snapshot.data?.salesModel[0].saleMasterPreviousDue}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Current Due: ${snapshot.data?.salesModel[0].saleMasterDueAmount}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Divider(
                                      color: Colors.black, endIndent: 60),
                                  Text(
                                    "Total Due: ${double.parse("${double.parse('${snapshot.data?.salesModel[0].saleMasterPreviousDue}') + double.parse('${snapshot.data?.salesModel[0].saleMasterDueAmount}')}").toStringAsFixed(2)}",
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
                                  "Total:  ${snapshot.data?.salesModel[0].saleMasterSubTotalAmount}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                // Text(
                                //   "Vat: ${snapshot.data?.salesModel[0].saleMasterTaxAmount}",
                                //   style: const TextStyle(
                                //       fontSize: 12,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                // Text(
                                //   "Discount: ${snapshot.data?.salesModel[0].saleMasterTotalDiscountAmount}",
                                //   style: const TextStyle(
                                //       fontSize: 12,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                Text(
                                  "Transport Cost: ${snapshot.data?.salesModel[0].saleMasterFreight}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Previous Due: ${snapshot.data?.salesModel[0].saleMasterPreviousDue}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Divider(color: Colors.black, indent: 80),
                                Text(
                                  "Total: ${double.parse("${snapshot.data?.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${snapshot.data?.salesModel[0].saleMasterPreviousDue}")+double.parse("${snapshot.data?.salesModel[0].saleMasterFreight}")}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Paid:  ${snapshot.data?.salesModel[0].saleMasterPaidAmount}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Divider(color: Colors.black, indent: 100),
                                Text(
                                  "Due: ${(double.parse("${snapshot.data?.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${snapshot.data?.salesModel[0].saleMasterPreviousDue}") + double.parse("${snapshot.data?.salesModel[0].saleMasterFreight}")) - double.parse("${snapshot.data?.salesModel[0].saleMasterPaidAmount}")}",
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
                          "In Word: ${converter.convertDouble((double.parse("${snapshot.data?.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${snapshot.data?.salesModel[0].saleMasterPreviousDue}") + double.parse("${snapshot.data?.salesModel[0].saleMasterFreight}")) - double.parse("${snapshot.data?.salesModel[0].saleMasterPaidAmount}"))}"
                              .toUpperCase(),
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
                          "Note: ${snapshot.data?.salesModel[0].saleMasterDescription}",
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
          },
        ));
  }

  var converter = NumberToCharacterConverter('en');
  final pdf = pw.Document();
  int apiLevel = 0;

  createPdf(SalesInvoiceModel? salesInvoiceModel) async {
    final tableHeaders = [
      'Sl.',
      'Description',
      'Qnty',
      'Unit Price',
      'Total',
    ];

    final tableData =
        salesInvoiceModel!.salesDetailsModel.map((SaleDetailModel e) {
      return [
        salesInvoiceModel.salesDetailsModel.indexOf(e) + 1,
        utf8.decode(utf8.encode(e.productName)),
        e.saleDetailsTotalQuantity,
        e.saleDetailsRate,
        e.saleDetailsTotalAmount,
      ];
    }).toList();

    final iconImage = (await rootBundle.load('images/app_logo.png'))
        .buffer
        .asUint8List();

    // final data = await rootBundle.load("fonts/noto_serif.ttf");
    // final  dataint = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);

    final font = await rootBundle.load('fonts/nikosh.ttf');
    final ttf = pw.Font.ttf(font);

    // final ttf = pw.Font.ttf(data);

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    //wait korun apnar kaj ti ekorci

    final androidInfo = await deviceInfoPlugin.androidInfo;
    apiLevel = androidInfo.version.sdkInt;
    PermissionStatus storagePermission;
    print("apiLevel $apiLevel");

    if(apiLevel < 33) {
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
                                  fontWeight: pw.FontWeight.bold
                                ),
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
                        fontSize: 20.0,
                        fontWeight: pw.FontWeight.bold
                      ),
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
                            // Text("Customer Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                            pw.Row(children: [
                              pw.Text(
                                "Customer Id: ",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  ),
                              ),
                              pw.Text(
                                salesInvoiceModel.salesModel[0].customerCode,
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Customer Name: ",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                utf8.decode(utf8.encode(salesInvoiceModel.salesModel[0].customerName)),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  font: ttf,
                                ),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Customer Address: ",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                utf8.decode(utf8.encode(salesInvoiceModel.salesModel[0].customerAddress)),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  font: ttf,
                                ),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Customer Mobile: ",
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                salesInvoiceModel.salesModel[0].customerMobile,
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
                                    salesInvoiceModel.salesModel[0].addBy,
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
                                    salesInvoiceModel
                                        .salesModel[0].saleMasterInvoiceNo,
                                    style: const pw.TextStyle(fontSize: 12),
                                    textAlign: pw.TextAlign.right
                                  ),
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
                                    Utils.formatFrontEndDate(salesInvoiceModel
                                        .salesModel[0].saleMasterSaleDate),
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
                      pw.Expanded(
                        flex: 5,
                        child: pw.Container()
                          /*child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Text("Customer Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                            pw.Text(
                              "Previous Due: ${salesInvoiceModel.salesModel[0]
                                  .saleMasterPreviousDue}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Text(
                              "Current Due: ${salesInvoiceModel.salesModel[0]
                                  .saleMasterDueAmount}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Divider(color: PdfColors.black, endIndent: 60),
                            pw.Text(
                              "Total Due: ${double.parse("${double.parse(
                                  salesInvoiceModel.salesModel[0]
                                      .saleMasterPreviousDue) + double.parse(
                                  salesInvoiceModel.salesModel[0]
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
                              "Total:  ${salesInvoiceModel.salesModel[0]
                                  .saleMasterSubTotalAmount}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            // pw.Text(
                            //   "Vat: ${salesInvoiceModel.salesModel[0]
                            //       .saleMasterTaxAmount}",
                            //   style: pw.TextStyle(
                            //     fontSize: 12,
                            //     fontWeight: pw.FontWeight.bold,
                            //     ),
                            // ),
                            // pw.Text(
                            //   "Discount: ${salesInvoiceModel.salesModel[0]
                            //       .saleMasterTotalDiscountAmount}",
                            //   style: pw.TextStyle(
                            //     fontSize: 12,
                            //     fontWeight: pw.FontWeight.bold,
                            //     ),
                            // ),
                            pw.Text(
                              "Transport Cost: ${salesInvoiceModel.salesModel[0]
                                  .saleMasterFreight}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Text(
                              "Previous Due:  ${salesInvoiceModel.salesModel[0]
                                  .saleMasterPreviousDue}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Divider(color: PdfColors.black, indent: 80),
                            pw.Text(
                              "Total: ${double.parse("${salesInvoiceModel.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${salesInvoiceModel.salesModel[0].saleMasterPreviousDue}")+double.parse("${salesInvoiceModel.salesModel[0].saleMasterFreight}")}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Text(
                              "Paid:  ${salesInvoiceModel.salesModel[0]
                                  .saleMasterPaidAmount}",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Divider(color: PdfColors.black, indent: 100),
                            pw.Text(
                              "Due: ${(double.parse("${salesInvoiceModel.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${salesInvoiceModel.salesModel[0].saleMasterPreviousDue}") + double.parse("${salesInvoiceModel.salesModel[0].saleMasterFreight}")) - double.parse("${salesInvoiceModel.salesModel[0].saleMasterPaidAmount}")}",
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
                      "In Word: ${converter.convertDouble((double.parse("${salesInvoiceModel.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${salesInvoiceModel.salesModel[0].saleMasterPreviousDue}") + double.parse("${salesInvoiceModel.salesModel[0].saleMasterFreight}")) - double.parse("${salesInvoiceModel.salesModel[0].saleMasterPaidAmount}"))}"
                          .toUpperCase(),
                      style: pw.TextStyle(fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        )),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Text(
                      "Note: ${salesInvoiceModel.salesModel[0]
                          .saleMasterDescription}",
                      style: pw.TextStyle(fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        )),
                  pw.SizedBox(height: 15 * PdfPageFormat.mm),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(children: [
                          pw.Text('Received by',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,

                                  fontSize: 14))
                        ]),
                        pw.Column(children: [
                          pw.Text('Check by',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,

                                  fontSize: 14))
                        ]),
                        pw.Column(children: [
                          pw.Text('Authorized by',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,

                                  fontSize: 14))
                        ]),
                      ]),
                  pw.SizedBox(height: 10 * PdfPageFormat.mm),
                  pw.Text('** THANK YOU FOR YOUR BUSINESS **',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,

                          fontSize: 12)),
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
              'kbtrade_invoice${salesInvoiceModel.salesModel[0]
                  .saleMasterInvoiceNo}.pdf',
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
                      '/storage/emulated/0/Download/kbtrade_invoice${salesInvoiceModel
                          .salesModel[0].saleMasterInvoiceNo}.pdf');
                },
              ),
            ),
          );
          //   print("Saved already");
        }
      }
      else if (storagePermission.isDenied) {
        Utils.toastMsg("Required Storage Permission");
        openAppSettings();
      } else if (storagePermission.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
    else if(apiLevel>=33){
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
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                'ডিগ্রী কলেজ রোড, \nশৈলকূপা ঝিনাইদাহ-৭৩২০',
                                style: pw.TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: pw.FontWeight.bold,
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
                        fontSize: 20.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
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
                            // Text("Customer Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                            pw.Row(children: [
                              pw.Text(
                                "Customer Id: ",
                                style: pw.TextStyle(
                                  fontSize: 14, fontWeight: pw.FontWeight.bold,),
                              ),
                              pw.Text(
                                salesInvoiceModel.salesModel[0].customerCode,
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Customer Name: ",
                                style: pw.TextStyle(
                                  fontSize: 14, fontWeight: pw.FontWeight.bold,),
                              ),
                              pw.Text(
                                utf8.decode(utf8.encode(salesInvoiceModel.salesModel[0].customerName)),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  font: ttf,
                                ),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Customer Address: ",
                                style: pw.TextStyle(
                                  fontSize: 14, fontWeight: pw.FontWeight.bold,),
                              ),
                              pw.Text(
                                utf8.decode(utf8.encode(salesInvoiceModel.salesModel[0].customerAddress)),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  font: ttf,
                                ),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                "Customer Mobile: ",
                                style: pw.TextStyle(
                                  fontSize: 14, fontWeight: pw.FontWeight.bold,),
                              ),
                              pw.Text(
                                salesInvoiceModel.salesModel[0].customerMobile,
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
                                      fontWeight: pw.FontWeight.bold,),
                                  ),
                                  pw.Text(
                                    salesInvoiceModel.salesModel[0].addBy,
                                    style: const pw.TextStyle(fontSize: 12),
                                  ),
                                ]),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    "Invoice No: ",
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,),
                                  ),
                                  pw.Text(
                                    salesInvoiceModel
                                        .salesModel[0].saleMasterInvoiceNo,
                                    style: const pw.TextStyle(fontSize: 12),
                                  ),
                                ]),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    "Order Date ",
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,),
                                  ),
                                  pw.Text(
                                    Utils.formatFrontEndDate(salesInvoiceModel
                                        .salesModel[0].saleMasterSaleDate),
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
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold,),
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
                      pw.Expanded(
                        flex: 5,
                        child: pw.Container()
                        // child: pw.Column(
                        //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                        //   children: [
                        //     // Text("Customer Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                        //     pw.Text(
                        //       "Previous Due: ${salesInvoiceModel.salesModel[0].saleMasterPreviousDue}",
                        //       style: pw.TextStyle(
                        //         fontSize: 12, fontWeight: pw.FontWeight.bold,),
                        //     ),
                        //     pw.Text(
                        //       "Current Due: ${salesInvoiceModel.salesModel[0].saleMasterDueAmount}",
                        //       style: pw.TextStyle(
                        //         fontSize: 12, fontWeight: pw.FontWeight.bold,),
                        //     ),
                        //     pw.Divider(color: PdfColors.black, endIndent: 60),
                        //     pw.Text(
                        //       "Total Due: ${double.parse("${double.parse(salesInvoiceModel.salesModel[0].saleMasterPreviousDue) + double.parse(salesInvoiceModel.salesModel[0].saleMasterDueAmount)}").toStringAsFixed(2)}",
                        //       style: pw.TextStyle(
                        //         fontSize: 12, fontWeight: pw.FontWeight.bold,),
                        //     ),
                        //   ],
                        // ),
                      ),
                      pw.Expanded(
                        flex: 5,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              "Sub Total:  ${salesInvoiceModel.salesModel[0].saleMasterSubTotalAmount}",
                              style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold,),
                            ),
                            // pw.Text(
                            //   "Vat: ${salesInvoiceModel.salesModel[0].saleMasterTaxAmount}",
                            //   style: pw.TextStyle(
                            //     fontSize: 12, fontWeight: pw.FontWeight.bold,),
                            // ),
                            // pw.Text(
                            //   "Discount: ${salesInvoiceModel.salesModel[0].saleMasterTotalDiscountAmount}",
                            //   style: pw.TextStyle(
                            //     fontSize: 12, fontWeight: pw.FontWeight.bold,),
                            // ),
                            pw.Text(
                              "Transport Cost: ${salesInvoiceModel.salesModel[0].saleMasterFreight}",
                              style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold,),
                            ),
                            pw.Text(
                              "Previous Due: ${salesInvoiceModel.salesModel[0].saleMasterPreviousDue}",
                              style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold,),
                            ),
                            pw.Divider(color: PdfColors.black, indent: 80),
                            pw.Text(
                              "Total: ${double.parse("${salesInvoiceModel.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${salesInvoiceModel.salesModel[0].saleMasterPreviousDue}")+double.parse("${salesInvoiceModel.salesModel[0].saleMasterFreight}")}",
                              style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              "Paid:  ${salesInvoiceModel.salesModel[0].saleMasterPaidAmount}",
                              style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold,),
                            ),
                            pw.Divider(color: PdfColors.black, indent: 100),
                            pw.Text(
                              "Due: ${(double.parse("${salesInvoiceModel.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${salesInvoiceModel.salesModel[0].saleMasterPreviousDue}") + double.parse("${salesInvoiceModel.salesModel[0].saleMasterFreight}")) - double.parse("${salesInvoiceModel.salesModel[0].saleMasterPaidAmount}")}",
                              style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold,),
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
                      "In Word: ${converter.convertDouble((double.parse("${salesInvoiceModel.salesModel[0].saleMasterTotalSaleAmount}")+double.parse("${salesInvoiceModel.salesModel[0].saleMasterPreviousDue}") + double.parse("${salesInvoiceModel.salesModel[0].saleMasterFreight}")) - double.parse("${salesInvoiceModel.salesModel[0].saleMasterPaidAmount}"))}"
                          .toUpperCase(),
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold,)),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Text(
                      "Note: ${salesInvoiceModel.salesModel[0].saleMasterDescription}",
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold,)),
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
              'kbtrade_invoice${salesInvoiceModel.salesModel[0].saleMasterInvoiceNo}.pdf',
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
                      '/storage/emulated/0/Download/kbtrade_invoice${salesInvoiceModel.salesModel[0].saleMasterInvoiceNo}.pdf');
                },
              ),
            ),
          );
          //   print("Saved already");
        }
    }
  }
}
