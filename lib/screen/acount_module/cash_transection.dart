import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/account_provider.dart';
import 'package:kbtradlink/provider/cash_transaction_provider.dart';
import 'package:kbtradlink/screen/acount_module/model/account_model.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashTransactionPage extends StatefulWidget {
  const CashTransactionPage({super.key});

  @override
  State<CashTransactionPage> createState() => _CashTransactionPageState();
}

class _CashTransactionPageState extends State<CashTransactionPage> {
  final _DescriptionController = TextEditingController();
  final _AmountController = TextEditingController();
  final tnxIdNoController = TextEditingController();


  String? paymentType;
  String? _selectedType;
  final List<String> _selectedTypeList = [
    'Cash Receive',
    'Cash Payment',
  ];
  String? _selectedAccount;
  String? firstPickedDate;
  var backEndFirstDate;
  var toDay = DateTime.now();

  void firstSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndFirstDate = Utils.formatBackEndDate(selectedDate);
        CashTransactionProvider.isLoading = true;
        Provider.of<CashTransactionProvider>(context, listen: false).getCashTransactionList("","${backEndFirstDate}","${backEndFirstDate}","");
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

  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    _selectedType = 'Cash Receive';
    paymentType = 'Cash Received';
    getCashTransactionId();
    // ACCOUNTS
    CashTransactionProvider.isLoading = true;
    Provider.of<CashTransactionProvider>(context, listen: false).cashTransactionList = [];
    Provider.of<CashTransactionProvider>(context, listen: false).getCashTransactionList("","${Utils.formatBackEndDate(DateTime.now())}","${Utils.formatBackEndDate(DateTime.now())}","");
    // TODO: implement initState
    super.initState();
  }

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

  final  _accountController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    mainScrollController.addListener(mainScrollListener);

     //Get Cash Transaction
    final allCashTransaction = Provider.of<CashTransactionProvider>(context).cashTransactionList;

    return Scaffold(
      appBar: const CustomAppBar(title: "Cash Transaction"),
      body: SingleChildScrollView(
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
                            "Transaction Id",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(':')),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: const Color.fromARGB(255, 7, 125, 180))),
                            child: TextField(
                              style: const TextStyle(fontSize: 13,color: Colors.black),
                              controller: tnxIdNoController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(bottom: 17,left: 5),
                                enabled: false,
                                filled: true,
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
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Date",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 5,
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
                                firstSelectedDate();
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
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
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
                                // hint: const Text(
                                //   'Select Type',
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //   ),
                                // ),
                                dropdownColor: const Color.fromARGB(255, 231, 251,
                                    255), // Not necessary for Option 1
                                value: _selectedType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedType = newValue!;
                                    if (newValue == "Cash Receive") {
                                      paymentType = "Cash Received";
                                    }
                                    if (newValue == "Cash Payment") {
                                      paymentType = "Cash Payment";
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
                    const SizedBox(height: 3.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Account",
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
                              future: Provider.of<AccountProvider>(context).getAccountList(),
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
                                        controller: _accountController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(bottom: 12),
                                          hintText: 'Select account',
                                          suffix: _selectedAccount == '' ? null : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _accountController.text = '';
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
                                          .where((element) => element.accName
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
                                            suggestion.accName,
                                            style: const TextStyle(fontSize: 12),
                                            maxLines: 1,overflow: TextOverflow.ellipsis,),
                                        ),
                                      );
                                      //   ListTile(
                                      //   title: SizedBox(child: Text("${suggestion.accName}",style: const TextStyle(fontSize: 12), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                      // );
                                    },
                                    transitionBuilder:
                                        (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    onSuggestionSelected:
                                        (AccountModel suggestion) {
                                      _accountController.text = suggestion.accName;
                                      setState(() {
                                        _selectedAccount = suggestion.accSlNo.toString();
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
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Description",
                            style: TextStyle(
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
                              controller: _DescriptionController,
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Amount",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height: 28.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _AmountController,
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
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Utils.closeKeyBoard(context);
                            if(_accountController.text ==''){
                               Utils.errorSnackBar(context, "Account field is required");
                            }
                            else if(_AmountController.text == ''){
                              Utils.errorSnackBar(context, "Amount field is required");
                            }
                            else{
                              setState(() {
                                isLoading = true;
                              });
                              fetchAddCashTransactions(
                                context,
                                "$_selectedAccount",
                                0,
                                int.parse(_AmountController.text),
                                _DescriptionController.text,
                                tnxIdNoController.text,
                                0,
                                "$paymentType",
                                "Official",
                                "$backEndFirstDate",
                              ).then((value){
                                if(value=="true"){
                                  _AmountController.text = '';
                                  _DescriptionController.text = '';
                                  _selectedAccount = "";
                                  _accountController.text = "";
                                  Provider.of<CashTransactionProvider>(context, listen: false).getCashTransactionList("","${Utils.formatBackEndDate(DateTime.now())}","${Utils.formatBackEndDate(DateTime.now())}","");
                                  getCashTransactionId();
                                  setState(() {

                                  });
                                }
                              });
                              // Future.delayed(Duration(seconds: 1),() {
                              //   setState(() {
                              //     isLoading = false;
                              //   });
                              // },);
                            }
                          },
                          child: Container(
                            height: 35.0,
                            width: 85.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 75, 196, 201),
                                  width: 2.0),
                              color: const Color.fromARGB(255, 105, 170, 88),
                              borderRadius: BorderRadius.circular(10.0),
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
                        const SizedBox(width: 4.0),
                        InkWell(
                          onTap: () {
                            _AmountController.text = '';
                            _DescriptionController.text = '';
                            _selectedAccount = "";
                            _accountController.text = "";
                          },
                          child: Container(
                            height: 35.0,
                            width: 85.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 75, 196, 201),
                                  width: 2.0),
                              color: const Color.fromARGB(255, 196, 81, 65),
                              borderRadius: BorderRadius.circular(10.0),
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
                                  "CANCEL",
                                  style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 2.0),
            CashTransactionProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : allCashTransaction.isNotEmpty
                    ? Container(
                      padding: EdgeInsets.all(10),
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
                            border:
                            TableBorder.all(color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Transaction Id'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Account Name'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Description'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Received Amount '))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Paid Amount '))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Saved By '))),
                              ),
                            ],
                            rows: List.generate(
                              allCashTransaction.length > 100 ? 100 : allCashTransaction.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(
                                        child: Text(
                                            allCashTransaction[index].trId)),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            allCashTransaction[index].accName)),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            allCashTransaction[index].trDate)),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            allCashTransaction[index].trDescription)),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            allCashTransaction[index].inAmount)),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            allCashTransaction[index].outAmount)),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            allCashTransaction[index].addBy)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    : Text("No Record Found",textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade600),),
          ],
        ),
      ),
    );
  }

  //getCashTransaction_Id
  String? TransactionId;
  getCashTransactionId() async {
    String link = "${baseUrl}api/v1/getCashTransactionCode";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(
        link,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      print(response.data);
      setState(() {
        tnxIdNoController.text = jsonDecode(response.data);
      });
      print("getCashTransactionId Code===========> $TransactionId");
    } catch (e) {
      print(e);
    }
  }

  Future<String>fetchAddCashTransactions(
      BuildContext context,
      String? accSlid,
      int? inAmount,
      int? outAmount,
      String? trDescription,
      String? trId,
      int? trSlno,
      String? trType,
      String? trAccountType,
      String? trDate,
      ) async {
    String Link = "${baseUrl}api/v1/addCashTransaction";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(Link,
          data: {
            "Acc_SlID": "$accSlid",
            "In_Amount": inAmount,
            "Out_Amount": outAmount,
            "Tr_Description": "$trDescription",
            "Tr_Id": "$trId",
            "Tr_SlNo": trSlno,
            "Tr_Type": "$trType",
            "Tr_account_Type": "$trAccountType",
            "Tr_date": "$trDate"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var data = jsonDecode(response.data);
      if(data['success']==true){
        setState(() {
          isLoading = false;
        });
        print("CashTransactions CashTransactions:::${data}");
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.white, fontSize: 16),))));
        return "true";
      }
      else{
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.red, fontSize: 16),))));
        return "";
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Center(child: Text("${e}",style: const TextStyle(color: Colors.red, fontSize: 16),))));
      print("Something is wrong all Add CashTransactions list=======:$e");
      return "";
    }
  }
}
