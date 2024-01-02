import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:manage_expense_app/widgets/chart/chart.dart';
import 'package:manage_expense_app/widgets/expense_list.dart';
import 'package:manage_expense_app/models/expense.dart';
import 'package:manage_expense_app/widgets/new_expense.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 48, 101, 145)
        // const Color.fromARGB(255, 204, 114, 234)
        );

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 49, 83, 92),
);

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((value) => {});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        cardTheme: const CardTheme().copyWith(
            color: kDarkColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        colorScheme: kDarkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: kDarkColorScheme.primaryContainer,
          foregroundColor: kDarkColorScheme.onPrimaryContainer,
        )),
      ),
      title: 'Expense Tracker',
      theme:
          // ThemeData().copyWith(useMaterial3: true, colorScheme: kColorScheme),
          ThemeData().copyWith(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 42, 89, 128)),
              appBarTheme: const AppBarTheme().copyWith(
                backgroundColor: kColorScheme.onPrimaryContainer,
                foregroundColor: kColorScheme.primaryContainer,
                // centerTitle: true,
              ),
              cardTheme: const CardTheme().copyWith(
                  color: kColorScheme.secondaryContainer,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer,
              )),
              textTheme: ThemeData().textTheme.copyWith(
                    titleLarge: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: kColorScheme.onSecondaryContainer,
                        fontSize: 18),
                    titleMedium: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: kColorScheme.onSecondaryContainer,
                        fontSize: 16),
                  )),
      themeMode: ThemeMode.system,
      home: const HomeScreen(title: 'Expense Tracker'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 999,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: "Maldives",
        amount: 539,
        date: DateTime.now(),
        category: Category.travel),
  ];

  OpenAddExpense() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => NewExpense(onAddExpense: addExpense));
  }

  void addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        "Expense deleted",
        style: TextStyle(fontSize: 16),
      ),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Widget maincontent = const Center(
      child: Text(
        "No expenses found.Lets add some !!",
        style: TextStyle(fontSize: 18),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      maincontent = ExpenseList(
          expenses: _registeredExpenses, onRemoveExpense: removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(onPressed: OpenAddExpense, icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: width < 600
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chart(expenses: _registeredExpenses),
                  const SizedBox(height: 15),
                  Expanded(child: maincontent)
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  const SizedBox(height: 15),
                  Expanded(child: maincontent)
                ],
              ),
      ),
    );
  }
}
