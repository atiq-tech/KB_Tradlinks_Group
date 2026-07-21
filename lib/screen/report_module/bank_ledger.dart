//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/bank_account_provider.dart';
import 'package:kbtradlink/provider/bank_ledger_provider.dart';
import 'package:kbtradlink/screen/acount_module/model/bank_account_model.dart';
import 'package:kbtradlink/utils/all_textstyle.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class BankLedger extends StatefulWidget {
  const BankLedger({super.key});

  @override
  State<BankLedger> createState() => _BankLedgerState();
}
class _BankLedgerState extends State<BankLedger> {
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

  String? _selectedAccount;

  bool isLoading = false;
  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    Provider.of<BankLedgerProvider>(context,listen: false).bankLedgerModel = null;

    // TODO: implement initState
    super.initState();
  }
  var accountController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final allBankLedgerData = Provider.of<BankLedgerProvider>(context).bankLedgerModel;
    final allWithdrawBalance = allBankLedgerData?.transactions.fold(0.0, (p, e) => p+double.parse("${e.withdraw}"));
    final allDipositBalance = allBankLedgerData?.transactions.fold(0.0, (p, e) => p+double.parse("${e.deposit}"));
    print('jfsdkhf $allDipositBalance $allWithdrawBalance');
    return Scaffold(
      appBar: const CustomAppBar(title: "Bank Ledger"),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0,bottom: 4.0),
              decoration: BoxDecoration(
                color: Colors.lightGreen.shade100,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 7, 125, 180),
                    width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), 
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                     Expanded(flex: 4,child: Text("Account",style: AllTextStyle.dateFormatStyle)),
                     Expanded(flex: 1,child: Text(":",style: AllTextStyle.dateFormatStyle)),
                     Expanded(
                        flex: 12,
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
                            future: Provider.of<BankAccountProvider>(context).getBankAccountList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TypeAheadFormField(
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                      onChanged: (value){
                                        if (value == '') {
                                          _selectedAccount = '';
                                        }
                                      },
                                      style: AllTextStyle.dateFormatStyle,
                                      controller: accountController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(bottom: 11),
                                        hintText: 'Select Account',
                                        hintStyle: AllTextStyle.dateFormatStyle,
                                        suffix: _selectedAccount == '' ? null : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              accountController.text = '';
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                            child: Icon(Icons.close,size: 14),
                                          ),
                                        ),
                                      )
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return snapshot.data!
                                        .where((element) => element.accountName
                                        .toLowerCase()
                                        .contains(pattern
                                        .toString()
                                        .toLowerCase()))
                                        .take(snapshot.data!.length)
                                        .toList();
                                    // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        child: Text(
                                          "${suggestion.accountName} - ${suggestion.accountNumber} - ${suggestion.bankName}",
                                          style: const TextStyle(fontSize: 12),
                                          maxLines: 1,overflow: TextOverflow.ellipsis,),
                                      ),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected:
                                      (BankAccountModel suggestion) {
                                    accountController.text = "${suggestion.accountName}-${suggestion.accountNumber} (${suggestion.bankName})";
                                    setState(() {
                                      _selectedAccount = suggestion.accountId.toString();
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
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(flex: 4,child: Text("Date From",style: AllTextStyle.dateFormatStyle)),
                      Expanded(flex: 1,child: Text(":",style: AllTextStyle.dateFormatStyle)),
                      Expanded(
                        flex: 12,
                        child: Container(
                          height: 30,
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
                                contentPadding: const EdgeInsets.only(
                                  top: 2,
                                  left: 5,
                                ),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
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
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(flex: 4,child: Text("Date To",style: AllTextStyle.dateFormatStyle)),
                      Expanded(flex: 1,child: Text(":",style: AllTextStyle.dateFormatStyle)),
                      Expanded(
                        flex: 12,
                        child: Container(
                          height: 30,
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
                                contentPadding:const EdgeInsets.only(top: 2, left: 5),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Icon(Icons.calendar_month,color: Colors.black87,size: 16),
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
                        //final connectivityResult = await (Connectivity().checkConnectivity());

                        if (accountController.text == "") {
                          Utils.errorSnackBar(context, "Please Select Product");
                        } else {
                          // if (connectivityResult ==
                          //     ConnectivityResult.mobile ||
                          //     connectivityResult == ConnectivityResult.wifi) {
                            setState(() {
                              BankLedgerProvider().on();
                            });
                            Provider.of<BankLedgerProvider>(context, listen: false)
                                .getBankLedger(
                                "$_selectedAccount",
                                "$backEndFirstDate",
                                "$backEndSecondDate");
                          } 
                        //   else {
                        //     Utils.errorSnackBar(
                        //         context, "Please connect with internet");
                        //   }
                        // }
                      },
                      child: Container(
                        height: 35.0,
                        width: 75.0,
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
                              "Show",
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
          BankLedgerProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : allBankLedgerData != null
              ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
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
                            border: TableBorder.all(
                                color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(
                                    child: Center(child: Text('Transaction Date'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Description'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(child: Text('Note'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Deposit'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                        child: Text('Withdraw'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(child: Text('Balance'))),
                              ),
                            ],
                            rows: List.generate(
                              allBankLedgerData.transactions.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allBankLedgerData.transactions[index].transactionDate}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allBankLedgerData.transactions[index].description}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            "${allBankLedgerData.transactions[index].note}")),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allBankLedgerData.transactions[index].deposit}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allBankLedgerData.transactions[index].withdraw}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allBankLedgerData.transactions[index].balance}')),
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
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Withdrew Balance: $allWithdrawBalance",style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold
                      ),),
                      Text("Total Deposit Balance: $allDipositBalance",style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold
                      )),
                    ],
                  ),
                )
              ],
            ),
          ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle)))
        ],
      ),
    );
  }
}
