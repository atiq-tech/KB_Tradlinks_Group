import 'package:flutter/material.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/cash_view_provider.dart';
import 'package:provider/provider.dart';

class CashViewPage extends StatefulWidget {
  const CashViewPage({super.key});

  @override
  State<CashViewPage> createState() => _CashViewPageState();
}

class _CashViewPageState extends State<CashViewPage> {

  double bankBalance = 0.0;
  double totalCashBalance = 0.0;
  double totalBalance = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Cash View"),
      body: FutureBuilder(
        future: Provider.of<CashViewProvider>(context).getCashView(context),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            bankBalance = double.parse("${snapshot.data?.bankAccountSummary.map((e) => e.balance).fold(0.0, (p, e) => p + double.parse(e))}");
            totalCashBalance = double.parse("${snapshot.data?.transactionSummary.cashBalance}");
            totalBalance = (bankBalance + totalCashBalance);
            return Container(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100.0,
                        width: MediaQuery.of(context).size.width / 4 + 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(248, 240, 248, 230),
                          border: Border.all(
                              color: const Color.fromARGB(255, 218, 214, 214)),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           Image.asset("images/business/cln.png",width: 50.0,height: 40.0,),
                            const Text(
                              "Cash Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              " tk.${snapshot.data?.transactionSummary.cashBalance}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 100.0,
                        width: MediaQuery.of(context).size.width / 4 + 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(248, 240, 248, 230),
                          border: Border.all(
                              color: const Color.fromARGB(255, 218, 214, 214)),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5.0,),
                            Image.asset("images/business/bank.png",width: 50.0,height: 30.0,),
                            const SizedBox(height: 5.0,),
                            const Text(
                              "Bank Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                             Text(
                                    "tk.${bankBalance}",
                                    style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 100.0,
                        width: MediaQuery.of(context).size.width / 4 + 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(248, 240, 248, 230),
                          border: Border.all(
                              color: const Color.fromARGB(255, 218, 214, 214)),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5.0,),
                            const Icon(
                              Icons.monetization_on,
                              size: 35.0,
                            ),
                            const SizedBox(height: 5.0,),
                            const Text(
                              "Total Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "tk.${totalBalance}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Expanded(
                    // height: MediaQuery.of(context).size.height,
                    // width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.bankAccountSummary.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                            childAspectRatio: 2),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: const Color.fromARGB(255, 218, 214, 214)),
                                color: const Color.fromARGB(255, 182, 220, 252),
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
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(255, 2, 74, 133),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5.0),
                                              bottomLeft: Radius.circular(5.0),
                                            )),
                                        child: const Center(
                                            child: Icon(
                                              Icons.monetization_on_outlined,
                                              color: Colors.white,
                                            )),
                                      )),
                                  Expanded(
                                      flex: 12,
                                      child: Container(
                                        color:
                                         const Color.fromARGB(255, 200, 230, 255),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                "${snapshot.data?.bankAccountSummary[index].accountName}",
                                                style:  const TextStyle(fontSize: 13),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              child: Text(
                                                "${snapshot.data?.bankAccountSummary[index].accountNumber}",
                                                style:  const TextStyle(fontSize: 13),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              child: Text(
                                                "${snapshot.data?.bankAccountSummary[index].bankName}",
                                                style:  const TextStyle(fontSize: 13),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0,),
                                            SizedBox(
                                              child: Text(
                                                "tk.${snapshot.data?.bankAccountSummary[index].balance}",
                                                style:  const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else{
            return const SizedBox();
          }
      }),
    );
  }
}
