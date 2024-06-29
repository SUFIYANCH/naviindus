import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naviindus/models/branch_model.dart';
import 'package:naviindus/models/login_model.dart';
import 'package:naviindus/models/patientList_model.dart';
import 'package:naviindus/models/register_model.dart';
import 'package:naviindus/models/treatment_model.dart';

class ApiService {
  static late String token;
  final Dio dio =
      Dio(BaseOptions(baseUrl: "https://flutter-amr.noviindus.in/api/"));

  Future<LoginModel?> loginApi(String username, String password) async {
    try {
      Response response = await dio.post("Login",
          data: FormData.fromMap({"username": username, "password": password}));
      if (response.statusCode == 200) {
        String json = jsonEncode(response.data);

        return loginModelFromJson(json);
      }
    } on DioException catch (e) {
      log("Login error:$e");
    }
    return null;
  }

  Future<PatientListModel?> patientListApi() async {
    try {
      Response response = await dio.get("PatientList",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        String json = jsonEncode(response.data);

        return patientListModelFromJson(json);
      }
    } on DioException catch (e) {
      log("PatientsList error:$e");
    }
    return null;
  }

  Future<bool> registerApi() async {
    try {
      Response response = await dio.post("PatientUpdate",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      log("Branch error:$e");
    }
    return false;
  }

  Future<BranchModel?> branchApi() async {
    try {
      Response response = await dio.get("BranchList",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        String json = jsonEncode(response.data);

        return branchModelFromJson(json);
      }
    } on DioException catch (e) {
      log("Branch error:$e");
    }
    return null;
  }

  Future<TreatmentModel?> treatmentApi() async {
    try {
      Response response = await dio.get("TreatmentList",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        String json = jsonEncode(response.data);

        return treatmentModelFromJson(json);
      }
    } on DioException catch (e) {
      log("Treatment error:$e");
    }
    return null;
  }
}

final patientListProvider = FutureProvider<PatientListModel?>((ref) async {
  return ApiService().patientListApi();
});
final branchListProvider = FutureProvider<BranchModel?>((ref) async {
  return ApiService().branchApi();
});
