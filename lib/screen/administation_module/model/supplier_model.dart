import 'dart:convert';

class SupplierModel {
  final String? supplierSlNo;
  final String? supplierCode;
  final String? supplierName;
  final String? supplierType;
  final String? supplierPhone;
  final String? supplierMobile;
  final String? supplierEmail;
  final String? supplierOfficePhone;
  final String? supplierAddress;
  final String? contactPerson;
  final String? districtSlNo;
  final String? countrySlNo;
  final String? supplierWeb;
  final String? previousDue;
  final dynamic imageName;
  final String? status;
  final String? addBy;
  final String? addTime;
  final String? updateBy;
  final String? updateTime;
  final String? supplierBrinchid;
  final String? displayName;

  SupplierModel({
    this.supplierSlNo,
    this.supplierCode,
    this.supplierName,
    this.supplierType,
    this.supplierPhone,
    this.supplierMobile,
    this.supplierEmail,
    this.supplierOfficePhone,
    this.supplierAddress,
    this.contactPerson,
    this.districtSlNo,
    this.countrySlNo,
    this.supplierWeb,
    this.previousDue,
    this.imageName,
    this.status,
    this.addBy,
    this.addTime,
    this.updateBy,
    this.updateTime,
    this.supplierBrinchid,
    this.displayName,
  });

  factory SupplierModel.fromJson(String str) => SupplierModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SupplierModel.fromMap(Map<String, dynamic> json) => SupplierModel(
    supplierSlNo: json["Supplier_SlNo"]??"",
    supplierCode: json["Supplier_Code"]??"",
    supplierName: json["Supplier_Name"]??"",
    supplierType: json["Supplier_Type"]??"",
    supplierPhone: json["Supplier_Phone"]??"",
    supplierMobile: json["Supplier_Mobile"]??"",
    supplierEmail: json["Supplier_Email"]??"",
    supplierOfficePhone: json["Supplier_OfficePhone"]??"",
    supplierAddress: json["Supplier_Address"]??"",
    contactPerson: json["contact_person"]??"",
    districtSlNo: json["District_SlNo"]??"",
    countrySlNo: json["Country_SlNo"]??"",
    supplierWeb: json["Supplier_Web"]??"",
    previousDue: json["previous_due"]??"",
    imageName: json["image_name"],
    status: json["Status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"]??"",
    updateTime: json["UpdateTime"]??"",
    supplierBrinchid: json["Supplier_brinchid"]??"",
    displayName: json["display_name"]??"",
  );

  Map<String, dynamic> toMap() => {
    "Supplier_SlNo": supplierSlNo,
    "Supplier_Code": supplierCode,
    "Supplier_Name": supplierName,
    "Supplier_Type": supplierType,
    "Supplier_Phone": supplierPhone,
    "Supplier_Mobile": supplierMobile,
    "Supplier_Email": supplierEmail,
    "Supplier_OfficePhone": supplierOfficePhone,
    "Supplier_Address": supplierAddress,
    "contact_person": contactPerson,
    "District_SlNo": districtSlNo,
    "Country_SlNo": countrySlNo,
    "Supplier_Web": supplierWeb,
    "previous_due": previousDue,
    "image_name": imageName,
    "Status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "Supplier_brinchid": supplierBrinchid,
    "display_name": displayName,
  };
}
