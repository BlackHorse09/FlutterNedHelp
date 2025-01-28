import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nedapp/feature/financingOptions/models/api_response_model.dart';

class ApiService {
  final Dio dio = Dio();
  Future<List<ApiResponseModel>> fetchData() async {
    try {
      final response = await dio.get('https://gist.githubusercontent.com/motgi/8fc373cbfccee534c820875ba20ae7b5/raw/7143758ff2caa773e651dc3576de57cc829339c0/config.json');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.data);
    return jsonData.map((item) => ApiResponseModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      
      throw Exception('Error fetching data: $e');
    }
  }
}
