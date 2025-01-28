import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nedapp/feature/financingOptions/models/fund_usage_model.dart';
import 'package:nedapp/utils/all_extensions.dart';
import 'package:nedapp/utils/appstyle.dart';

class UseOfFundEntriesWidget extends HookWidget {
  final ValueNotifier<List<FundUsageModel>> entries;
  const UseOfFundEntriesWidget({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries.value.map((entry) {
        int index = entries.value.indexOf(entry);
        return Row(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 25,
                  child:
                      Text(entry.profession, style: AppTextStyle.labelStyle)),
              Expanded(
                  flex: 35,
                  child:
                      Text(entry.description, style: AppTextStyle.labelStyle)),
              Expanded(
                  flex: 20,
                  child: Text("\$${entry.amount.toString().formatWithCommas()}",
                      style: AppTextStyle.labelStyle)),
              Expanded(
                  flex: 20,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () {
                            entries.value = List.from(entries.value)
                              ..removeAt(index);
                          },
                          child: SvgPicture.asset("assets/images/delete.svg"))))
            ]);
      }).toList(),
    );
  }
}
