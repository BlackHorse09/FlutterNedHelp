import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nedapp/feature/financingOptions/models/api_response_model.dart';
import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/text_field_background_widget.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/text_field_prefix_widget.dart';
import 'package:nedapp/utils/appstyle.dart';

class AnnualBusinessRevenueWidget extends HookWidget {
  final ValueNotifier<double> annualBusinessRevenue;
  final ValueNotifier<double> fundingAmount;
  const AnnualBusinessRevenueWidget(
      {super.key,
      required this.annualBusinessRevenue,
      required this.fundingAmount});

  @override
  Widget build(BuildContext context) {
    var controller =
        useTextEditingController(text: annualBusinessRevenue.value.toString());

    final model = useState<ApiResponseModel>(
        DataRepository().getNamedModelData("revenue_amount"));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Tooltip(
        message: model.value.tooltip,
        child: RichText(
          text: TextSpan(
              text: model.value.label,
              style: AppTextStyle.labelStyle,
              children: [
                TextSpan(
                    text: " *",
                    style: AppTextStyle.labelStyle
                        .copyWith(color: Colors.redAccent))
              ]),
        ),
      ),
      const SizedBox(height: 12),
      TextFieldBackgroundWidget(
          child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  hintText: model.value.placeholder,
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  prefixIcon: TextFieldPrefixWidget()),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (double.tryParse(value) != 0.0) {
                    annualBusinessRevenue.value = double.tryParse(value) ?? 0.0;
                    fundingAmount.value = DataRepository().getFundingAmount(
                        annualAmount: annualBusinessRevenue.value);
                  } else {
                    annualBusinessRevenue.value = 0;
                    fundingAmount.value = 0;
                  }
                } else {
                  annualBusinessRevenue.value = 0;
                  fundingAmount.value = 0;
                }
              }))
    ]);
  }
}
