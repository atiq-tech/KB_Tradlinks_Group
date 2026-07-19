import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kbtradlink/screen/acount_module/bank_transaction.dart';
import 'package:kbtradlink/screen/acount_module/bank_transaction_report.dart';
import 'package:kbtradlink/screen/acount_module/cash_statement.dart';
import 'package:kbtradlink/screen/acount_module/cash_transaction_report.dart';
import 'package:kbtradlink/screen/acount_module/cash_transection.dart';
import 'package:kbtradlink/screen/acount_module/cash_view.dart';
import 'package:kbtradlink/screen/acount_module/customer_payment.dart';
import 'package:kbtradlink/screen/acount_module/supplier_payment.dart';
import 'package:kbtradlink/screen/administation_module/customer_entry.dart';
import 'package:kbtradlink/screen/administation_module/product_entry.dart';
import 'package:kbtradlink/screen/administation_module/product_ledger.dart';
import 'package:kbtradlink/screen/administation_module/supplier_entry.dart';
import 'package:kbtradlink/screen/auth/login_screen.dart';
import 'package:kbtradlink/screen/home_screen.dart';
import 'package:kbtradlink/screen/purchase_module/purchase_entry.dart';
import 'package:kbtradlink/screen/purchase_module/purchase_record.dart';
import 'package:kbtradlink/screen/purchase_module/reorder_list.dart';
import 'package:kbtradlink/screen/purchase_module/supplier_due_report.dart';
import 'package:kbtradlink/screen/purchase_module/supplier_payment_report.dart';
import 'package:kbtradlink/screen/report_module/balance_report.dart';
import 'package:kbtradlink/screen/report_module/bank_ledger.dart';
import 'package:kbtradlink/screen/report_module/busniess_monitor.dart';
import 'package:kbtradlink/screen/report_module/profit_&loss_report.dart';
import 'package:kbtradlink/screen/sales_module/customer_due_list.dart';
import 'package:kbtradlink/screen/sales_module/customer_list.dart';
import 'package:kbtradlink/screen/sales_module/customer_payment_history.dart';
import 'package:kbtradlink/screen/sales_module/customer_payment_report.dart';
import 'package:kbtradlink/screen/sales_module/sales_entry.dart';
import 'package:kbtradlink/screen/sales_module/sales_record.dart';
import 'package:kbtradlink/screen/sales_module/stock_report.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawerSection extends StatefulWidget {
  const MyDrawerSection({super.key, required this.name});
  final String? name;
  @override
  State<MyDrawerSection> createState() => _MyDrawerSectionState();
}

class _MyDrawerSectionState extends State<MyDrawerSection> {

  bool isSalesClick = false;
  bool isPurchaseClick = false;
  bool isAccountClick = false;
  bool isAdminClick = false;
  bool isReportClick = false;

  SharedPreferences? sharedPreferences;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 270.0,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 7, 125, 180),
                // image: DecorationImage(
                //     image: AssetImage("assets/dwr.jpg"), fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage("images/1bidhan.jpg")
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "${widget.name}",
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 209, 233, 240)),
                  ),
                  const SizedBox(height: 10.0),
                  // const Center(
                  //   child: Text(
                  //     "Business Management Apps",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 18.0,
                  //         color: Colors.white),
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                  // const SizedBox(height: 10.0),
                  const Center(
                    child: Text(
                      "KB TRADELINKS GROUP",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Center(
                    child: Text(
                      "Chairman: Bidhan Kumar Saha",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 2,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSalesClick = !isSalesClick;
                      isPurchaseClick = false;
                      isAccountClick = false;
                      isAdminClick = false;
                      isReportClick = false;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Salse Module",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                Visibility(
                  visible: isSalesClick,
                  child: Column(
                      children: List.generate(drawerList.length, (index) {

                        return GestureDetector(
                          onTap: () {
                            if(index == 0){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesEntryPage(),));
                            }
                            if(index == 1){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesRecord(),));
                            }
                            if(index == 2){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const StockReport(),));
                            }
                            if(index == 3){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerDueList(),));
                            }
                            if(index == 4){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerPaymentReport(),));
                            }
                            if(index == 5){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerPaymentHistory(),));
                            }
                            if(index == 6){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerList(),));
                            }
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(thickness: 1,color: Colors.black26,),
                                    Text(drawerList[index]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },)
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPurchaseClick = !isPurchaseClick;
                      isSalesClick = false;
                      isAccountClick = false;
                      isAdminClick = false;
                      isReportClick = false;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Purchase Module",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                Visibility(
                  visible: isPurchaseClick,
                  child: Column(
                    children: List.generate(drawerList1.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          if(index == 0){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchaseEntryPage(),));
                          }
                          if(index == 1){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchaseRecord(),));
                          }
                          if(index == 2){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierDueList(),));
                          }
                          if(index == 3){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierPaymentReport(),));
                          }
                          if(index == 4){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReorderList(),));
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(thickness: 1,color: Colors.black26,),
                                  Text(drawerList1[index]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAccountClick = !isAccountClick;
                      isSalesClick = false;
                      isPurchaseClick = false;
                      isAdminClick = false;
                      isReportClick = false;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Account Module",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                Visibility(
                  visible: isAccountClick,
                  child: Column(
                    children: List.generate(drawerList3.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          if(index == 0){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CashTransactionPage(),));
                          }
                          if(index == 1){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BankTransactionPage(),));
                          }
                          if(index == 2){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerPaymentPage(),));
                          }
                          if(index == 3){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierPaymentPage(),));
                          }
                          if(index == 4){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CashViewPage(),));
                          }
                          if(index == 5){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CashTransactionReportPage()));
                          }
                          if(index == 6){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BankTransactionReportPage()));
                          }
                          if(index == 7){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CashStatementPage()));
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(thickness: 1,color: Colors.black26,),
                                  Text(drawerList3[index]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAdminClick = !isAdminClick;
                      isSalesClick = false;
                      isPurchaseClick = false;
                      isAccountClick = false;
                      isReportClick = false;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Administration Module",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                Visibility(
                  visible: isAdminClick,
                  child: Column(
                    children: List.generate(drawerList4.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          if(index == 0){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductEntry(),));
                          }
                          if(index == 1){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductLedger(),));
                          }
                          if(index == 2){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerEntryPage(),));
                          }
                          if(index == 3){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierEntry(),));
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(thickness: 1,color: Colors.black26,),
                                  Text(drawerList4[index]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isReportClick = !isReportClick;
                      isSalesClick = false;
                      isPurchaseClick = false;
                      isAccountClick = false;
                      isAdminClick = false;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Report Module",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                Visibility(
                  visible: isReportClick,
                  child: Column(
                    children: List.generate(drawerList5.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          if(index == 0){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfitLossReportPage(),));
                          }
                          if(index == 1){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BankLedger(),));
                          }
                          if(index == 2){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BalanceReport(),));
                          }
                          if(index == 3){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BusinessMonitor(),));
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(thickness: 1,color: Colors.black26,),
                                  Text(drawerList5[index]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2,),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HomePage()));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                "Profile",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ),
          ),
          const Divider(thickness: 2,),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        height: 150.0,
                        width: double.infinity,
                        padding:
                        const EdgeInsets.only(top: 10.0, left: 10.0, right: 5.0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding:
                              EdgeInsets.only(left: 8.0, top: 10.0),
                              child: Text(
                                "Logout...!",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0),
                              ),
                            ),
                            const Padding(
                              padding:
                              EdgeInsets.only(left: 8.0, top: 10.0),
                              child: Text(
                                "Are You Sure Went To Log Out?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0),
                              ),
                            ),
                            const SizedBox(height: 35.0),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      sharedPreferences!.clear();
                                      GetStorage().erase();
                                      var box = await Hive.openBox('profile');
                                      box.clear();
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                          builder: (context) =>
                                          const LogInPage()), (route) => false);
                                    },
                                    child: Container(
                                      height: 35.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                          color:
                                          const Color.fromARGB(255, 209, 55, 55),
                                          borderRadius:
                                          BorderRadius.circular(5.0)),
                                      child: const Center(
                                          child: Text(
                                            "YES",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 35.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                          color:
                                          const Color.fromARGB(255, 7, 125, 180),
                                          borderRadius:
                                          BorderRadius.circular(5.0)),
                                      child: const Center(
                                          child: Text(
                                            "NO",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Divider(thickness: 2,),
        ],
      ),
    );
  }
}
