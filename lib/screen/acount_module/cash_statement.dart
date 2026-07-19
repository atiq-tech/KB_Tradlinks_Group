import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/bank_transaction_provider.dart';
import 'package:kbtradlink/provider/cash_transaction_provider.dart';
import 'package:kbtradlink/provider/customer_payment_provider.dart';
import 'package:kbtradlink/provider/get_sales_provider.dart';
import 'package:kbtradlink/provider/purchases_provider.dart';
import 'package:kbtradlink/provider/supplier_payment_provider.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class CashStatementPage extends StatefulWidget {
  const CashStatementPage({super.key});

  @override
  State<CashStatementPage> createState() => _CashStatementPageState();
}

class _CashStatementPageState extends State<CashStatementPage> {

  String? firstPickedDate;
  var backEndFirstDate;
  var backEndSecondDate;
  var toDay = DateTime.now();

  void _firstSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndFirstDate = Utils.formatBackEndDate(selectedDate);
        print("First Selected date $firstPickedDate");
      });
    }
    else{
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $firstPickedDate");
      });
    }
  }

  String? secondPickedDate;
  void _secondSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndSecondDate = Utils.formatBackEndDate(selectedDate);
        print("First Selected date $secondPickedDate");
      });
    }
    else{
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $secondPickedDate");
      });
    }
  }
  ///Sub total
  double? totalReceived;
  double? totalReceivedCustomer;
  double? totalReceivedSupplier;
  double? totalCashReceived;
  double? totalBankWithdraw;
  double? totalPaidToSupplier;
  double? totalPaidToCustomer;
  double? totalCashPaid;
  double? totalBankDeposit;
  double? totalPaidPurchase;
  bool isLoading = false;
  @override
  void initState() {
    // firstPickedDate = "2000-03-01";
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provideSaleList = Provider.of<GetSalesProvider>(context).getSaleslist;
    ///Sub total
    totalReceived=provideSaleList.map((e) => e.saleMasterPaidAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // vatTotal=allGetSalesData.map((e) => e.saleMasterTaxAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // discountTotal=allGetSalesData.map((e) => e.saleMasterTotalDiscountAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // transferCost=allGetSalesData.map((e) => e.saleMasterFreight).fold(0.0, (p, element) => p!+double.parse(element));
    // totalAmount=allGetSalesData.map((e) => e.saleMasterTotalSaleAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // paidTotal=allGetSalesData.map((e) => e.saleMasterPaidAmount).fold(0.0, (p, element) => p!+double.parse(element));
    // dueTotal=allGetSalesData.map((e) => e.saleMasterDueAmount).fold(0.0, (p, element) => p!+double.parse(element));
    //
    //get Purchases
    final providePurchaseList = Provider.of<GetPurchasesProvider>(context).getPurchaseslist;
    totalPaidPurchase=providePurchaseList.map((e) => e.purchaseMasterPaidAmount).fold(0.0, (p, element) => p!+double.parse(element));

    final provideBankWithdrawTransactionList =
        Provider.of<BankTransactionProvider>(context).bankTransactionList.where((element) => element.transactionType == 'withdraw').toList();
    totalBankWithdraw=provideBankWithdrawTransactionList.map((e) => e.amount).fold(0.0, (p, element) => p!+double.parse(element));

    final provideBankDepositTransactionList =
        Provider.of<BankTransactionProvider>(context).bankTransactionList.where((element) => element.transactionType == "deposit").toList();
    totalBankDeposit=provideBankDepositTransactionList.map((e) => e.amount).fold(0.0, (p, element) => p!+double.parse(element));

    final provideCashPaidTransactionList =
        Provider.of<CashTransactionProvider>(context).cashTransactionList.where((element) => element.trType == "Out Cash").toList();
    totalCashPaid=provideCashPaidTransactionList.map((e) => e.outAmount).fold(0.0, (p, element) => p!+double.parse(element));

    final provideCashReceivedTransactionList =
        Provider.of<CashTransactionProvider>(context).cashTransactionList.where((element) => element.trType == "In Cash").toList();
    totalCashReceived=provideCashReceivedTransactionList.map((e) => e.inAmount).fold(0.0, (p, element) => p!+double.parse(element));

    final provideCashReceivedFromCustomerList =
        Provider.of<CustomerPaymentProvider>(context).customerPaymentList.where((element) => element.transactionType == "Received").toList();
    totalReceivedCustomer=provideCashReceivedFromCustomerList.map((e) => e.cPaymentAmount).fold(0.0, (p, element) => p!+double.parse(element));
    final provideCashPaidToCustomerList =
        Provider.of<CustomerPaymentProvider>(context).customerPaymentList.where((element) => element.transactionType == "Paid").toList();
    totalPaidToCustomer=provideCashPaidToCustomerList.map((e) => e.cPaymentAmount).fold(0.0, (p, element) => p!+double.parse(element));

    final provideCashPaidToSupplierList =
        Provider.of<SupplierPaymentProvider>(context).supplierPaymentList.where((element) => element.transactionType == "Paid").toList();
    totalPaidToSupplier=provideCashPaidToSupplierList.map((e) => e.sPaymentAmount).fold(0.0, (p, element) => p!+double.parse(element));

    final provideCashReceivedFromSupplierList =
        Provider.of<SupplierPaymentProvider>(context).supplierPaymentList.where((element) => element.transactionType == "Received").toList();
    totalReceivedSupplier=provideCashReceivedFromSupplierList.map((e) => e.sPaymentAmount).fold(0.0, (p, element) => p!+double.parse(element));

    return Scaffold(
      appBar: const CustomAppBar(title: "Cash Statement"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 82.0,
                width: double.infinity,
                padding: const EdgeInsets.only(top:4.0,left: 4.0, right: 4.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      color: const Color.fromARGB(255, 7, 125, 180),
                      width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes the position of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Date : ",
                          style: TextStyle(color: Color.fromARGB(255, 126, 125, 125)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: const Color.fromARGB(255, 7, 125, 180))),
                            child: GestureDetector(
                              onTap: (() {
                                _firstSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 2, left: 5),
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.black87,
                                      size: 16,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: firstPickedDate,
                                  hintStyle: const TextStyle(fontSize: 13, color: Colors.black87),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Container(
                          child: const Text("to"),
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: const Color.fromARGB(255, 7, 125, 180))),
                            child: GestureDetector(
                              onTap: (() {
                                _secondSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 2, left: 5),

                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.black87,
                                      size: 16,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: secondPickedDate,
                                  hintStyle: const TextStyle(fontSize: 13, color: Colors.black87),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });

                          Provider.of<GetSalesProvider>(context, listen: false).getGatSales(
                            context,
                            "",
                            backEndFirstDate,
                            backEndSecondDate,
                            "",
                            ""
                          );

                         Provider.of<GetPurchasesProvider>(context, listen: false).getGetPurchases(
                            context,
                            backEndFirstDate,
                            backEndSecondDate,
                           ""
                          );

                          Provider.of<BankTransactionProvider>(context, listen: false)
                              .getBankTransactionList(
                            "",
                            backEndFirstDate,
                            backEndSecondDate,
                            ""
                          );

                          Provider.of<BankTransactionProvider>(context, listen: false)
                              .getBankTransactionList(
                              "",
                              backEndFirstDate,
                              backEndSecondDate,
                              ""
                          );

                          Provider.of<CashTransactionProvider>(context, listen: false)
                              .getCashTransactionList(
                            "",
                            backEndFirstDate,
                            backEndSecondDate,
                            ""
                          );

                          Provider.of<CashTransactionProvider>(context, listen: false)
                              .getCashTransactionList(
                            "",
                            backEndFirstDate,
                            backEndSecondDate,
                            ""
                          );

                          Provider.of<CustomerPaymentProvider>(context, listen: false)
                              .getAllCustomerPayment(
                            "",
                            backEndFirstDate,
                            backEndSecondDate,
                            ""
                          );

                          Provider.of<CustomerPaymentProvider>(context, listen: false).getAllCustomerPayment(
                            "",
                            backEndFirstDate,
                            backEndSecondDate,
                            ""
                          );

                          Provider.of<SupplierPaymentProvider>(context, listen: false).getAllSupplierPayment(
                            backEndFirstDate,
                            backEndSecondDate,
                          );

                          Provider.of<SupplierPaymentProvider>(context, listen: false)
                              .getAllSupplierPayment(
                            backEndFirstDate,
                            backEndSecondDate,
                          );

                          /*Provider.of<GeEmployeePaymentProvider>(context, listen: false).getEmployeePaymentData(
                            context,
                            backEndFirstDate,
                            backEndSecondDate,
                          );*/

                          // provideSaleList.length == 0
                          //     ? GetStorage().write("totalSales", "0")
                          //     : debugPrint("/totalSales/");
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                        child: Container(
                          height: 35.0,
                          width: 85.0,
                          decoration: BoxDecoration(
                            color:const Color.fromARGB(255, 40, 104, 163),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: const Center(
                              child: Text(
                                "Search",
                                style: TextStyle(letterSpacing: 1.0, color: Colors.white, fontWeight: FontWeight.w500),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(6.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           height: 40.0,
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //           ),
            //           child: Row(
            //             children: [
            //               Expanded(
            //                   flex: 5,
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         color: Color.fromARGB(255, 87, 141, 87),
            //                         borderRadius: BorderRadius.only(
            //                           topLeft: Radius.circular(5.0),
            //                           bottomLeft: Radius.circular(5.0),
            //                         )),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Icon(
            //                           Icons.monetization_on_outlined,
            //                           color: Colors.white,
            //                           size: 12.0,
            //                         ),
            //                         Text(
            //                           "Cash In",
            //                           style: TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 239, 244, 248)),
            //                         )
            //                       ],
            //                     ),
            //                   )),
            //               Expanded(
            //                   flex: 7,
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         color: Color.fromARGB(255, 184, 199, 173),
            //                         borderRadius: BorderRadius.only(
            //                           bottomRight: Radius.circular(5.0),
            //                           topRight: Radius.circular(5.0),
            //                         )),
            //                     child: Center(
            //                         child: Text(
            //                             "${double.parse(GetStorage().read("totalSales") ?? "0") + double.parse(GetStorage().read("totalAmountReceivedFromCustomer") ?? "0") + double.parse(GetStorage().read("totalAmountReceivedFromSupplier") ?? "0") + double.parse(GetStorage().read("totalCashReceived") ?? "0") + double.parse(GetStorage().read("totalBankWithdraw") ?? "0")}")),
            //                   )),
            //             ],
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 6),
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           height: 40.0,
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //           ),
            //           child: Row(
            //             children: [
            //               Expanded(
            //                   flex: 5,
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         color: Color.fromARGB(255, 87, 141, 87),
            //                         borderRadius: BorderRadius.only(
            //                           topLeft: Radius.circular(5.0),
            //                           bottomLeft: Radius.circular(5.0),
            //                         )),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Icon(
            //                           Icons.monetization_on_outlined,
            //                           color: Colors.white,
            //                           size: 12.0,
            //                         ),
            //                         Text(
            //                           "Cash Out",
            //                           style: TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 239, 244, 248)),
            //                         )
            //                       ],
            //                     ),
            //                   )),
            //               Expanded(
            //                   flex: 7,
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         color: Color.fromARGB(255, 184, 199, 173),
            //                         borderRadius: BorderRadius.only(
            //                           bottomRight: Radius.circular(5.0),
            //                           topRight: Radius.circular(5.0),
            //                         )),
            //                     child: Center(child: Text("tk.200.0")),
            //                   )),
            //             ],
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 6),
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           height: 40.0,
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //           ),
            //           child: Row(
            //             children: [
            //               Expanded(
            //                   flex: 5,
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         color: Color.fromARGB(255, 87, 141, 87),
            //                         borderRadius: BorderRadius.only(
            //                           topLeft: Radius.circular(5.0),
            //                           bottomLeft: Radius.circular(5.0),
            //                         )),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Icon(
            //                           Icons.monetization_on_outlined,
            //                           color: Colors.white,
            //                           size: 12.0,
            //                         ),
            //                         Text(
            //                           "Balance",
            //                           style: TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 239, 244, 248)),
            //                         )
            //                       ],
            //                     ),
            //                   )),
            //               Expanded(
            //                   flex: 7,
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         color: Color.fromARGB(255, 184, 199, 173),
            //                         borderRadius: BorderRadius.only(
            //                           bottomRight: Radius.circular(5.0),
            //                           topRight: Radius.circular(5.0),
            //                         )),
            //                     child: Center(child: Text("tk.200.0")),
            //                   )),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 5.0,),
            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Sales",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideSaleList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red.shade100,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Invoice'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Customer'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Received'))),
                              ),
                            ],
                            rows: List.generate(
                              provideSaleList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text("${provideSaleList[index].saleMasterInvoiceNo}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideSaleList[index].saleMasterSaleDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideSaleList[index].customerName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideSaleList[index].saleMasterPaidAmount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalReceived",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Received from Customers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideCashReceivedFromCustomerList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Invoice'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Customer'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Received'))),
                              ),
                            ],
                            rows: List.generate(
                              provideCashReceivedFromCustomerList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(
                                        child: Text("${provideCashReceivedFromCustomerList[index].cPaymentInvoice}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedFromCustomerList[index].cPaymentDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedFromCustomerList[index].customerName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedFromCustomerList[index].cPaymentAmount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalReceivedCustomer",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Received from Suppliers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideCashReceivedFromSupplierList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Invoice'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Supplier'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Received'))),
                              ),
                            ],
                            rows: List.generate(
                              provideCashReceivedFromSupplierList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(
                                        child: Text("${provideCashReceivedFromSupplierList[index].sPaymentInvoice}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedFromSupplierList[index].sPaymentDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedFromSupplierList[index].supplierName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedFromSupplierList[index].sPaymentAmount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalReceivedSupplier",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Cash Received",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideCashReceivedTransactionList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Transaction Id'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Account Name'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Received'))),
                              ),
                            ],
                            rows: List.generate(
                              provideCashReceivedTransactionList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedTransactionList[index].trSlNo}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedTransactionList[index].trDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedTransactionList[index].accName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashReceivedTransactionList[index].inAmount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalCashReceived",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Bank Withdraws",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideBankWithdrawTransactionList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Sl'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Account Name'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Account Number'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Bank Name'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Withdraw'))),
                              ),
                            ],
                            rows: List.generate(
                              provideBankWithdrawTransactionList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text("${provideBankWithdrawTransactionList[index].transactionId}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankWithdrawTransactionList[index].accountName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankWithdrawTransactionList[index].accountNumber}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankWithdrawTransactionList[index].bankName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankWithdrawTransactionList[index].transactionDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankWithdrawTransactionList[index].amount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalBankWithdraw",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Purchases",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: providePurchaseList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Invoice'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Supplier'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Paid'))),
                              ),
                            ],
                            rows: List.generate(
                              providePurchaseList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text("${providePurchaseList[index].purchaseMasterInvoiceNo}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${providePurchaseList[index].purchaseMasterOrderDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${providePurchaseList[index].supplierName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${providePurchaseList[index].purchaseMasterPaidAmount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalPaidPurchase",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Paid to Suppliers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideCashPaidToSupplierList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Invoice'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Supplier'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Paid'))),
                              ),
                            ],
                            rows: List.generate(
                              provideCashPaidToSupplierList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text("${provideCashPaidToSupplierList[index].sPaymentInvoice}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidToSupplierList[index].sPaymentDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidToSupplierList[index].supplierName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidToSupplierList[index].sPaymentAmount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalPaidToSupplier",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),

                    ),
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Paid to Customers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideCashPaidToCustomerList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Invoice'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Customer'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Paid'))),
                              ),
                            ],
                            rows: List.generate(
                              provideCashPaidToCustomerList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text("${provideCashPaidToCustomerList[index].cPaymentInvoice}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidToCustomerList[index].cPaymentDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidToCustomerList[index].customerName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidToCustomerList[index].cPaymentAmount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalPaidToCustomer",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Cash Paid",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideCashPaidTransactionList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Transaction Id'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Account Name'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Paid'))),
                              ),
                            ],
                            rows: List.generate(
                              provideCashPaidTransactionList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text("${provideCashPaidTransactionList[index].trSlNo}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidTransactionList[index].trDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidTransactionList[index].accName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideCashPaidTransactionList[index].outAmount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalCashPaid",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.blueGrey.shade100,
              child: const Center(
                  child: Text(
                    "Bank Deposits",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 15, 101, 199),
                    ),
                  )),
            ),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideBankDepositTransactionList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Sl'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Account Name'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Account Number'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Bank Name'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Deposit'))),
                              ),
                            ],
                            rows: List.generate(
                              provideBankDepositTransactionList.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text("${provideBankDepositTransactionList[index].transactionId}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankDepositTransactionList[index].accountName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankDepositTransactionList[index].accountNumber}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankDepositTransactionList[index].bankName}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankDepositTransactionList[index].transactionDate}")),
                                  ),
                                  DataCell(
                                    Center(child: Text("${provideBankDepositTransactionList[index].amount}")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total : ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "$totalBankDeposit",
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 15.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            /*const Center(
                child: Text(
                  "Employee Payments",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 15, 101, 199),
                  ),
                )),
            const SizedBox(height: 3.0),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
              height: provideEmployeePaymentList.isEmpty ? 50 : MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: DataTable(
                        headingRowHeight: 20.0,
                        dataRowHeight: 20.0,
                        showCheckboxColumn: true,
                        border: TableBorder.all(color: Colors.black54, width: 1),
                        columns: const [
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Employee Id'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Employee Name'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Date'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Month'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Amount'))),
                          ),
                        ],
                        rows: List.generate(
                          provideEmployeePaymentList.length,
                              (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Center(child: Text("${provideEmployeePaymentList[index].employeeID}")),
                              ),
                              DataCell(
                                Center(child: Text("${provideEmployeePaymentList[index].employeeName}")),
                              ),
                              DataCell(
                                Center(child: Text("${provideEmployeePaymentList[index].paymentDate}")),
                              ),
                              DataCell(
                                Center(child: Text("${provideEmployeePaymentList[index].monthName}")),
                              ),
                              DataCell(
                                Center(child: Text("${provideEmployeePaymentList[index].paymentAmount}")),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),*/
          ],
        ),
      ),
    );
  }
}
