//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/account_provider.dart';
import 'package:kbtradlink/provider/cash_transaction_provider.dart';
import 'package:kbtradlink/screen/acount_module/model/account_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class CashTransactionReportPage extends StatefulWidget {
  const CashTransactionReportPage({super.key});

  @override
  State<CashTransactionReportPage> createState() =>
      _CashTransactionReportPageState();
}

class _CashTransactionReportPageState extends State<CashTransactionReportPage> {
  String? paymentType;
  String? _selectedType = 'All';

  double? receivedAmount;
  double? paymentAmount;

  final List<String> _selectedTypeList = [
    'All',
    'Received',
    'Payment',
  ];

  final TextEditingController accountController = TextEditingController();

  String? firstPickedDate;
  String? backEndFirstDate;
  String? backEndSecondDate;
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
    } else {
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
    } else {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $secondPickedDate");
      });
    }
  }

  bool isLoading = false;

  String? _selectedAccount;
  String accountId = "";
  // ApiAllAccounts? apiAllAccounts;
  // ApiAllCashTransactions? apiAllCashTransactions;
  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    paymentType = '';
    // // ACCOUNTS
    // ApiAllAccounts apiAllAccounts;

    Provider.of<CashTransactionProvider>(context, listen: false)
        .cashTransactionList = [];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCashTnxList =
        Provider.of<CashTransactionProvider>(context).cashTransactionList;
    receivedAmount = allCashTnxList
        .where((element) => element.trType == 'In Cash')
        .map((e) => e.inAmount)
        .fold(0.0, (p, element) => p! + double.parse("${element}"));
    print('ReceivedAmount === $receivedAmount');
    paymentAmount = allCashTnxList
        .where((element) => element.trType == 'Out Cash')
        .map((e) => e.outAmount)
        .fold(0.0, (p, element) => p! + double.parse("${element}"));
    print('PaymentAmount === $paymentAmount');

    return Scaffold(
      appBar: const CustomAppBar(title: "Cash Transaction Report"),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150.0,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
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
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 6,
                        child: Text(
                          "Transaction Type",
                          style: TextStyle(
                              color: Color.fromARGB(255, 126, 125, 125)),
                        ),
                      ),
                      const Expanded(flex: 1, child: Text(":")),
                      Expanded(
                        flex: 11,
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: const Text(
                                'All',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              dropdownColor: const Color.fromARGB(255, 231, 251,
                                  255), // Not necessary for Option 1
                              value: _selectedType,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedType = newValue!;
                                  if (newValue == "All") {
                                    paymentType = "";
                                  }
                                  if (newValue == "Received") {
                                    paymentType = "received";
                                  }
                                  if (newValue == "Payment") {
                                    paymentType = "paid";
                                  }
                                });
                              },
                              items: _selectedTypeList.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(
                                    location,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Expanded(
                        flex: 6,
                        child: Text(
                          "Accounts",
                          style: TextStyle(
                              color: Color.fromARGB(255, 126, 125, 125)),
                        ),
                      ),
                      const Expanded(flex: 1, child: Text(":")),
                      Expanded(
                        flex: 11,
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
                          child: FutureBuilder(
                            future: Provider.of<AccountProvider>(context)
                                .getAccountList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          onChanged: (value) {
                                            if (value == '') {
                                              _selectedAccount = '';
                                            }
                                          },
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                          controller: accountController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            contentPadding: const EdgeInsets.only(bottom: 12),
                                            hintText: 'Select Account',
                                            suffix: _selectedAccount == ''
                                                ? null
                                                : GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        accountController.text =
                                                            '';
                                                        accountId = '';
                                                      });
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 14
                                                      ),
                                                    ),
                                                  ),
                                          )),
                                  suggestionsCallback: (pattern) {
                                    return snapshot.data!
                                        .where((element) => element.accName
                                            .toLowerCase()
                                            .contains(pattern
                                                .toString()
                                                .toLowerCase()))
                                        .take(snapshot.data!.length)
                                        .toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Text(
                                          "${suggestion.accName}",
                                          style: const TextStyle(fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected:
                                      (AccountModel suggestion) {
                                    accountController.text =
                                        "${suggestion.accName}-${suggestion.accCode}";
                                    setState(() {
                                      _selectedAccount =
                                          suggestion.accSlNo.toString();
                                      accountId = suggestion.accSlNo.toString();
                                    });
                                  },
                                  onSaved: (value) {},
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: 5,
                            bottom: 5,
                          ),
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 7, 125, 180))),
                          child: GestureDetector(
                            onTap: (() {
                              _firstSelectedDate();
                            }),
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(top: 2, left: 10),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.black87,
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
                        child: const Text("to"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.only(
                            left: 5,
                            bottom: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 7, 125, 180))),
                          child: GestureDetector(
                            onTap: (() {
                              _secondSelectedDate();
                            }),
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(top: 2, left: 10),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.black87,
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

                  // const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        // final connectivityResult =
                        //     await (Connectivity().checkConnectivity());

                        // if (connectivityResult == ConnectivityResult.mobile ||
                        //     connectivityResult == ConnectivityResult.wifi) {
                          CashTransactionProvider().on();
                          Provider.of<CashTransactionProvider>(context,
                                  listen: false)
                              .getCashTransactionList(
                                  "${accountId}",
                                  "${backEndFirstDate}",
                                  "${backEndSecondDate}",
                                  "${paymentType}");
                        // } else {
                        //   Utils.errorSnackBar(
                        //       context, "Please connect with internet");
                        // }
                      },
                      child: Container(
                        height: 35.0,
                        width: 85.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 7, 125, 180),
                          borderRadius: BorderRadius.circular(6.0),
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
                        child: const Center(
                            child: Text(
                          "Search",
                          style: TextStyle(
                              letterSpacing: 1.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          CashTransactionProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : allCashTnxList.isNotEmpty
                  ? Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: DataTable(
                                    headingRowHeight: 20.0,
                                    dataRowHeight: 20.0,
                                    showCheckboxColumn: true,
                                    border: TableBorder.all(
                                        color: Colors.black54, width: 1),
                                    columns: [
                                      const DataColumn(
                                        label: Expanded(
                                            child:
                                                Center(child: Text('Tr.Id'))),
                                      ),
                                      const DataColumn(
                                        label: Expanded(
                                            child: Center(child: Text('Date'))),
                                      ),
                                      const DataColumn(
                                        label: Expanded(
                                            child:
                                                Center(child: Text('Tr.Type'))),
                                      ),
                                      const DataColumn(
                                        label: Expanded(
                                            child: Center(
                                                child: Text('Account Name'))),
                                      ),
                                      const DataColumn(
                                        label: Expanded(
                                            child: Center(
                                                child: Text('Description'))),
                                      ),
                                      const DataColumn(
                                        label: Expanded(
                                            child: Center(
                                                child:
                                                    Text('Received Amount'))),
                                      ),
                                      const DataColumn(
                                        label: Expanded(
                                            child: Center(
                                                child: Text('Payment Amount'))),
                                      ),
                                    ],
                                    rows: List.generate(
                                      allCashTnxList.length,
                                      (int index) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            Center(
                                                child: Text(
                                                    '${allCashTnxList[index].trId}')),
                                          ),
                                          DataCell(
                                            Center(
                                                child: Text(
                                                    '${allCashTnxList[index].trDate}')),
                                          ),
                                          DataCell(Center(
                                              child: Text(
                                                  '${allCashTnxList[index].trType}') /* ==
                                                    "Out Cash"
                                                ? Text('Cash Payment')
                                                : Text('Cash Received'),*/
                                              )),
                                          DataCell(
                                            Center(
                                                child: Text(
                                                    '${allCashTnxList[index].accName}')),
                                          ),
                                          DataCell(
                                            Center(
                                                child: Text(
                                                    '${allCashTnxList[index].trDescription}')),
                                          ),
                                          DataCell(
                                            Center(
                                                child: /*allCashTnxList[index]
                                                        .trType ==
                                                    "In Cash"
                                                ? */
                                                    Text(
                                                        '${allCashTnxList[index].inAmount}') /*: const Text(" ")*/),
                                          ),
                                          DataCell(
                                            Center(
                                                child: /*allCashTnxList[index]
                                                        .trType ==
                                                    "Out Cash" || allCashTnxList[index]
                                                        .trType ==
                                                    "Cash Payment"
                                                ? */
                                                    Text(
                                                        '${allCashTnxList[index].outAmount}') /*: const Text(" "),*/),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Total Received Amount     :  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("$receivedAmount"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Total Payment Amount     :  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("$paymentAmount"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          "No Data Found",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      )),
        ],
      ),
    );
  }
}
