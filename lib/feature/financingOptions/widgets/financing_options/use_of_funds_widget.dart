import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nedapp/feature/financingOptions/models/api_response_model.dart';
import 'package:nedapp/feature/financingOptions/models/fund_usage_model.dart';
import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/text_field_background_widget.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/text_field_prefix_widget.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/use_of_fund_entries_widget.dart';
import 'package:nedapp/utils/appstyle.dart';

class UseOfFundsWidget extends HookWidget {
  const UseOfFundsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var model = useState<ApiResponseModel>(
        DataRepository().getNamedModelData("use_of_funds"));

    var profession = useState<String>(model.value.value.split("*").first);
    var entries = useState<List<FundUsageModel>>([]);
    var description = useTextEditingController();
    var amount = useTextEditingController();
    return Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
              message: model.value.tooltip,
              child: Text(model.value.label, style: AppTextStyle.labelStyle)),
          Row(spacing: 24, children: [
            Expanded(
              flex: 25,
              child: DropdownButton<String>(
                  value: profession.value,
                  dropdownColor: Colors.white,
                  underline: SizedBox.shrink(),
                  isExpanded: true,
                  style:
                      AppTextStyle.dropDownStyle.copyWith(color: Colors.blue),
                  items: model.value.value.split("*").map((profession) {
                    return DropdownMenuItem<String>(
                        value: profession,
                        child: Row(children: [
                          Expanded(
                              child: Text(profession,
                                  style: AppTextStyle.dropDownStyle))
                        ]));
                  }).toList(),
                  onChanged: (value) {
                    profession.value = value ?? "Marketing";
                  }),
            ),
            Expanded(
                flex: 35,
                child: TextFieldBackgroundWidget(
                    child: TextField(
                        controller: description,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            hintText: "Description")))),
            Expanded(
                flex: 20,
                child: TextFieldBackgroundWidget(
                    child: TextField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 2),
                            prefix: TextFieldPrefixWidget(),
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 0, minHeight: 0),
                            hintText: "Amount")))),
            Expanded(
                flex: 20,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: () {
                          if (description.text.isNotEmpty &&
                              amount.text.isNotEmpty) {
                            entries.value = [
                              ...entries.value,
                              FundUsageModel(
                                  amount: amount.text,
                                  description: description.text,
                                  profession: profession.value)
                            ];
                            description.clear();
                            amount.clear();
                          }
                        },
                        child: SvgPicture.asset("assets/images/add.svg"))))
          ]),
          entries.value.isNotEmpty
              ? UseOfFundEntriesWidget(entries: entries)
              : SizedBox.shrink(),
          const SizedBox(height: 24)
        ]);
  }
}
