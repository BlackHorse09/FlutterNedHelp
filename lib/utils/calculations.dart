import 'package:nedapp/feature/financingOptions/singleton/data_repository.dart';
import 'package:nedapp/utils/constant_data.dart';

class Calculations {
  Calculations._();

  static double getRevenueSharePercentage(
      {required double revenueAmount, required double loanAmount}) {
    final repo = DataRepository();

    if (revenueAmount > 0 && loanAmount > 0) {
      double percentage =
          ((0.156 / 6.2055 / revenueAmount) * (loanAmount * 10)) * 100;
      if (percentage < repo.revenueMinPercentage) {
        return repo.revenueMinPercentage;
      } else if (percentage > repo.revenueMaxPercentage) {
        return repo.revenueMaxPercentage;
      } else {
        return percentage;
      }
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
      int expectedTransfers = 0;
      double revenueSharePercentage = getRevenueSharePercentage(
              revenueAmount: revenueAmount, loanAmount: fundingAmount) /
          100;

      if (revenueShareFrequency.toLowerCase() == "weekly") {
        expectedTransfers = ((totalRevenueShare * 52) /
                (revenueAmount * revenueSharePercentage))
            .ceil();

        if (expectedTransfers > 400) {
          return 400;
        }
        return expectedTransfers;
      } else {
        expectedTransfers = ((totalRevenueShare * 12) /
                (revenueAmount * revenueSharePercentage))
            .ceil();
        if (expectedTransfers > 100) {
          return 100;
        }
        return expectedTransfers;
      }
    }
    return 0;
  }

  static DateTime getFutureData(
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
    return DateTime(newYear, newMonth, futureDate.day);
  }

  static String getFutureDateToString({required DateTime futureDate}) {
    return "${monthNames[futureDate.month]} ${futureDate.day}, ${futureDate.year}";
  }

  static double getAprValue(
      {required double percentage,
      required double fundingAmount,
      required DateTime futureDate}) {
    double feesAmount = fundingAmount * percentage;
    int numberOfDays = futureDate.difference(DateTime.now()).inDays;
    if (feesAmount > 0) {
      return (((feesAmount / fundingAmount) / numberOfDays) * 365) * 100;
    }
    return 0;
  }
}
