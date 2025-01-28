import 'package:nedapp/feature/financingOptions/data_source.dart/api_service.dart';
import 'package:nedapp/feature/financingOptions/models/api_response_model.dart';

class DataRepository {
  static final DataRepository _instance = DataRepository._internal();

  factory DataRepository() => _instance;

  DataRepository._internal();

  List<ApiResponseModel>? _responseData;

  Future<List<ApiResponseModel>> getData() async {
    _responseData ??= await ApiService().fetchData();
    return _responseData!;
  }

  Future<void> refreshData() async {
    _responseData = null;
    _responseData = await getData();
  }

  ApiResponseModel getNamedModelData(String name) {
    ApiResponseModel? model =
        _responseData?.where((element) => element.name == name).first;
    if (model == null) {
      return ApiResponseModel(
          name: name, value: "", label: "", placeholder: "", tooltip: "");
    }
    return model;
  }

  double getInitialAnnualRevenueAmount() {
    ApiResponseModel? model = getNamedModelData("revenue_amount");
    if (model.value.isEmpty) {
      return 0;
    }
    return double.tryParse(model.value) ?? 0;
  }

  String getAnyValue(String name, {bool hasDelimiter = true}) {
    ApiResponseModel model = getNamedModelData(name);
    if (hasDelimiter) {
      return model.value.split("*").first;
    }
    return model.value;
  }

  double getMinimumValue({required double annualAmount}) {
    ApiResponseModel model = getNamedModelData("funding_amount_min");
    if (model.value.isNotEmpty) {
      double minValue = double.tryParse(model.value) ?? 0;
      if ((annualAmount / 3) > minValue) {
        return minValue;
      }
      return 0;
    }
    return 0;
  }

  double getMaximumValue({required double annualAmount}) {
    ApiResponseModel model = getNamedModelData("funding_amount_max");
    if (model.value.isNotEmpty) {
      double maxValue = double.tryParse(model.value) ?? 0;
      if ((annualAmount / 3) < maxValue) {
        return (annualAmount / 3);
      }
      return maxValue;
    }
    return 0;
  }

  double getFundingAmount({required double annualAmount}) {
    return ((getMaximumValue(annualAmount: annualAmount) +
            getMinimumValue(annualAmount: annualAmount)) /
        2);
  }

  double getMinMaxRevnuePercentage(String name, {double defaultValue = 4}) {
    var model = getNamedModelData(name);
    if (model.value.isEmpty) {
      return defaultValue;
    }
    return double.tryParse(model.value) ?? 0;
  }

  double getFeesPercentage() {
    ApiResponseModel model = getNamedModelData("desired_fee_percentage");
    if (model.value.isNotEmpty) {
      return double.tryParse(model.value) ?? 0.5;
    } else {
      return 0.5;
    }
  }
}
