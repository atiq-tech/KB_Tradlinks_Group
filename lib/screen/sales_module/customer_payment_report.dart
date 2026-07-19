//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/customer_ledger_provider.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class CustomerPaymentReport extends StatefulWidget {
  const CustomerPaymentReport({super.key});

  @override
  State<CustomerPaymentReport> createState() => _CustomerPaymentReportState();
}

class _CustomerPaymentReportState extends State<CustomerPaymentReport> {
  final TextEditingController customerController = TextEditingController();
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
        print("Firstdateee $firstPickedDate");
      });
    } else {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
        print("Firstdateee $firstPickedDate");
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
        print("Firstdateee $secondPickedDate");
      });
    } else {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondDate = Utils.formatBackEndDate(toDay);
        print("Firstdateee $secondPickedDate");
      });
    }
  }

  String? _selectedCustomer;

  /// total Amount
  double? billAmount;
  double? paidAmount;
  double? invDueAmount;
  double? returnedAmount;
  double? paidOutAmount;
  String? balanceAmount;

  @override
  void initState() {
    // firstPickedDate = "2000-03-01";
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    Provider.of<CustomerListProvider>(context, listen: false)
        .getCustomerList(context, customerType: '');
    // Provider.of<CustomerPaymentReportProvider>(context,listen: false).getCustomerLedgerList(context,customerId: "",dateFrom: "",dateTo: "");
    Provider.of<CustomerPaymentReportProvider>(context, listen: false)
        .customerPaymentReportList = [];
    super.initState();
  }

  var previousBalance;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var box = await Hive.openBox('profile');
    previousBalance = box.get("preBal");
  }

  @override
  Widget build(BuildContext context) {
    final allCustomersData = Provider.of<CustomerListProvider>(context)
        .customerList
        .where((element) => element.displayName != "General Customer");
    final allCustomerLedgerData =
        Provider.of<CustomerPaymentReportProvider>(context)
            .customerPaymentReportList;

    /// total Amount
    billAmount = allCustomerLedgerData
        .map((e) => e.bill)
        .fold(0.0, (p, element) => p! + double.parse("$element"));
    paidAmount = allCustomerLedgerData
        .map((e) => e.paid)
        .fold(0.0, (p, element) => p! + double.parse("$element"));
    invDueAmount = allCustomerLedgerData
        .map((e) => e.due)
        .fold(0.0, (p, element) => p! + double.parse("$element"));
    returnedAmount = allCustomerLedgerData
        .map((e) => e.returned)
        .fold(0.0, (p, element) => p! + double.parse("$element"));
    paidOutAmount = allCustomerLedgerData
        .map((e) => e.paidOut)
        .fold(0.0, (p, element) => p! + double.parse("$element"));
    allCustomerLedgerData.isNotEmpty
    ? balanceAmount = allCustomerLedgerData.map((e) => e.balance).toList().last
    : null;

    // depositValue = allBankTransactionData.where((element) => element.transactionType == 'deposit').map((e) => e.amount).fold(0.0, (p, element) => p! + double.parse("${element}"));
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Customer Payment Report",
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Column(
          children: [
            Container(
              height: 120.0,
              padding: const EdgeInsets.only(
                  top: 6.0, left: 6.0, right: 6.0, bottom: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xffD2D2FF),
                //color: Colors.yellow.shade50,
                //color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 7, 125, 180), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(
                        0, 3), // changes the position of the shadow
                  ),
                ],
              ),
              child: Column(children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Customer  :",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 30.0,
                        width: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.only(left: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(255, 5, 107, 155),
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            onChanged: (value) {
                              if (value == '') {
                                _selectedCustomer = '';
                              }
                            },
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            controller: customerController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(bottom: 12),
                              hintText: 'Select Customer',
                              suffix: _selectedCustomer == ''
                                  ? null
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          customerController.text = '';
                                        });
                                      },
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 3),
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return allCustomersData
                                .where((element) => element.displayName!
                                    .toLowerCase()
                                    .contains(pattern.toString().toLowerCase()))
                                .take(allCustomersData.length)
                                .toList();
                            // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                          },
                          itemBuilder: (context, suggestion) {
                            return SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  "${suggestion.customerCode} - ${suggestion.customerName} - - ${suggestion.customerAddress}",
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                            //   ListTile(
                            //   title: SizedBox(child: Text("${suggestion.displayName}",style: const TextStyle(fontSize: 12), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                            // );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (CustomerModel suggestion) {
                            customerController.text = suggestion.displayName!;
                            setState(() {
                              _selectedCustomer =
                                  suggestion.customerSlNo.toString();
                            });
                          },
                          onSaved: (value) {},
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3.0,
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(right: 5, bottom: 5),
                          height: 30,
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 125, 180),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: GestureDetector(
                            onTap: (() {
                              _firstSelectedDate();
                            }),
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(top: 10, left: 5),
                                filled: true,
                                // fillColor: Colors.blue[50],
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Color.fromARGB(221, 22, 51, 95),
                                    size: 16,
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: firstPickedDate,
                                hintStyle: const TextStyle(
                                    fontSize: 13, color: Colors.black87),
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
                      Container(
                        child: const Text("To"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(left: 5, bottom: 5),
                          height: 30,
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(255, 7, 125, 180),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: GestureDetector(
                            onTap: (() {
                              _secondSelectedDate();
                            }),
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(top: 10, left: 5),
                                filled: true,
                                //fillColor: Colors.blue[50],
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Color.fromARGB(221, 22, 51, 95),
                                    size: 16,
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: secondPickedDate,
                                hintStyle: const TextStyle(
                                    fontSize: 13, color: Colors.black87),
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
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    child: InkWell(
                      onTap: () async {
                        // final connectivityResult =
                        //     await (Connectivity().checkConnectivity());

                        // if (connectivityResult == ConnectivityResult.mobile ||
                        //     connectivityResult == ConnectivityResult.wifi) {
                          if (customerController.text == '') {
                            Utils.errorSnackBar(
                                context, "Please Select Customer");
                          } else {
                            setState(() {
                              CustomerPaymentReportProvider().on();
                            });
                            Provider.of<CustomerPaymentReportProvider>(context,
                                    listen: false)
                                .getCustomerLedgerList(context,
                                    customerId: "$_selectedCustomer",
                                    dateFrom: "$backEndFirstDate",
                                    dateTo: "$backEndSecondDate");
                          }
                        // } else {
                        //   Utils.errorSnackBar(
                        //       context, "Please connect with internet");
                        // }
                      },
                      child: Container(
                        height: 32.0,
                        width: 105.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 4, 113, 185),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Center(
                            child: Text(
                          "Show Report",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomerPaymentReportProvider.isLoading
                ? const Center(child: CircularProgressIndicator()):
                // : allCustomerLedgerData.isNotEmpty
                //     ?
            Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.31,
                          width: double.infinity,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, bottom: 10.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Previous Balance: ${previousBalance??0.0}",
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      DataTable(
                                        headingRowHeight: 20.0,
                                        dataRowHeight: 20.0,
                                        showCheckboxColumn: true,
                                        border: TableBorder.all(
                                            color: Colors.black54, width: 1),
                                        columns: const [
                                          DataColumn(
                                            label: Expanded(
                                                child: Center(
                                                    child: Text('Date'))),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                                child: Center(
                                                    child:
                                                        Text('Description'))),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                                child: Center(
                                                    child: Text('Bill'))),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                                child: Center(
                                                    child: Text('Paid'))),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                                child: Center(
                                                    child: Text('Inv.Due'))),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                                child: Center(
                                                    child: Text('Retruned'))),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                                child: Center(
                                                    child: Text(
                                                        'Paid to customer'))),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                                child: Center(
                                                    child: Text('Balance'))),
                                          ),
                                        ],
                                        rows: List.generate(
                                          allCustomerLedgerData.length,
                                          (int index) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        allCustomerLedgerData[
                                                                index]
                                                            .date
                                                            .toString())),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        allCustomerLedgerData[
                                                                index]
                                                            .description
                                                            .toString())),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        allCustomerLedgerData[
                                                                index]
                                                            .bill
                                                            .toString())),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        allCustomerLedgerData[
                                                                index]
                                                            .paid
                                                            .toString())),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        allCustomerLedgerData[
                                                                index]
                                                            .due
                                                            .toString())),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        allCustomerLedgerData[
                                                                index]
                                                            .returned
                                                            .toString())),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        allCustomerLedgerData[
                                                                index]
                                                            .paidOut
                                                            .toString())),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Text(
                                                        ("${allCustomerLedgerData[index].balance.toString()}"))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Bill                              :  ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$billAmount"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Paid                            :  ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$paidAmount"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Inv.Due                       :  ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$invDueAmount"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Retruned                    :  ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$returnedAmount"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Paid to Customer     :  ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$paidOutAmount"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Balance                      :  ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("${balanceAmount??0.0}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
            //         : Align(
            //             alignment: Alignment.center,
            //             child: Visibility(
            //               visible: previousBalance != null,
            //               child: Text(
            //                 "Previous Balance: $previousBalance",
            //                 style: const TextStyle(fontSize: 16, color: Colors.red),
            //               ),
            //             ),
            // ),
          ],
        ),
      ),
    );
  }
}
