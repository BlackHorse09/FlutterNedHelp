import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nedapp/feature/financingOptions/models/api_response_model.dart';
import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/text_field_background_widget.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/text_field_prefix_widget.dart';
import 'package:nedapp/utils/appstyle.dart';

class DesiredLoanAmountWidget extends HookWidget {
  final ValueNotifier<double> annualBusinessRevenue;
  final ValueNotifier<double> fundingAmount;
  const DesiredLoanAmountWidget(
      {super.key,
      required this.annualBusinessRevenue,
      required this.fundingAmount});

  @override
  Widget build(BuildContext context) {
    var model = useState<ApiResponseModel>(
        DataRepository().getNamedModelData("funding_amount"));
    var sliderValue = useState<double>(0);
    var maxValue = useState<double>(0);
    var minValue = useState<double>(0);
    var controller = useTextEditingController();

    useEffect(() {
      // Assigning initial values
      maxValue.value = DataRepository()
          .getMaximumValue(annualAmount: annualBusinessRevenue.value);
      minValue.value = DataRepository()
          .getMinimumValue(annualAmount: annualBusinessRevenue.value);
      // Default Value of Slider when annual revenue business amount is changed
      sliderValue.value = (maxValue.value + minValue.value) / 2;
      controller.text = sliderValue.value.toStringAsFixed(0);
      return null;
    }, [annualBusinessRevenue.value]);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Tooltip(
          message: model.value.tooltip,
          child: Text(model.value.label, style: AppTextStyle.labelStyle)),
      const SizedBox(height: 20),
      Row(spacing: 24, children: [
        Expanded(
            flex: 75,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("\$${minValue.value.toStringAsFixed(0)}",
                    style: AppTextStyle.labelStyle),
                Text("\$${maxValue.value.toStringAsFixed(0)}",
                    style: AppTextStyle.labelStyle)
              ]),
              const SizedBox(height: 20),
              SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                      value: sliderValue.value,
                      activeColor: Colors.blue,
                      onChanged: (val) {
                        sliderValue.value = val;
                        controller.text = val.toStringAsFixed(0);
                        fundingAmount.value = val;
                      },
                      min: minValue.value,
                      max: maxValue.value))
            ])),
        Expanded(
            flex: 25,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: TextFieldBackgroundWidget(
                    child: TextField(
                        controller: controller,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (controller.text.isNotEmpty) {
                            double controllerValue =
                                double.tryParse(controller.text) ?? 0.0;
                            if (controllerValue >= minValue.value &&
                                controllerValue <= maxValue.value) {
                              sliderValue.value = controllerValue;
                              fundingAmount.value = controllerValue;
                            }
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 2),
                            hintText: "Amount",
                            border: InputBorder.none,
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 0, minHeight: 0),
                            prefixIcon: TextFieldPrefixWidget())))))
      ])
    ]);
  }
}
