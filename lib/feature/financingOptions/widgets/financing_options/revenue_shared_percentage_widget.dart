import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';

import 'package:nedapp/utils/appstyle.dart';

class RevenueSharedPercentageWidget extends HookWidget {
  final double percentage;
  const RevenueSharedPercentageWidget({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final repo = useMemoized(() => DataRepository());
    
    var model =
        useState(DataRepository().getNamedModelData("revenue_percentage"));
    var errMsg = useState<String?>(null);

    useEffect(() {
      if (repo.revenueMinPercentage < percentage &&
          percentage < repo.revenueMaxPercentage) {
        errMsg.value = null;
      } else {
        errMsg.value =
            "Revenue Share Percentage should be between ${repo.revenueMinPercentage}% to ${repo.revenueMaxPercentage}%";
      }
      return null;
    }, [percentage]);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(spacing: 16, children: [
            Tooltip(
                message: model.value.tooltip,
                child: Text(model.value.label, style: AppTextStyle.labelStyle)),
            Text(" ${percentage.toStringAsFixed(2)}%",
                style:
                    AppTextStyle.labelStyle.copyWith(color: Color(0xff0e7cf4)))
          ]),
          errMsg.value != null
              ? Text("${errMsg.value}",
                  style:
                      AppTextStyle.labelStyle.copyWith(color: Colors.redAccent))
              : SizedBox.shrink()
        ]);
  }
}
