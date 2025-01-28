import 'package:nedapp/utils/constant_data.dart';

class Calculations {
  Calculations._();

  static double getRevenueSharePercentage(
      {required double revenueAmount, required double loanAmount}) {
    if (revenueAmount > 0 && loanAmount > 0) {
      double percentage =
          ((0.156 / 6.2055 / revenueAmount) * (loanAmount * 10)) * 100;
      return percentage;
    }
    return 0;
  }

  static double getTotalRevenueShare(
      {required double percentage, required double fundingAmount}) {
    return fundingAmount + (fundingAmount * (percentage));
  }

  static int getExpectedTransfers(
      {required double totalRevenueShare,
      required double fundingAmount,
      required double revenueAmount,
      required String revenueShareFrequency}) {
    if (revenueAmount > 0 && fundingAmount > 0) {
      double revenueSharePercentage = getRevenueSharePercentage(
              revenueAmount: revenueAmount, loanAmount: fundingAmount) /
          100;

      if (revenueShareFrequency.toLowerCase() == "weekly") {
        return ((totalRevenueShare * 52) /
                (revenueAmount * revenueSharePercentage))
            .ceil();
      } else {
        return ((totalRevenueShare * 12) /
                (revenueAmount * revenueSharePercentage))
            .ceil();
      }
    }
    return 0;
  }

  static String getFutureData(
      {required String revenueSharedFrequency,
      required int expectedTransfer,
      required String repaymentDelay}) {
    int months = 0;
    int days =
        int.tryParse(repaymentDelay.toLowerCase().split("day").first.trim()) ??
            0;
    int weeks = 0;
    DateTime currentDate = DateTime.now();
    if (revenueSharedFrequency.toLowerCase() == "weekly") {
      weeks = expectedTransfer;
    } else {
      months = expectedTransfer;
    }

    DateTime futureDate = currentDate.add(Duration(days: days + weeks * 7));

    int newMonth = (futureDate.month + months - 1) % 12 + 1;

    int yearAdjustment = (futureDate.month + months - 1) ~/ 12;

    int newYear = futureDate.year + yearAdjustment;

    DateTime finalDate = DateTime(newYear, newMonth, futureDate.day);

    return "${monthNames[finalDate.month]} ${finalDate.day}, ${finalDate.year}";
  }
}
