import 'package:flutter/material.dart';
import 'package:nedapp/feature/financingOptions/models/api_response_model.dart';
import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';
import 'package:nedapp/utils/appstyle.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart';

class RevenueSharedFrequency extends StatefulWidget {
  final ValueNotifier<String> revenueSharedFrequency;
  const RevenueSharedFrequency(
      {super.key, required this.revenueSharedFrequency});

  @override
  State<RevenueSharedFrequency> createState() => _RevenueSharedFrequencyState();
}

class _RevenueSharedFrequencyState extends State<RevenueSharedFrequency> {
  late ApiResponseModel responseModel;
  RadioGroupController myController = RadioGroupController();

  @override
  void initState() {
    super.initState();
    responseModel =
        DataRepository().getNamedModelData("revenue_shared_frequency");
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 40,
          child: Tooltip(
              message: responseModel.tooltip,
              child:
                  Text(responseModel.label, style: AppTextStyle.labelStyle))),
      Expanded(
          flex: 60,
          child: Align(
              alignment: Alignment.centerLeft,
              child: RadioGroup(
                  onChanged: (value) {
                    myController.value = value;
                    widget.revenueSharedFrequency.value = value;
                  },
                  controller: myController,
                  values: responseModel.value.split("*"),
                  indexOfDefault: 0,
                  orientation: RadioGroupOrientation.horizontal,
                  decoration: RadioGroupDecoration(
                      spacing: 10.0,
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      activeColor: Colors.blue))))
    ]);
  }
}
