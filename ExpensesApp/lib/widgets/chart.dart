import 'package:flutter/material.dart';
import '../model/transaction.dart';
import '../widgets/chartbar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart(this.recentTransaction);
  List<Map<String, Object>> get groupedTransactions {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(
          Duration(days: index),
        );
        var totalSum = 0.0;
        for (int i = 0; i < recentTransaction.length; i++) {
          if (recentTransaction[i].time.day == weekDay.day &&
              recentTransaction[i].time.month == weekDay.month &&
              recentTransaction[i].time.year == weekDay.year) {
              totalSum += recentTransaction[i].amount;
          }
        }
        return {
          'day': DateFormat.E().format(weekDay).substring(0,1),
          'amount': totalSum,
        };
      },
    ).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  double get totalSpending {
    return groupedTransactions.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }
}
