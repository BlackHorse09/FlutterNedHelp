import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nedapp/feature/financingOptions/models/api_response_model.dart';
import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';
import 'package:nedapp/utils/appstyle.dart';

class DesiredRepaymentDelayWidget extends HookWidget {
  final ValueNotifier<String> desiredRepaymentDelayDays;
  const DesiredRepaymentDelayWidget(
      {super.key, required this.desiredRepaymentDelayDays});

  @override
  Widget build(BuildContext context) {
    final model = useState<ApiResponseModel>(
        DataRepository().getNamedModelData("desired_repayment_delay"));
    return Row(children: [
      Expanded(
          flex: 42,
          child: Tooltip(
            message: model.value.tooltip,
            child: Text(model.value.label,
                style: AppTextStyle.labelStyle),
          )),
      Flexible(
          flex: 58,
          child: SizedBox(
              width: 150,
              child: DropdownButton<String>(
                  value: desiredRepaymentDelayDays.value,
                  elevation: 3,
                  underline: SizedBox.shrink(),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  style:
                      AppTextStyle.dropDownStyle.copyWith(color: Colors.blue),
                  items: model.value.value.split("*").map((day) {
                    return DropdownMenuItem<String>(
                        value: day,
                        child: Row(children: [
                          Text(day, style: AppTextStyle.dropDownStyle)
                        ]));
                  }).toList(),
                  onChanged: (value) {
                    desiredRepaymentDelayDays.value = value ?? "30 Days";
                  })))
    ]);
  }
}
