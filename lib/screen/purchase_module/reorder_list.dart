import 'package:flutter/material.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/current_stock_provider.dart';
import 'package:provider/provider.dart';

class ReorderList extends StatefulWidget {
  const ReorderList({super.key});

  @override
  State<ReorderList> createState() => _ReorderListState();
}

class _ReorderListState extends State<ReorderList> {

  @override
  void initState() {
    CurrentStockProvider.isLoading = true;
    Provider.of<CurrentStockProvider>(context,listen: false).getCurrentStocklist = [];
    Provider.of<CurrentStockProvider>(context,listen: false).getCurrentStock(context, "low");

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final reOrderList = Provider.of<CurrentStockProvider>(context).getCurrentStocklist;

    return Scaffold(
      appBar: const CustomAppBar(title: "Re-Order List"),
      body: Column(
        children: [

          CurrentStockProvider.isLoading == true
              ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator(),),
              )
              : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.green.shade50,
                  child: DataTable(
                    headingRowHeight: 20.0,
                    dataRowHeight: 20.0,
                    showCheckboxColumn: true,
                    border: TableBorder.all(color: Colors.black54, width: 1),
                    columns: const [
                      DataColumn(
                        label: Expanded(child: Center(child: Text('Product Id.'))),
                      ),
                      DataColumn(
                        label: Expanded(child: Center(child: Text('Product Name'))),
                      ),
                      DataColumn(
                        label: Expanded(child: Center(child: Text('Category Name'))),
                      ),
                      DataColumn(
                        label: Expanded(child: Center(child: Text('Re-Order Level'))),
                      ),
                      DataColumn(
                        label: Expanded(child: Center(child: Text('Current Stock'))),
                      ),
                    ],
                    rows: List.generate(
                      reOrderList.length,
                          (int index) => DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Center(child: Text(reOrderList[index].productCode)),
                          ),
                          DataCell(
                            Center(child: Text(reOrderList[index].productName)),
                          ),
                          DataCell(
                            Center(child: Text(reOrderList[index].productCategoryName)),
                          ),
                          DataCell(
                            Center(child: Text("${reOrderList[index].productReOrederLevel} ${reOrderList[index].unitName}")),
                          ),
                          DataCell(
                            Center(child: Text("${reOrderList[index].currentQuantity} ${reOrderList[index].unitName}")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
