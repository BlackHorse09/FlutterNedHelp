import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';
import 'package:nedapp/feature/financingOptions/widgets/common/header.dart';
import 'package:nedapp/feature/financingOptions/widgets/results/result_row_entry_widget.dart';
import 'package:nedapp/utils/all_extensions.dart';
import 'package:nedapp/utils/app_strings.dart';
import 'package:nedapp/utils/calculations.dart';

class ResultsWidget extends HookWidget {
  final ValueNotifier<double> annualBusinessRevenue;
  final ValueNotifier<double> fundingAmount;

  final ValueNotifier<String> revenueSharedFrequency;
  final ValueNotifier<String> desiredRepaymentDelayDays;
  const ResultsWidget(
      {super.key,
      required this.annualBusinessRevenue,
      required this.fundingAmount,
      required this.revenueSharedFrequency,
      required this.desiredRepaymentDelayDays});

  @override
  Widget build(BuildContext context) {
    var totalRevenueShare = useState<double>(0);
    var expectedTransfers = useState<int>(0);
    var feePercentage = useState<double>(DataRepository().getFeesPercentage());
    var futureDate = useState<DateTime>(DateTime.now());
    useEffect(() {
      totalRevenueShare.value = Calculations.getTotalRevenueShare(
          percentage: feePercentage.value, fundingAmount: fundingAmount.value);
      expectedTransfers.value = Calculations.getExpectedTransfers(
          totalRevenueShare: totalRevenueShare.value,
          fundingAmount: fundingAmount.value,
          revenueAmount: annualBusinessRevenue.value,
          revenueShareFrequency: revenueSharedFrequency.value);
      futureDate.value = Calculations.getFutureData(
          revenueSharedFrequency: revenueSharedFrequency.value,
          expectedTransfer: expectedTransfers.value,
          repaymentDelay: desiredRepaymentDelayDays.value);
      return null;
    }, [
      fundingAmount.value,
      annualBusinessRevenue.value,
      desiredRepaymentDelayDays.value,
      revenueSharedFrequency.value,
      feePercentage.value,
      futureDate.value
    ]);
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: Column(
                spacing: 36,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(title: AppStrings.results),
                  Column(spacing: 24, children: [
                    ResultRowEntryWidget(
                        label: AppStrings.annualBusinessRevenue,
                        value:
                            "\$${annualBusinessRevenue.value.round().toString().formatWithCommas()}"),
                    ResultRowEntryWidget(
                        label: AppStrings.fundingAmount,
                        value:
                            "\$${fundingAmount.value.round().toString().formatWithCommas()}"),
                    ResultRowEntryWidget(
                        label: AppStrings.fees,
                        value:
                            "(${(feePercentage.value * 100).round()}%) \$${(fundingAmount.value * feePercentage.value).round().toString().formatWithCommas()}"),
                            ResultRowEntryWidget(
                        label: AppStrings.apr,
                        value: Calculations.getAprValue(percentage: feePercentage.value, fundingAmount: fundingAmount.value, futureDate: futureDate.value).toStringAsFixed(2)),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Divider()),
                    ResultRowEntryWidget(
                        label: AppStrings.totalRevenueShare,
                        value:
                            "\$${totalRevenueShare.value.round().toString().formatWithCommas()}"),
                    ResultRowEntryWidget(
                        label: AppStrings.expectedTransfers,
                        value: "${expectedTransfers.value}"),
                    ResultRowEntryWidget(
                        label: AppStrings.expectedCompletionDate,
                        blueColorValue: true,
                        value: Calculations.getFutureDateToString(
                            futureDate: futureDate.value))
                  ])
                ])));
  }
}
