import 'package:flutter/material.dart';
import 'package:manage_expense_app/models/expense.dart';
import 'package:manage_expense_app/widgets/expense_list/expense_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.onRemoveExpense});
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: expenses.length,
        itemBuilder: (context, index) => Dismissible(
            key: ValueKey(expenses[index]),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.5),
              margin: EdgeInsets.symmetric(
                  horizontal: Theme.of(context).cardTheme.margin!.horizontal),
            ),
            onDismissed: (direction) {
              onRemoveExpense(expenses[index]);
            },
            child: ExpenseItem(expenses[index])));
  }
}
