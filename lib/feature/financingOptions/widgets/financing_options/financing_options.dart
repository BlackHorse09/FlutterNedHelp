import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/annual_business_revenue_widget.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/desired_loan_amount_widget.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/desired_repayment_delay_widget.dart';
import 'package:nedapp/feature/financingOptions/widgets/common/header.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/revenue_shared_frequency.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/revenue_shared_percentage_widget.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/use_of_funds_widget.dart';
import 'package:nedapp/utils/app_strings.dart';
import 'package:nedapp/utils/calculations.dart';

class FinancingOptions extends HookWidget {
  final ValueNotifier<double> annualBusinessRevenue;
  final ValueNotifier<double> fundingAmount;
  final ValueNotifier<String> revenueSharedFrequency;
  final ValueNotifier<String> desiredRepaymentDelayDays;
  const FinancingOptions(
      {super.key,
      required this.annualBusinessRevenue,
      required this.fundingAmount,
      required this.revenueSharedFrequency,
      required this.desiredRepaymentDelayDays});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: Column(
                spacing: 24,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(title: AppStrings.financingOptions),
                  SizedBox(height: 24),
                  AnnualBusinessRevenueWidget(
                      annualBusinessRevenue: annualBusinessRevenue,
                      fundingAmount: fundingAmount),
                  DesiredLoanAmountWidget(
                      annualBusinessRevenue: annualBusinessRevenue,
                      fundingAmount: fundingAmount),
                  RevenueSharedPercentageWidget(
                      percentage: Calculations.getRevenueSharePercentage(
                          revenueAmount: annualBusinessRevenue.value,
                          loanAmount: fundingAmount.value)),
                  RevenueSharedFrequency(
                      revenueSharedFrequency: revenueSharedFrequency),
                  DesiredRepaymentDelayWidget(
                      desiredRepaymentDelayDays: desiredRepaymentDelayDays),
                  UseOfFundsWidget()
                ])));
  }
}
