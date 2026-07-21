//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kbtradlink/custom/custom_drawer.dart';
import 'package:kbtradlink/provider/home_topdata_provider.dart';
import 'package:kbtradlink/screen/acount_module/cash_statement.dart';
import 'package:kbtradlink/screen/acount_module/bank_transaction.dart';
import 'package:kbtradlink/screen/acount_module/bank_transaction_report.dart';
import 'package:kbtradlink/screen/acount_module/cash_transaction_report.dart';
import 'package:kbtradlink/screen/acount_module/cash_transection.dart';
import 'package:kbtradlink/screen/acount_module/cash_view.dart';
import 'package:kbtradlink/screen/acount_module/customer_payment.dart';
import 'package:kbtradlink/screen/acount_module/supplier_payment.dart';
import 'package:kbtradlink/screen/administation_module/product_entry.dart';
import 'package:kbtradlink/screen/administation_module/product_ledger.dart';
import 'package:kbtradlink/screen/administation_module/supplier_entry.dart';
import 'package:kbtradlink/auth/login_screen.dart';
import 'package:kbtradlink/screen/purchase_module/purchase_record.dart';
import 'package:kbtradlink/screen/purchase_module/reorder_list.dart';
import 'package:kbtradlink/screen/report_module/balance_report.dart';
import 'package:kbtradlink/screen/report_module/bank_ledger.dart';
import 'package:kbtradlink/screen/report_module/busniess_monitor.dart';
import 'package:kbtradlink/screen/report_module/profit_&loss_report.dart';
import 'package:kbtradlink/screen/purchase_module/supplier_due_report.dart';
import 'package:kbtradlink/screen/purchase_module/supplier_payment_report.dart';
import 'package:kbtradlink/screen/administation_module/customer_entry.dart';
import 'package:kbtradlink/screen/purchase_module/purchase_entry.dart';
import 'package:kbtradlink/screen/sales_module/customer_due_list.dart';
import 'package:kbtradlink/screen/sales_module/customer_list.dart';
import 'package:kbtradlink/screen/sales_module/customer_payment_history.dart';
import 'package:kbtradlink/screen/sales_module/customer_payment_report.dart';
import 'package:kbtradlink/screen/sales_module/sales_entry.dart';
import 'package:kbtradlink/screen/sales_module/sales_record.dart';
import 'package:kbtradlink/screen/sales_module/stock_report.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isTodaySales = false;
  bool isMonthlySales = false;
  bool isTotalDue = false;
  bool isCashBalance = false;

  bool todaySalesEnabled = true;
  bool monthlySalesEnabled = true;
  bool totalDueEnabled = true;
  bool cashBalanceEnabled = true;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('profile');
    var boxTodaySales = Hive.box('todaySales');
    var boxMonthlySales = Hive.box('monthlySales');
    var boxTotalDue = Hive.box('totalDue');
    var boxCashBalance = Hive.box('cashBalance');

    return Scaffold(
      drawer: MyDrawerSection(
        name: "${box.get('name')}",
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0), // Size ektu barano holo vertical space-er jonno
        child: AppBar(
          leadingWidth: 25.0,
          elevation: 2.0,
          backgroundColor: Colors.deepPurple,
          // Drawer icon (Hamburger menu) white korar jonno eita dorkar
          iconTheme: const IconThemeData(color: Colors.white), 
          title: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "${box.get('branchName')}",
              style: const TextStyle(
                  fontSize: 16.0, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 16.0,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRw8tnmRAobUlTWwXTzG0yJevfymCAQw00wZw&usqp=CAU'),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        "Welcome, ${box.get('name')}",
                        style: const TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 0) {
                        // Profile code
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  height: 150.0,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10.0, right: 5.0),
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                SharedPreferences sharedPreferences =
                                                await SharedPreferences.getInstance();
                                                sharedPreferences.clear();
                                                GetStorage().erase();
                                                var box = await Hive.openBox('profile');
                                                box.clear();
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        const LogInPage()),
                                                        (route) => false);
                                              },
                                              child: Container(
                                                height: 35.0,
                                                width: 60.0,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 209, 55, 55),
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
                                                    color: const Color.fromARGB(
                                                        255, 7, 125, 180),
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
                            });
                      }
                    },
                    itemBuilder: (BuildContext bc) {
                      return const [
                        PopupMenuItem(
                          height: 25,
                          value: 0,
                          child: Text(
                            "Profile",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        PopupMenuItem(
                          height: 25,
                          value: 1,
                          child: Text(
                            "Logout",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ];
                    },
                    // Dropdown Arrow icon-ke white color dewa holo
                    child: Container(
                      height: 36,
                      width: 30,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white, 
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///TOP 4 SECTION
            Container(
              color: const Color.fromARGB(255, 7, 125, 180),
              height: 100.0,
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 10, right: 10),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: /*todaySalesEnabled ?*/ () {
                          setState(() {
                            isTodaySales = true;
                            // todaySalesEnabled = false;
                          });
                          Future.delayed(const Duration(seconds: 2),() {
                            setState(() {
                              isTodaySales = false;
                            });
                          },);
                          print('tapped today sales');
                        } /*: null*/,
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(5)),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (!isTodaySales &&
                                  boxTodaySales.get('todayS') == null) {
                                return const Center(
                                  child: Text(
                                    'Get Today \nSales',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              } else if (!isTodaySales &&
                                  boxTodaySales.get('todayS') != null) {
                                return isTodaySales ? const CircularProgressIndicator(
                                  color: Colors.yellow,
                                )  :  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FittedBox(
                                      child: Text(
                                        "Today Sales",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                      child: Text(
                                        "${boxTodaySales.get('todayS')=="" ||
                                            "${boxTodaySales.get('todayS')}"=="null"
                                            ? 0
                                            : double.parse(boxTodaySales.get('todayS')).toStringAsFixed(0)}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Visibility(
                                  visible: isTodaySales,
                                  child: FutureBuilder(
                                    future: Provider.of<HomeTopDataProvider>(
                                        context,listen: false)
                                        .getHomeTopDataProvider(context),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        boxTodaySales.put(
                                            'todayS', snapshot.data?.todaySale);
                                        return Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const FittedBox(
                                              child: Text(
                                                "Today Sales",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            SizedBox(
                                              child: Text(
                                                snapshot.data?.todaySale != ''
                                                    ? double.parse(
                                                    "${snapshot.data?.todaySale}")
                                                    .toStringAsFixed(0)
                                                    : '0',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.yellow,
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: /*monthlySalesEnabled ?*/ () {
                          setState(() {
                            isMonthlySales = true;
                            // monthlySalesEnabled = false;
                          });
                          Future.delayed(const Duration(seconds: 2),() {
                            setState(() {
                              isMonthlySales = false;
                            });
                          },);
                          print('tapped monthly sales');
                        } /*: null*/,
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (!isMonthlySales &&
                                  boxMonthlySales.get('monthlyS') == null) {
                                return const Center(
                                  child: Text(
                                    'Get Monthly Sales',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              } else if (!isMonthlySales &&
                                  boxMonthlySales.get('monthlyS') != null) {
                                return isMonthlySales ? const CircularProgressIndicator(
                                  color: Colors.yellow,
                                ) :  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FittedBox(
                                      child: Text(
                                        "Monthly Sales",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                      child: Text(
                                        boxMonthlySales.get('monthlyS')==""
                                            ||"${boxMonthlySales.get('monthlyS')}"=="null"
                                            ? "0"
                                            :double.parse(boxMonthlySales.get('monthlyS')).toStringAsFixed(0),

                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Visibility(
                                  visible: isMonthlySales,
                                  child: FutureBuilder(
                                    future: Provider.of<HomeTopDataProvider>(
                                        context, listen: false)
                                        .getHomeTopDataProvider(context),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        boxMonthlySales.put('monthlyS',
                                            snapshot.data?.monthlySale);
                                        return Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const FittedBox(
                                              child: Text(
                                                "Monthly Sales",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            SizedBox(
                                              child: Text(
                                                snapshot.data?.monthlySale != ''
                                                    ? double.parse(
                                                    "${snapshot.data?.monthlySale}")
                                                    .toStringAsFixed(0)
                                                    : '0',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.yellow,
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: /*cashBalanceEnabled ? */() {
                          setState(() {
                            isTotalDue = true;
                            // cashBalanceEnabled = false;
                          });
                          Future.delayed(const Duration(seconds: 2),() {
                            setState(() {
                              isTotalDue = false;
                            });
                          },);
                        } /*: null*/,
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (!isTotalDue &&
                                  boxTotalDue.get('totalD') == null) {
                                return const Center(
                                  child: Text(
                                    'Get Total \nDue',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              } else if (!isTotalDue &&
                                  boxTotalDue.get('totalD') != null) {
                                return isTotalDue ? const CircularProgressIndicator(
                                  color: Colors.yellow,
                                ) : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FittedBox(
                                      child: Text(
                                        "Total Due",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                      child: Text(
                                        double.parse(
                                            "${boxTotalDue.get('totalD')}")
                                            .toStringAsFixed(0),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Visibility(
                                  visible: isTotalDue,
                                  child: FutureBuilder(
                                    future: Provider.of<HomeTopDataProvider>(
                                        context,listen: false)
                                        .getHomeTopDataProvider(context),
                                    builder: (context, snapshot) {
                                      boxTotalDue.put(
                                          'totalD', snapshot.data?.totalDue);
                                      if (snapshot.hasData) {
                                        return Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const FittedBox(
                                              child: Text(
                                                "Total Due",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            SizedBox(
                                              child: Text(
                                                snapshot.data?.totalDue != ''
                                                    ? double.parse(
                                                    "${snapshot.data?.totalDue}")
                                                    .toStringAsFixed(0)
                                                    : '0',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.yellow,
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: /*cashBalanceEnabled ? */() {
                          setState(() {
                            isCashBalance = true;
                            // cashBalanceEnabled = false;
                          });
                          Future.delayed(const Duration(seconds: 2),() {
                            setState(() {
                              isCashBalance = false;
                            });
                          },);
                        } /*: null*/,
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (!isCashBalance &&
                                  boxCashBalance.get('cashB') == null) {
                                return const Center(
                                  child: Text(
                                    'Get Cash \nBalance',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              } else if (!isCashBalance &&
                                  boxCashBalance.get('cashB') != null) {
                                return isCashBalance ? const CircularProgressIndicator(
                                  color: Colors.yellow,
                                ) : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FittedBox(
                                      child: Text(
                                        "Cash Balance",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    SizedBox(
                                      child: Text(
                                        double.parse(
                                            "${boxCashBalance.get('cashB')}")
                                            .toStringAsFixed(0),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Visibility(
                                  visible: isCashBalance,
                                  child: FutureBuilder(
                                    future: Provider.of<HomeTopDataProvider>(
                                        context,listen: false)
                                        .getHomeTopDataProvider(context),
                                    builder: (context, snapshot) {
                                      boxCashBalance.put(
                                          'cashB', snapshot.data?.cashBalance);
                                      if (snapshot.hasData) {
                                        return Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const FittedBox(
                                              child: Text(
                                                "Cash Balance",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            SizedBox(
                                              child: Text(
                                                snapshot.data?.cashBalance != ''
                                                    ? double.parse(
                                                    "${snapshot.data?.cashBalance}")
                                                    .toStringAsFixed(0)
                                                    : '0',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.yellow,
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///Sales Module
            Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text("Sales Module:", style: getTextstyle()),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: salesList.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          mainAxisExtent: 100,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => salesModule[index],
                                  ));
                            },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              color: const Color(0xffD2D2FF),
                              // color: Colors.yellow.shade100,
                              elevation: 9.00,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "${salesList[index]['image']}"),
                                    height: 30,
                                    width: 35,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    "${salesList[index]['name']}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            ///Purchase Module
            Container(
              margin: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(

                    child:  Text(
                      " Purchase Module : ",
                      style: getTextstyle(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: purchaseNewList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          mainAxisExtent: 100,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => purchasepage[index],
                                  ));
                            },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              color: Colors.green[200],
                              elevation: 9.00,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "${purchaseNewList[index]['image']}"),
                                    height: 30,
                                    width: 35,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    "${purchaseNewList[index]['name']}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      // color: Color.fromARGB(255, 7, 125, 180),
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            ///Account Module
            Container(
              margin: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Module:",
                    style: getTextstyle(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 230,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: accountModuleItems.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          mainAxisExtent: 100,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => accountModule[index],
                                  ));
                            },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              color: Colors.blue[200],
                              elevation: 9.00,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "${accountModuleItems[index]['image']}"),
                                    height: 30,
                                    width: 35,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    "${accountModuleItems[index]['name']}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      // color: Color.fromARGB(255, 7, 125, 180),
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            ///Administator Module
            Container(
              margin: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(

                    child:  Text(
                      " Administator Module : ",
                      style: getTextstyle(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Administator.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          mainAxisExtent: 100,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    administratorPages[index],
                                  ));
                            },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              color: Colors.teal.shade200,
                              elevation: 9.00,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "${Administator[index]['image']}"),
                                    height: 30,
                                    width: 35,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    "${Administator[index]['name']}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      // color: Color.fromARGB(255, 7, 125, 180),
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            ///Report Module
            Container(
              margin: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Report Module:",
                    style: getTextstyle(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reportModule.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          mainAxisExtent: 100,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    reportModule[index],
                                  ));
                            },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              color: Colors.lightGreenAccent[100],
                              elevation: 9.00,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "${reportList[index]['image']}"),
                                      height: 30,
                                      width: 35,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      "${reportList[index]['name']}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        // color: Color.fromARGB(255, 7, 125, 180),
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 55,
            ),
            Container(
                height: 26.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  // border: Border.all(
                  //     color:  Colors.white,
                  //     width: 1.0),
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Row(
                      children: [
                        const Text(
                          "Developed by",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        RichText(
                            text: TextSpan(
                                text: "Link-Up Technology Ltd.",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch("https://linktechbd.com/#");
                                  })),
                      ],
                    ),
                  ),
                  // const Text(
                  //   "Developed By Link-Up Technology",
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 14.0,
                  //       color: Colors.white),
                  // ),
                )),
          ],
        ),
      ),
    );
  }

  // TextStyle textStyle() {
  //   return const TextStyle(
  //       color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900);
  // }



  List reportModule = [
    const ProfitLossReportPage(),
    const BankLedger(),
    const BalanceReport(),
    const BusinessMonitor(),
  ];

  List salesModule = [
    const SalesEntryPage(),
    const SalesRecord(),
    const StockReport(),
    const CustomerDueList(),
    const CustomerPaymentReport(),
    const CustomerPaymentHistory(),
    const CustomerList()
    //const SupplierDueList(),
    //const SupplierPaymentReport(),
    // const PurchaseEntryPage(),
    // const CustomerEntryPage(),
    // const SettingPage(),
  ];
  List purchasepage = [
    const PurchaseEntryPage(),
    const PurchaseRecord(),
    const SupplierDueList(),
    const SupplierPaymentReport(),
    const ReorderList()
  ];
  List accountModule = [
    const CashTransactionPage(),
    const BankTransactionPage(),
    const CustomerPaymentPage(),
    const SupplierPaymentPage(),
    const CashViewPage(),
    const CashTransactionReportPage(),
    const BankTransactionReportPage(),
    //const BusinessMonitor(),
    const CashStatementPage()
  ];
  final List administratorPages = [
    const ProductEntry(),
    const ProductLedger(),
    const CustomerEntryPage(),
    const SupplierEntry(),
  ];
  List headTitle = [
    {"name": "Today Sale", "countPrice": "40k"},
    {"name": "Monthly", "countPrice": "500k"},
    {"name": "Total Due", "countPrice": "80k"},
    {"name": "Cash", "countPrice": "150k"},
  ];
}
