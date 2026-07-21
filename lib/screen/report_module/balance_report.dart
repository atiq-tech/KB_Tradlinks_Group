import 'package:flutter/material.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/balance_report_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class BalanceReport extends StatefulWidget {
  const BalanceReport({super.key});

  @override
  State<BalanceReport> createState() => _BalanceReportState();
}

class _BalanceReportState extends State<BalanceReport> {
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
  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    // BalanceReportProvider.isLoading = true;
    Provider.of<BalanceReportProvider>(context,listen: false).balanceReportModel = null;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allBalanceReportData = Provider.of<BalanceReportProvider>(context).balanceReportModel;
    final allBankBalance = allBalanceReportData?.bankAccounts.fold(0.0, (p, e) => p+double.parse(e.balance));

    return Scaffold(
        appBar: const CustomAppBar(title: "Balance Report"),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0,bottom: 5.0),
                decoration: BoxDecoration(
                  color: Colors.lightGreen.shade100,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: const Color.fromARGB(255, 7, 125, 180), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Date : ",
                      style: TextStyle(
                          color: Colors.black87),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
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
                    const SizedBox(width: 5.0),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              BalanceReportProvider().on();
                            });
                            Provider.of<BalanceReportProvider>(context,listen: false).getBalanceReport("$backEndFirstDate");
                          },
                          child: Container(
                            height: 30.0,
                            width: 85.0,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 40, 104, 163),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
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
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            BalanceReportProvider.isLoading
                ? const Center(child: CircularProgressIndicator(),)
                : allBalanceReportData == null
                ? Center(child: Text("No Data Found",style: TextStyle(color: Colors.red.shade600,fontSize: 14)))
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.blueGrey.shade50,
                  child: const Center(
                    child: Text(
                      "Asset",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 15, 101, 199),
                      ),
                    )),
                ),
                Container(
                  // color: Colors.blueGrey.shade100,
                  child:  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Cash : ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 15, 101, 199),
                            ),
                          ),
                          Text(
                            "${allBalanceReportData.cashBalance}.0",
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(thickness: 1.0,),
                Container(
                  // color: Colors.blueGrey.shade100,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Bank : ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 15, 101, 199),
                            ),
                          ),
                          Text(
                            "$allBankBalance",
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0,),
                Container(
                  height: MediaQuery.of(context).size.height / 1.65,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                                        child: Center(child: Text('Bank Name'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Center(child: Text('Balance'))),
                                  ),
                                ],
                                rows: List.generate(
                                  allBalanceReportData.bankAccounts.length,
                                      (int index) =>  DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allBalanceReportData.bankAccounts[index].bankName} ${allBalanceReportData.bankAccounts[index].accountName} ${allBalanceReportData.bankAccounts[index].accountNumber}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allBalanceReportData.bankAccounts[index].balance}')),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(thickness: 1.0,),
                Container(
                  // color: Colors.blueGrey.shade100,
                  child:  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Customer Due:-",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 15, 101, 199),
                            ),
                          ),
                          Text(
                            "${double.parse("${allBalanceReportData.customerDues}")+double.parse("${allBalanceReportData.badDebts}")}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0,),
                Container(
                  height: MediaQuery.of(context).size.height / 9.43,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: const Center(child: Text("Wholesale Due",style: TextStyle(fontWeight: FontWeight.w500),)),
                          ),
                        ),Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: const Center(child: Text("Reatil Due",style: TextStyle(fontWeight: FontWeight.w500),)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: const Center(child: Text("Bad Debt",style: TextStyle(fontWeight: FontWeight.w500),)),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: Center(child: Text("${allBalanceReportData.wholesaleDues}")),
                          ),
                        ),Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: Center(child: Text("${allBalanceReportData.retailDues}")),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: Center(child: Text("${allBalanceReportData.badDebts}")),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const Divider(thickness: 1.0,),
                Container(
                  // color: Colors.blueGrey.shade100,
                  child:  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Stock Value:-",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 15, 101, 199),
                            ),
                          ),
                          Text(
                            "${double.parse("${allBalanceReportData.kbenterprise.agrofood}")+double.parse("${allBalanceReportData.kbenterprise.challgodwon2}")+double.parse("${allBalanceReportData.kbenterprise.challgodwon3}")}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Container(
                  height: MediaQuery.of(context).size.height / 9.43,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: const Center(child: Text("KB AGRO FOOD",style: TextStyle(fontWeight: FontWeight.w500),)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: const Center(child: Text("চাউল গোডাউন নং ২",style: TextStyle(fontWeight: FontWeight.w500),)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: const Center(child: Text("চাউল গোডাউন নং ৩",style: TextStyle(fontWeight: FontWeight.w500),)),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: Center(child: Text("${allBalanceReportData.kbenterprise.agrofood}")),
                          ),
                        ),Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: Center(child: Text("${allBalanceReportData.kbenterprise.challgodwon2}")),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 20.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.5)
                            ),
                            child: Center(child: Text("${allBalanceReportData.kbenterprise.challgodwon3}")),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Total Assets  :   ",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      Text(
                        "${double.parse("${allBalanceReportData.cashBalance}")+double.parse("${allBankBalance}")+double.parse("${allBalanceReportData.customerDues}")+double.parse("${allBalanceReportData.badDebts}")+double.parse("${allBalanceReportData.kbenterprise.agrofood}")+double.parse("${allBalanceReportData.kbenterprise.challgodwon2}")+double.parse("${allBalanceReportData.kbenterprise.challgodwon3}")}",
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(thickness: 1.0,),
                Container(
                  color: Colors.blueGrey.shade50,
                  child: const Center(
                      child: Text(
                        "Liability",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 15, 101, 199),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Supplier Due:-",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 15, 101, 199),
                        ),
                      ),
                      Text(
                        "${double.parse("${allBalanceReportData.totalSupplierDues}")}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.55,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                                        child: Center(child: Text('Supplier Name'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Center(child: Text('Due Amount'))),
                                  ),
                                ],
                                rows: List.generate(
                                  allBalanceReportData.supplierDues.length,
                                      (int index) =>  DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allBalanceReportData.supplierDues[index].supplierCode} ${allBalanceReportData.supplierDues[index].supplierName}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allBalanceReportData.supplierDues[index].due}')),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  const Text(
                                    "Total Liability  :   ",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),

                                  Text(
                                    "${allBalanceReportData.totalSupplierDues}.0",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )

          ]),
        ));
  }
}
