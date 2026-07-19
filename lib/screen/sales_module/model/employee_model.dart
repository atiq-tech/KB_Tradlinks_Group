import 'dart:convert';

class EmployeeModel {
  final String employeeSlNo;
  final String designationId;
  final String departmentId;
  final String employeeId;
  final String employeeName;
  final String employeeJoinDate;
  final String employeeGender;
  final String employeeBirthDate;
  final String employeeNid;
  final String employeeContactNo;
  final String employeeEmail;
  final String employeeMaritalStatus;
  final String employeeFatherName;
  final String employeeMotherName;
  final String employeePrasentAddress;
  final String employeePermanentAddress;
  final String employeePicOrg;
  final String employeePicThum;
  final String salaryRange;
  final String status;
  final String addBy;
  final String addTime;
  final String updateBy;
  final String updateTime;
  final String employeeBrinchid;
  final String dailySalary;
  final String departmentName;
  final String designationName;
  final String displayName;

  EmployeeModel({
    required this.employeeSlNo,
    required this.designationId,
    required this.departmentId,
    required this.employeeId,
    required this.employeeName,
    required this.employeeJoinDate,
    required this.employeeGender,
    required this.employeeBirthDate,
    required this.employeeNid,
    required this.employeeContactNo,
    required this.employeeEmail,
    required this.employeeMaritalStatus,
    required this.employeeFatherName,
    required this.employeeMotherName,
    required this.employeePrasentAddress,
    required this.employeePermanentAddress,
    required this.employeePicOrg,
    required this.employeePicThum,
    required this.salaryRange,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.employeeBrinchid,
    required this.dailySalary,
    required this.departmentName,
    required this.designationName,
    required this.displayName,
  });

  factory EmployeeModel.fromJson(String str) => EmployeeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromMap(Map<String, dynamic> json) => EmployeeModel(
    employeeSlNo: json["Employee_SlNo"]??"",
    designationId: json["Designation_ID"]??"",
    departmentId: json["Department_ID"]??"",
    employeeId: json["Employee_ID"]??"",
    employeeName: json["Employee_Name"]??"",
    employeeJoinDate: json["Employee_JoinDate"]??"",
    employeeGender: json["Employee_Gender"]??"",
    employeeBirthDate: json["Employee_BirthDate"]??"",
    employeeNid: json["Employee_NID"]??"",
    employeeContactNo: json["Employee_ContactNo"]??"",
    employeeEmail: json["Employee_Email"]??"",
    employeeMaritalStatus: json["Employee_MaritalStatus"]??"",
    employeeFatherName: json["Employee_FatherName"]??"",
    employeeMotherName: json["Employee_MotherName"]??"",
    employeePrasentAddress: json["Employee_PrasentAddress"]??"",
    employeePermanentAddress: json["Employee_PermanentAddress"]??"",
    employeePicOrg: json["Employee_Pic_org"]??"",
    employeePicThum: json["Employee_Pic_thum"]??"",
    salaryRange: json["salary_range"]??"",
    status: json["status"]??"",
    addBy: json["AddBy"]??"",
    addTime: json["AddTime"]??"",
    updateBy: json["UpdateBy"]??"",
    updateTime: json["UpdateTime"]??"",
    employeeBrinchid: json["Employee_brinchid"]??"",
    dailySalary: json["daily_salary"]??"",
    departmentName: json["Department_Name"]??"",
    designationName: json["Designation_Name"]??"",
    displayName: json["display_name"]??"",
  );

  Map<String, dynamic> toMap() => {
    "Employee_SlNo": employeeSlNo,
    "Designation_ID": designationId,
    "Department_ID": departmentId,
    "Employee_ID": employeeId,
    "Employee_Name": employeeName,
    "Employee_JoinDate":employeeJoinDate,
    "Employee_Gender": employeeGender,
    "Employee_BirthDate": employeeBirthDate,
    "Employee_NID": employeeNid,
    "Employee_ContactNo": employeeContactNo,
    "Employee_Email": employeeEmail,
    "Employee_MaritalStatus": employeeMaritalStatus,
    "Employee_FatherName": employeeFatherName,
    "Employee_MotherName": employeeMotherName,
    "Employee_PrasentAddress": employeePrasentAddress,
    "Employee_PermanentAddress": employeePermanentAddress,
    "Employee_Pic_org": employeePicOrg,
    "Employee_Pic_thum": employeePicThum,
    "salary_range": salaryRange,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "Employee_brinchid": employeeBrinchid,
    "daily_salary": dailySalary,
    "Department_Name": departmentName,
    "Designation_Name": designationName,
    "display_name": displayName,
  };
}
