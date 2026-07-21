import 'dart:convert';

class BalanceReportModel {
  final String cashBalance;
  final List<BankAccount> bankAccounts;
  final dynamic customerDues;
  final dynamic wholesaleDues;
  final dynamic retailDues;
  final List<SupplierDue> supplierDues;
  final int totalSupplierDues;
  final dynamic badDebts;
  final String supplierPrevDue;
  final String customerPrevDue;
  final double stockValue;
  final Kbenterprise kbenterprise;
  final double netProfit;

  BalanceReportModel({
    required this.cashBalance,
    required this.bankAccounts,
    required this.customerDues,
    required this.wholesaleDues,
    required this.retailDues,
    required this.supplierDues,
    required this.totalSupplierDues,
    required this.badDebts,
    required this.supplierPrevDue,
    required this.customerPrevDue,
    required this.stockValue,
    required this.kbenterprise,
    required this.netProfit,
  });

  factory BalanceReportModel.fromJson(String str) =>
      BalanceReportModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BalanceReportModel.fromMap(Map<String, dynamic> json) =>
      BalanceReportModel(
        cashBalance: json["cash_balance"] ?? "",

        bankAccounts: json["bank_accounts"] == null ||
                json["bank_accounts"] is! List
            ? []
            : List<BankAccount>.from(
                json["bank_accounts"].map(
                  (x) => BankAccount.fromMap(x),
                ),
              ),

        customerDues: json["customer_dues"],
        wholesaleDues: json["wholesale_dues"],
        retailDues: json["retail_dues"],

        supplierDues: json["supplier_dues"] == null ||
                json["supplier_dues"] is! List
            ? []
            : List<SupplierDue>.from(
                json["supplier_dues"].map(
                  (x) => SupplierDue.fromMap(x),
                ),
              )
                .where((element) => element.due != "0.00")
                .toList(),

        totalSupplierDues:
            (json["total_supplier_dues"] as num?)?.toInt() ?? 0,

        badDebts: json["bad_debts"],

        supplierPrevDue: json["supplier_prev_due"] ?? "",
        customerPrevDue: json["customer_prev_due"] ?? "",

        stockValue: (json["stock_value"] as num?)?.toDouble() ?? 0.0,

        kbenterprise: json["kbenterprise"] == null
            ? Kbenterprise(
                agrofood: 0.0,
                challgodwon2: 0,
                challgodwon3: 0,
              )
            : Kbenterprise.fromMap(json["kbenterprise"]),

        netProfit: (json["net_profit"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        "cash_balance": cashBalance,
        "bank_accounts":
            List<dynamic>.from(bankAccounts.map((x) => x.toJson())),
        "customer_dues": customerDues,
        "wholesale_dues": wholesaleDues,
        "retail_dues": retailDues,
        "supplier_dues":
            List<dynamic>.from(supplierDues.map((x) => x.toJson())),
        "total_supplier_dues": totalSupplierDues,
        "bad_debts": badDebts,
        "supplier_prev_due": supplierPrevDue,
        "customer_prev_due": customerPrevDue,
        "stock_value": stockValue,
        "kbenterprise": kbenterprise.toJson(),
        "net_profit": netProfit,
      };
}


// =======================================================
// Bank Account
// =======================================================

class BankAccount {
  final String accountId;
  final String accountName;
  final String accountNumber;
  final String accountType;
  final String bankName;
  final String branchName;
  final String initialBalance;
  final String description;
  final String savedBy;
  final String savedDatetime;
  final dynamic updatedBy;
  final dynamic updatedDatetime;
  final String branchId;
  final String status;
  final String totalDeposit;
  final String totalWithdraw;
  final String totalReceivedFromCustomer;
  final String totalPaidToCustomer;
  final String totalPaidToSupplier;
  final String totalReceivedFromSupplier;
  final String balance;

  BankAccount({
    required this.accountId,
    required this.accountName,
    required this.accountNumber,
    required this.accountType,
    required this.bankName,
    required this.branchName,
    required this.initialBalance,
    required this.description,
    required this.savedBy,
    required this.savedDatetime,
    required this.updatedBy,
    required this.updatedDatetime,
    required this.branchId,
    required this.status,
    required this.totalDeposit,
    required this.totalWithdraw,
    required this.totalReceivedFromCustomer,
    required this.totalPaidToCustomer,
    required this.totalPaidToSupplier,
    required this.totalReceivedFromSupplier,
    required this.balance,
  });

  factory BankAccount.fromJson(String str) =>
      BankAccount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankAccount.fromMap(Map<String, dynamic> json) => BankAccount(
        accountId: json["account_id"]?.toString() ?? "",
        accountName: json["account_name"]?.toString() ?? "",
        accountNumber: json["account_number"]?.toString() ?? "",
        accountType: json["account_type"]?.toString() ?? "",
        bankName: json["bank_name"]?.toString() ?? "",
        branchName: json["branch_name"]?.toString() ?? "",
        initialBalance: json["initial_balance"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        savedBy: json["saved_by"]?.toString() ?? "",
        savedDatetime: json["saved_datetime"]?.toString() ?? "",

        updatedBy: json["updated_by"],
        updatedDatetime: json["updated_datetime"],

        branchId: json["branch_id"]?.toString() ?? "",
        status: json["status"]?.toString() ?? "",
        totalDeposit: json["total_deposit"]?.toString() ?? "",
        totalWithdraw: json["total_withdraw"]?.toString() ?? "",
        totalReceivedFromCustomer:
            json["total_received_from_customer"]?.toString() ?? "",
        totalPaidToCustomer:
            json["total_paid_to_customer"]?.toString() ?? "",
        totalPaidToSupplier:
            json["total_paid_to_supplier"]?.toString() ?? "",
        totalReceivedFromSupplier:
            json["total_received_from_supplier"]?.toString() ?? "",
        balance: json["balance"]?.toString() ?? "",
      );

  Map<String, dynamic> toMap() => {
        "account_id": accountId,
        "account_name": accountName,
        "account_number": accountNumber,
        "account_type": accountType,
        "bank_name": bankName,
        "branch_name": branchName,
        "initial_balance": initialBalance,
        "description": description,
        "saved_by": savedBy,
        "saved_datetime": savedDatetime,
        "updated_by": updatedBy,
        "updated_datetime": updatedDatetime,
        "branch_id": branchId,
        "status": status,
        "total_deposit": totalDeposit,
        "total_withdraw": totalWithdraw,
        "total_received_from_customer": totalReceivedFromCustomer,
        "total_paid_to_customer": totalPaidToCustomer,
        "total_paid_to_supplier": totalPaidToSupplier,
        "total_received_from_supplier": totalReceivedFromSupplier,
        "balance": balance,
      };
}


// =======================================================
// Kbenterprise
// =======================================================

class Kbenterprise {
  final double agrofood;
  final int challgodwon2;
  final int challgodwon3;

  Kbenterprise({
    required this.agrofood,
    required this.challgodwon2,
    required this.challgodwon3,
  });

  factory Kbenterprise.fromJson(String str) =>
      Kbenterprise.fromMap(json.decode(str));

  factory Kbenterprise.fromMap(Map<String, dynamic> json) => Kbenterprise(
        agrofood: (json["agrofood"] as num?)?.toDouble() ?? 0.0,

        challgodwon2:
            (json["challgodwon2"] as num?)?.toInt() ?? 0,

        challgodwon3:
            (json["challgodwon3"] as num?)?.toInt() ?? 0,
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "agrofood": agrofood,
        "challgodwon2": challgodwon2,
        "challgodwon3": challgodwon3,
      };
}


// =======================================================
// Supplier Due
// =======================================================

class SupplierDue {
  final String supplierSlNo;
  final String supplierCode;
  final String supplierName;
  final String supplierMobile;
  final String supplierAddress;
  final String contactPerson;
  final String bill;
  final String invoicePaid;
  final String cashPaid;
  final String cashReceived;
  final String returned;
  final String paid;
  final String due;

  SupplierDue({
    required this.supplierSlNo,
    required this.supplierCode,
    required this.supplierName,
    required this.supplierMobile,
    required this.supplierAddress,
    required this.contactPerson,
    required this.bill,
    required this.invoicePaid,
    required this.cashPaid,
    required this.cashReceived,
    required this.returned,
    required this.paid,
    required this.due,
  });

  factory SupplierDue.fromJson(String str) =>
      SupplierDue.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SupplierDue.fromMap(Map<String, dynamic> json) => SupplierDue(
        supplierSlNo: json["Supplier_SlNo"]?.toString() ?? "",
        supplierCode: json["Supplier_Code"]?.toString() ?? "",
        supplierName: json["Supplier_Name"]?.toString() ?? "",
        supplierMobile: json["Supplier_Mobile"]?.toString() ?? "",
        supplierAddress: json["Supplier_Address"]?.toString() ?? "",
        contactPerson: json["contact_person"]?.toString() ?? "",
        bill: json["bill"]?.toString() ?? "",
        invoicePaid: json["invoicePaid"]?.toString() ?? "",
        cashPaid: json["cashPaid"]?.toString() ?? "",
        cashReceived: json["cashReceived"]?.toString() ?? "",
        returned: json["returned"]?.toString() ?? "",
        paid: json["paid"]?.toString() ?? "",
        due: json["due"]?.toString() ?? "",
      );

  Map<String, dynamic> toMap() => {
        "Supplier_SlNo": supplierSlNo,
        "Supplier_Code": supplierCode,
        "Supplier_Name": supplierName,
        "Supplier_Mobile": supplierMobile,
        "Supplier_Address": supplierAddress,
        "contact_person": contactPerson,
        "bill": bill,
        "invoicePaid": invoicePaid,
        "cashPaid": cashPaid,
        "cashReceived": cashReceived,
        "returned": returned,
        "paid": paid,
        "due": due,
      };
}











// import 'dart:convert';

// class BalanceReportModel {
//   final String cashBalance;
//   final List<BankAccount> bankAccounts;
//   final dynamic customerDues;
//   final dynamic wholesaleDues;
//   final dynamic retailDues;
//   final List<SupplierDue> supplierDues;
//   final int totalSupplierDues;
//   final dynamic badDebts;
//   final String supplierPrevDue;
//   final String customerPrevDue;
//   final double stockValue;
//   final Kbenterprise kbenterprise;
//   final double netProfit;

//   BalanceReportModel({
//     required this.cashBalance,
//     required this.bankAccounts,
//     required this.customerDues,
//     required this.wholesaleDues,
//     required this.retailDues,
//     required this.supplierDues,
//     required this.totalSupplierDues,
//     required this.badDebts,
//     required this.supplierPrevDue,
//     required this.customerPrevDue,
//     required this.stockValue,
//     required this.kbenterprise,
//     required this.netProfit,
//   });

//   factory BalanceReportModel.fromJson(String str) => BalanceReportModel.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory BalanceReportModel.fromMap(Map<String, dynamic> json) => BalanceReportModel(
//     cashBalance: json["cash_balance"]??"",
//     bankAccounts:json["bank_accounts"] == null || json["bank_accounts"] == []
//         ? [] :List<BankAccount>.from(json["bank_accounts"].map((x) => BankAccount.fromMap(x))),
//     customerDues: json["customer_dues"],
//     wholesaleDues: json["wholesale_dues"],
//     retailDues: json["retail_dues"],
//     supplierDues: List<SupplierDue>.from(json["supplier_dues"].map((x) => SupplierDue.fromMap(x))).where((element) => element.due!="0.00").toList(),
//     totalSupplierDues: json["total_supplier_dues"],
//     badDebts: json["bad_debts"],
//     supplierPrevDue: json["supplier_prev_due"]??"",
//     customerPrevDue: json["customer_prev_due"]??"",
//     stockValue: json["stock_value"]?.toDouble(),
//     kbenterprise: Kbenterprise.fromMap(json["kbenterprise"]),
//     netProfit: json["net_profit"]?.toDouble(),
//   );

//   Map<String, dynamic> toMap() => {
//     "cash_balance": cashBalance,
//     "bank_accounts": List<dynamic>.from(bankAccounts.map((x) => x.toJson())),
//     "customer_dues": customerDues,
//     "wholesale_dues": wholesaleDues,
//     "retail_dues": retailDues,
//     "supplier_dues": List<dynamic>.from(supplierDues.map((x) => x.toJson())),
//     "total_supplier_dues": totalSupplierDues,
//     "bad_debts": badDebts,
//     "supplier_prev_due": supplierPrevDue,
//     "customer_prev_due": customerPrevDue,
//     "stock_value": stockValue,
//     "kbenterprise": kbenterprise.toJson(),
//     "net_profit": netProfit,
//   };
// }

// class BankAccount {
//   final String accountId;
//   final String accountName;
//   final String accountNumber;
//   final String accountType;
//   final String bankName;
//   final String branchName;
//   final String initialBalance;
//   final String description;
//   final String savedBy;
//   final String savedDatetime;
//   final dynamic updatedBy;
//   final dynamic updatedDatetime;
//   final String branchId;
//   final String status;
//   final String totalDeposit;
//   final String totalWithdraw;
//   final String totalReceivedFromCustomer;
//   final String totalPaidToCustomer;
//   final String totalPaidToSupplier;
//   final String totalReceivedFromSupplier;
//   final String balance;

//   BankAccount({
//     required this.accountId,
//     required this.accountName,
//     required this.accountNumber,
//     required this.accountType,
//     required this.bankName,
//     required this.branchName,
//     required this.initialBalance,
//     required this.description,
//     required this.savedBy,
//     required this.savedDatetime,
//     required this.updatedBy,
//     required this.updatedDatetime,
//     required this.branchId,
//     required this.status,
//     required this.totalDeposit,
//     required this.totalWithdraw,
//     required this.totalReceivedFromCustomer,
//     required this.totalPaidToCustomer,
//     required this.totalPaidToSupplier,
//     required this.totalReceivedFromSupplier,
//     required this.balance,
//   });

//   factory BankAccount.fromJson(String str) => BankAccount.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory BankAccount.fromMap(Map<String, dynamic> json) => BankAccount(
//     accountId: json["account_id"]??"",
//     accountName: json["account_name"]??"",
//     accountNumber: json["account_number"]??"",
//     accountType: json["account_type"]??"",
//     bankName: json["bank_name"]??"",
//     branchName: json["branch_name"]??"",
//     initialBalance: json["initial_balance"]??"",
//     description: json["description"]??"",
//     savedBy: json["saved_by"]??"",
//     savedDatetime: json["saved_datetime"]??"",
//     updatedBy: json["updated_by"],
//     updatedDatetime: json["updated_datetime"],
//     branchId: json["branch_id"]??"",
//     status: json["status"]??"",
//     totalDeposit: json["total_deposit"]??"",
//     totalWithdraw: json["total_withdraw"]??"",
//     totalReceivedFromCustomer: json["total_received_from_customer"]??"",
//     totalPaidToCustomer: json["total_paid_to_customer"]??"",
//     totalPaidToSupplier: json["total_paid_to_supplier"]??"",
//     totalReceivedFromSupplier: json["total_received_from_supplier"]??"",
//     balance: json["balance"]??"",
//   );

//   Map<String, dynamic> toMap() => {
//     "account_id": accountId,
//     "account_name": accountName,
//     "account_number": accountNumber,
//     "account_type": accountType,
//     "bank_name": bankName,
//     "branch_name": branchName,
//     "initial_balance": initialBalance,
//     "description": description,
//     "saved_by": savedBy,
//     "saved_datetime": savedDatetime,
//     "updated_by": updatedBy,
//     "updated_datetime": updatedDatetime,
//     "branch_id": branchId,
//     "status": status,
//     "total_deposit": totalDeposit,
//     "total_withdraw": totalWithdraw,
//     "total_received_from_customer": totalReceivedFromCustomer,
//     "total_paid_to_customer": totalPaidToCustomer,
//     "total_paid_to_supplier": totalPaidToSupplier,
//     "total_received_from_supplier": totalReceivedFromSupplier,
//     "balance": balance,
//   };
// }

// class Kbenterprise {
//   final double agrofood;
//   final int challgodwon2;
//   final int challgodwon3;

//   Kbenterprise({
//     required this.agrofood,
//     required this.challgodwon2,
//     required this.challgodwon3,
//   });

//   factory Kbenterprise.fromJson(String str) => Kbenterprise.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Kbenterprise.fromMap(Map<String, dynamic> json) => Kbenterprise(
//     agrofood: json["agrofood"]?.toDouble(),
//     challgodwon2: json["challgodwon2"]??0,
//     challgodwon3: json["challgodwon3"]??0,
//   );

//   Map<String, dynamic> toMap() => {
//     "agrofood": agrofood,
//     "challgodwon2": challgodwon2,
//     "challgodwon3": challgodwon3,
//   };
// }

// class SupplierDue {
//   final String supplierSlNo;
//   final String supplierCode;
//   final String supplierName;
//   final String supplierMobile;
//   final String supplierAddress;
//   final String contactPerson;
//   final String bill;
//   final String invoicePaid;
//   final String cashPaid;
//   final String cashReceived;
//   final String returned;
//   final String paid;
//   final String due;

//   SupplierDue({
//     required this.supplierSlNo,
//     required this.supplierCode,
//     required this.supplierName,
//     required this.supplierMobile,
//     required this.supplierAddress,
//     required this.contactPerson,
//     required this.bill,
//     required this.invoicePaid,
//     required this.cashPaid,
//     required this.cashReceived,
//     required this.returned,
//     required this.paid,
//     required this.due,
//   });

//   factory SupplierDue.fromJson(String str) => SupplierDue.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory SupplierDue.fromMap(Map<String, dynamic> json) => SupplierDue(
//     supplierSlNo: json["Supplier_SlNo"]??"",
//     supplierCode: json["Supplier_Code"]??"",
//     supplierName: json["Supplier_Name"]??"",
//     supplierMobile: json["Supplier_Mobile"]??"",
//     supplierAddress: json["Supplier_Address"]??"",
//     contactPerson: json["contact_person"]??"",
//     bill: json["bill"]??"",
//     invoicePaid: json["invoicePaid"]??"",
//     cashPaid: json["cashPaid"]??"",
//     cashReceived: json["cashReceived"]??"",
//     returned: json["returned"]??"",
//     paid: json["paid"]??"",
//     due: json["due"]??"",
//   );

//   Map<String, dynamic> toMap() => {
//     "Supplier_SlNo": supplierSlNo,
//     "Supplier_Code": supplierCode,
//     "Supplier_Name": supplierName,
//     "Supplier_Mobile": supplierMobile,
//     "Supplier_Address": supplierAddress,
//     "contact_person": contactPerson,
//     "bill": bill,
//     "invoicePaid": invoicePaid,
//     "cashPaid": cashPaid,
//     "cashReceived": cashReceived,
//     "returned": returned,
//     "paid": paid,
//     "due": due,
//   };
// }