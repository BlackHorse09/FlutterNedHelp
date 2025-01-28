import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nedapp/feature/financingOptions/models/api_response_model.dart';
import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';
import 'package:nedapp/feature/financingOptions/widgets/common/ui_button.dart';
import 'package:nedapp/feature/financingOptions/widgets/financing_options/financing_options.dart';
import 'package:nedapp/feature/financingOptions/widgets/results/results_widget.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Initialzing variables

    var annualBussinessRevenue = useState<double>(0);
    var fundingAmount = useState<double>(0);
    var revenueSharedFrequency = useState<String>("");
    var desiredRepaymentDelayDays = useState<String>("");

    var apiData = useState<List<ApiResponseModel>>([]);
    var error = useState<String?>(null);
    var loading = useState<bool>(true);

    useEffect(() {
      Future<void> fetchData() async {
        try {
          final repo = DataRepository();
          final result = await DataRepository().getData();
          apiData.value = result;

          //Assigning Initial values
          annualBussinessRevenue.value = repo.getInitialAnnualRevenueAmount();
          fundingAmount.value = (repo.getFundingAmount(
              annualAmount: annualBussinessRevenue.value));
          desiredRepaymentDelayDays.value =
              repo.getAnyValue("desired_repayment_delay");
          revenueSharedFrequency.value =
              repo.getAnyValue("revenue_shared_frequency");
        } catch (e) {
          error.value = 'Failed to load data';
        } finally {
          loading.value = false;
        }
      }

      fetchData();
      return null;
    }, []);

    if (loading.value) {
      return Center(child: CircularProgressIndicator());
    }

    if (error.value != null) {
      return Center(
        child: Text("${error.value}"),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            spacing: 24,
            children: [
              Expanded(
                flex: 85,
                child: Row(
                  spacing: 24,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 55,
                      child: FinancingOptions(
                          annualBusinessRevenue: annualBussinessRevenue,
                          fundingAmount: fundingAmount,
                          revenueSharedFrequency: revenueSharedFrequency,
                          desiredRepaymentDelayDays: desiredRepaymentDelayDays),
                    ),
                    Expanded(
                      flex: 45,
                      child: ResultsWidget(
                          annualBusinessRevenue: annualBussinessRevenue,
                          fundingAmount: fundingAmount,
                          revenueSharedFrequency: revenueSharedFrequency,
                          desiredRepaymentDelayDays: desiredRepaymentDelayDays),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                  ),
                  child: Row(
                    spacing: 24,
                    children: [
                      Expanded(
                        flex: 55,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                          child: UiButton(title: "BACK"),
                        ),
                      ),
                      Expanded(
                          flex: 45,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                            child: UiButton(title: "NEXT", background: true,),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
