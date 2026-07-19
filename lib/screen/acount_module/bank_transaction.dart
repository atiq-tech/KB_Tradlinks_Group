import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/bank_account_provider.dart';
import 'package:kbtradlink/provider/bank_transaction_provider.dart';
import 'package:kbtradlink/screen/acount_module/model/bank_account_model.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankTransactionPage extends StatefulWidget {
  const BankTransactionPage({super.key});

  @override
  State<BankTransactionPage> createState() => _BankTransactionPageState();
}

class _BankTransactionPageState extends State<BankTransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController accountController = TextEditingController();

  String? _selectedAccount;
  String? firstPickedDate;
  var backEndFirstDate;
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
        BankTransactionProvider().on();
        Provider.of<BankTransactionProvider>(context, listen: false).getBankTransactionList("","${backEndFirstDate}","${backEndFirstDate}","");

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

  String? paymentType;
  String? _transactionType = 'Deposit';
  final List<String> _transactionTypeList = [
    'Deposit',
    'Withdraw',
  ];
  bool isLoading = false;


  ScrollController mainScrollController = ScrollController();
  late ScrollController _listViewScrollController = ScrollController()
    ..addListener(listViewScrollListener);
  ScrollPhysics _physics = ScrollPhysics();

  void listViewScrollListener() {
    
    if (_listViewScrollController.offset >=
        _listViewScrollController.position.maxScrollExtent &&
        !_listViewScrollController.position.outOfRange) {
      if (mainScrollController.offset == 0) {
        mainScrollController.animateTo(50,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
      }
      setState(() {
        _physics = NeverScrollableScrollPhysics();
      });
      print("bottom");
    }
  }

  void mainScrollListener() {
    if (mainScrollController.offset <=
        mainScrollController.position.minScrollExtent &&
        !mainScrollController.position.outOfRange) {
      setState(() {
        if (_physics is NeverScrollableScrollPhysics) {
          _physics = ScrollPhysics();

          _listViewScrollController.animateTo(
              _listViewScrollController.position.maxScrollExtent - 50,
              duration: Duration(milliseconds: 200),
              curve: Curves.linear);
        }
      });
      print("top");
    }
  }

  @override
  void initState() {
    paymentType = "deposit";
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    //bank ACCOUNTS
    // getBankTransactionData(backEndFirstDate);
    BankTransactionProvider.isLoading=true;
    Provider.of<BankTransactionProvider>(context, listen: false).bankTransactionList = [];
    Provider.of<BankTransactionProvider>(context, listen: false).getBankTransactionList("","${Utils.formatBackEndDate(DateTime.now())}","${Utils.formatBackEndDate(DateTime.now())}","");
    Provider.of<BankAccountProvider>(context, listen: false).getBankAccountList();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    mainScrollController.addListener(mainScrollListener);

    final allBankTransaction = Provider.of<BankTransactionProvider>(context).bankTransactionList;

    return Scaffold(
      appBar: const CustomAppBar(title: "Bank Transaction"),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: SingleChildScrollView(
          controller: mainScrollController,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top:4.0,left: 4.0, right: 4.0,bottom: 4.0),
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
                        children: [
                          const Expanded(
                            flex: 5,
                            child: Text(
                              "Date",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: Container(
                              margin: const EdgeInsets.only(
                              //  right: 5,
                                bottom: 5,
                              ),
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
                                    contentPadding:
                                    const EdgeInsets.only(top: 2, left: 5),
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
                                    hintText:firstPickedDate,
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

                      Row(
                        children: [
                          const Expanded(
                            flex: 5,
                            child: Text(
                              "Account",
                              style: TextStyle(
                                  fontSize: 14.0,
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
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                          controller: accountController,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(bottom: 12),
                                            hintText: 'Select Account',
                                            suffix: _selectedAccount == '' ? null : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  accountController.text = '';
                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 3),
                                                child: Icon(Icons.close,size: 14,),
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
                                        //   ListTile(
                                        //   title: SizedBox(child: Text("${suggestion.accountName} - ${suggestion.accountNumber} (${suggestion.bankName})",style: const TextStyle(fontSize: 11), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                        // );
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
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          const Expanded(
                            flex: 5,
                            child: Text(
                              "Transaction Type",
                              style: TextStyle(
                                  fontSize: 14.0,
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
                                    'Select Type',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54
                                    ),
                                  ), // Not necessary for Option 1
                                  value: _transactionType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _transactionType = newValue!;
                                      if (newValue == "Deposit") {
                                        paymentType = "deposit";
                                      }
                                      if (newValue == "Withdraw") {
                                        paymentType = "withdraw";
                                      }
                                    });
                                  },
                                  items: _transactionTypeList.map((location) {
                                    return DropdownMenuItem(
                                      value: location,
                                      child: Text(
                                        location,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
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
                            flex: 5,
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: SizedBox(
                              height: 30.0,
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                style: const TextStyle(fontSize: 13),
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "0",
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
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
                            flex: 5,
                            child: Text(
                              "Note",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: SizedBox(
                              height: 30.0,
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                style: const TextStyle(fontSize: 13),
                                controller: _noteController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 5.0),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
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
                            Utils.closeKeyBoard(context);
                            if(accountController.text==''){
                              Utils.errorSnackBar(context, "Account field is required");
                            }
                            else if(_amountController.text == ""){
                              Utils.errorSnackBar(context, "Amount field is required");
                            }
                            else{
                              setState(() {
                                isLoading = true;
                              });
                              print("asjdfnhkasjfn $paymentType");
                              fetchAddBankTransactions(
                                context,
                                "$_selectedAccount",
                                _amountController.text,
                                _noteController.text,
                                "$backEndFirstDate",
                                0,
                                "$paymentType",
                              ).then((value){
                                if(value!=""){
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Provider.of<BankTransactionProvider>(context, listen: false).getBankTransactionList("","${Utils.formatBackEndDate(DateTime.now())}","${Utils.formatBackEndDate(DateTime.now())}","");
                                  _amountController.text='';
                                  accountController.text='';
                                  _noteController.text='';
                                  setState(() {

                                  });
                                }
                              });

                            }
                          },
                          child: Container(
                            height: 35.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 131, 224, 146),
                                  width: 2.0),
                              color: const Color.fromARGB(255, 5, 120, 165),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // changes the position of the shadow
                                ),
                              ],
                            ),
                            child: Center(
                                child: isLoading ? const SizedBox(height: 20,width:20,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                                  "SAVE",
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
              BankTransactionProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                height: MediaQuery.of(context).size.height / 1.43,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: allBankTransaction.isNotEmpty
                    ? SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    controller: _listViewScrollController,
                    physics: _physics,
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowHeight: 20.0,
                        dataRowHeight: 20.0,
                        showCheckboxColumn: true,
                        border: TableBorder.all(
                            color: Colors.black54, width: 1),
                        columns: const [
                          DataColumn(
                            label:
                            Expanded(child: Center(child: Text('Transaction Date'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Account Name'))),
                          ),
                          DataColumn(
                            label:
                            Expanded(child: Center(child: Text('Account Number'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Bank Name'))),
                          ),
                          DataColumn(
                            label:
                            Expanded(child: Center(child: Text('Transaction Type'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Note'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Amount'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Saved By '))),
                          ),
                        ],
                        rows: List.generate(
                          allBankTransaction.length>100?100:allBankTransaction.length,
                              (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Center(
                                    child: Text(
                                        allBankTransaction[index].transactionDate)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allBankTransaction[index].accountName)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allBankTransaction[index].accountNumber)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allBankTransaction[index].bankName)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allBankTransaction[index].transactionType)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allBankTransaction[index].note)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allBankTransaction[index].amount)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allBankTransaction[index].savedBy)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    : Text("No Record Found",textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade600),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String>fetchAddBankTransactions(
      context,
      String? account_id,
      String? amount,
      String? note,
      String? transaction_date,
      int? transaction_id,
      String? transaction_type,
      ) async {
    String Link = "${baseUrl}api/v1/addBankTransaction";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(Link,
          data: {
            "account_id": "$account_id",
            "amount": "$amount",
            "note": "$note",
            "transaction_date": "$transaction_date",
            "transaction_id": "$transaction_id",
            "transaction_type": "$transaction_type",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var data = jsonDecode(response.data);
      if(data['success']==true){
        print("CashTransactions CashTransactions:::${data}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.white, fontSize: 16),))));
        return "true";
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.red, fontSize: 16),))));
        return "";
      }
    } catch (e) {
      print("Something is wrong all Add bank Transactions list=======:$e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Center(child: Text(e.toString(),style: const TextStyle(color: Colors.red, fontSize: 16),))));
      return "";
    }
  }
}
