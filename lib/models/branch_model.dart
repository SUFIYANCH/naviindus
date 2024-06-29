// To parse this JSON data, do
//
//     final branchModel = branchModelFromJson(jsonString);

import 'dart:convert';

BranchModel branchModelFromJson(String str) =>
    BranchModel.fromJson(json.decode(str));

String branchModelToJson(BranchModel data) => json.encode(data.toJson());

class BranchModel {
  bool? status;
  String? message;
  List<Branch>? branches;

  BranchModel({
    this.status,
    this.message,
    this.branches,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        status: json["status"],
        message: json["message"],
        branches: json["branches"] == null
            ? []
            : List<Branch>.from(
                json["branches"]!.map((x) => Branch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "branches": branches == null
            ? []
            : List<dynamic>.from(branches!.map((x) => x.toJson())),
      };
}

class Branch {
  int? id;
  String? name;
  int? patientsCount;
  String? location;
  String? phone;
  String? mail;
  String? address;
  String? gst;
  bool? isActive;

  Branch({
    this.id,
    this.name,
    this.patientsCount,
    this.location,
    this.phone,
    this.mail,
    this.address,
    this.gst,
    this.isActive,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: json["name"],
        patientsCount: json["patients_count"],
        location: json["location"],
        phone: json["phone"],
        mail: json["mail"],
        address: json["address"],
        gst: json["gst"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "patients_count": patientsCount,
        "location": location,
        "phone": phone,
        "mail": mail,
        "address": address,
        "gst": gst,
        "is_active": isActive,
      };
}
