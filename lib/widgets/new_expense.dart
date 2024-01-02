import 'package:flutter/material.dart';
import 'package:manage_expense_app/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? selectedDate;
  Category selectedCategory = Category.leisure;

  void presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      selectedDate = pickedDate;
    });
    //       .then((value) => null);
  }

  void submitExpensedata() {
    final enteredAmount = double.tryParse(amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        selectedDate == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Invalid Input"),
                content: const Text(
                    "Please make sure a valid title,amount,date and category is entered."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              ));
      return;
    }
    widget.onAddExpense(
      Expense(
        title: titleController.text,
        amount: enteredAmount,
        date: selectedDate!,
        category: selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }
  // var enteredTitle = "";
  // void saveTitle(String inputValue) {
  //   enteredTitle = inputValue;
  // }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: titleController,
                            maxLength: 50,
                            decoration: InputDecoration(
                                label: Text("Title  ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: '\$ ',
                              label: Text("Amount ",
                                  style: Theme.of(context).textTheme.titleMedium
                                  // TextStyle(
                                  //     fontSize: 18,
                                  //     color: Color.fromARGB(255, 78, 47, 96)),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: titleController,
                      maxLength: 50,
                      decoration: InputDecoration(
                          label: Text("Title  ",
                              style: Theme.of(context).textTheme.titleMedium)),
                    ),
                  const SizedBox(height: 10),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                            value: selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  selectedDate == null
                                      ? 'Select Date '
                                      : formatter.format(selectedDate!),
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              IconButton(
                                  onPressed: presentDatePicker,
                                  icon:
                                      const Icon(Icons.calendar_month_outlined))
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: '\$ ',
                              label: Text("Amount ",
                                  style: Theme.of(context).textTheme.titleMedium
                                  // TextStyle(
                                  //     fontSize: 18,
                                  //     color: Color.fromARGB(255, 78, 47, 96)),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  selectedDate == null
                                      ? 'Select Date '
                                      : formatter.format(selectedDate!),
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              IconButton(
                                  onPressed: presentDatePicker,
                                  icon:
                                      const Icon(Icons.calendar_month_outlined))
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(height: 40),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        const Spacer(),
                        ElevatedButton(
                            // style: ElevatedButton.styleFrom(
                            //     backgroundColor: Theme.of(context).primaryColor,
                            //     foregroundColor: Colors.white),
                            onPressed: submitExpensedata,
                            child: const Text("Save Expense")),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                            value: selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        const Spacer(),
                        ElevatedButton(
                            // style: ElevatedButton.styleFrom(
                            //     backgroundColor: Theme.of(context).primaryColor,
                            //     foregroundColor: Colors.white),
                            onPressed: submitExpensedata,
                            child: const Text("Save Expense")),
                      ],
                    )
                ],
              )),
        ),
      );
    });
  }
}
