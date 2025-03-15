import 'package:flutter/material.dart';

void main() {
  runApp(WeeklyPlannerApp());
}

class WeeklyPlannerApp extends StatefulWidget {
  @override
  _WeeklyPlannerAppState createState() => _WeeklyPlannerAppState();
}

class _WeeklyPlannerAppState extends State<WeeklyPlannerApp> {
  final Map<String, ThemeData> themes = {
    "Light": ThemeData.light(),
    "Dark": ThemeData.dark(),
    "Blue": ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.blue.shade100,
      appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
    ),
    "Green": ThemeData(
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.green.shade100,
      appBarTheme: AppBarTheme(backgroundColor: Colors.green),
    ),
    "Brown": ThemeData(
      primarySwatch: Colors.brown,
      scaffoldBackgroundColor: Color(0xFFF5E6DA),
      appBarTheme: AppBarTheme(backgroundColor: Colors.brown),
    ),
  };

  String _selectedTheme = "Light";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themes[_selectedTheme] ?? ThemeData.light(),
      home: WeeklyPlannerScreen(
        onThemeChanged: (String theme) {
          setState(() {
            _selectedTheme = theme;
          });
        },
        selectedTheme: _selectedTheme,
        themes: themes.keys.toList(),
      ),
    );
  }
}

class WeeklyPlannerScreen extends StatefulWidget {
  final Function(String) onThemeChanged;
  final String selectedTheme;
  final List<String> themes;

  WeeklyPlannerScreen({
    required this.onThemeChanged,
    required this.selectedTheme,
    required this.themes,
  });

  @override
  _WeeklyPlannerScreenState createState() => _WeeklyPlannerScreenState();
}

class _WeeklyPlannerScreenState extends State<WeeklyPlannerScreen> {
  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  Map<String, List<Map<String, dynamic>>> todoLists = {};
  Map<String, TextEditingController> todoControllers = {};
  Map<String, TextEditingController> timeControllers = {};

  @override
  void initState() {
    super.initState();
    for (var day in days) {
      todoLists[day] = [];
      todoControllers[day] = TextEditingController();
      timeControllers[day] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in todoControllers.values) {
      controller.dispose();
    }
    for (var controller in timeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void addTask(String day) {
    if (todoControllers[day]!.text.isNotEmpty &&
        timeControllers[day]!.text.isNotEmpty) {
      setState(() {
        todoLists[day]!.add({
          "task": todoControllers[day]!.text,
          "time": timeControllers[day]!.text,
          "completed": false
        });
        todoControllers[day]!.clear();
        timeControllers[day]!.clear();
      });
    }
  }

  void toggleTaskCompletion(String day, int index) {
    setState(() {
      todoLists[day]![index]["completed"] =
          !todoLists[day]![index]["completed"];
    });
  }

  void removeTask(String day, int index) {
    setState(() {
      todoLists[day]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly To-Do List"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Calendar"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarScreen()),
                );
              },
            ),
           Divider(),
Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: Text(
    "Select Theme",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
),
Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  child: DropdownButton<String>(
    isExpanded: true,
    value: widget.selectedTheme,
    items: widget.themes.map((String theme) {
      return DropdownMenuItem<String>(
        value: theme,
        child: Text(theme),
      );
    }).toList(),
    onChanged: (String? newTheme) {
      if (newTheme != null) {
        widget.onThemeChanged(newTheme);
      }
    },
  ),
),

          ],
        ),
      ),

body: Padding(
  padding: EdgeInsets.all(10.0),
  child: ListView.builder(
    itemCount: days.length,
    itemBuilder: (context, index) {
      String day = days[index];
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoControllers[day],
                    decoration: InputDecoration(
                      hintText: "Add task...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 10), // Increased size
                    ),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: timeControllers[day],
                    decoration: InputDecoration(
                      hintText: "Time",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 10), // Increased size
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green),
                  onPressed: () => addTask(day),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: todoLists[day]!.asMap().entries.map((entry) {
                int taskIndex = entry.key;
                var task = entry.value;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Checkbox(
                      value: task["completed"],
                      onChanged: (bool? value) {
                        toggleTaskCompletion(day, taskIndex);
                      },
                    ),
                    title: Text(
                      "${task["task"]} - ${task["time"]}",
                      style: TextStyle(
                        fontSize: 14,
                        decoration: task["completed"]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red, size: 18),
                      onPressed: () => removeTask(day, taskIndex),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    },
  ),
),
    );
  }
}

// CalendarScreen: shows months (for year 2025). Tapping a month navigates to MonthDaysScreen.
class CalendarScreen extends StatelessWidget {
  final List<String> months = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  final int year = 2025;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: months.map((month) {
            int monthNumber = months.indexOf(month) + 1;
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MonthDaysScreen(month: monthNumber, year: year)),
                  );
                },
                child: Center(
                  child: Text(
                    month,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// MonthDaysScreen: shows day numbers for the selected month/year.
class MonthDaysScreen extends StatelessWidget {
  final int month;
  final int year;

  MonthDaysScreen({required this.month, required this.year});

  int daysInMonth(int month, int year) {
    DateTime firstDayNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    DateTime lastDay = firstDayNextMonth.subtract(Duration(days: 1));
    return lastDay.day;
  }

  @override
  Widget build(BuildContext context) {
    int totalDays = daysInMonth(month, year);
    return Scaffold(
      appBar: AppBar(
        title: Text("Month: $month / $year"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, crossAxisSpacing: 5, mainAxisSpacing: 5),
          itemCount: totalDays,
          itemBuilder: (context, index) {
            int day = index + 1;
            return Card(
              child: InkWell(
                onTap: () {
                  DateTime selectedDate = DateTime(year, month, day);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WeeklyTodoScreen(selectedDate: selectedDate)),
                  );
                },
                child: Center(
                  child: Text(
                    "$day",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// WeeklyTodoScreen: displays the weekly to-do list (Monday to Sunday) for the week containing the selected date.
class WeeklyTodoScreen extends StatefulWidget {
  final DateTime selectedDate;
  WeeklyTodoScreen({required this.selectedDate});

  @override
  _WeeklyTodoScreenState createState() => _WeeklyTodoScreenState();
}

class _WeeklyTodoScreenState extends State<WeeklyTodoScreen> {
  late DateTime monday;
  late DateTime sunday;
  late List<String> weekDays;
  Map<String, List<Map<String, dynamic>>> tasks = {};
  Map<String, TextEditingController> taskControllers = {};
  Map<String, TextEditingController> timeControllers = {};

  @override
  void initState() {
    super.initState();
    int weekday = widget.selectedDate.weekday;
    monday = widget.selectedDate.subtract(Duration(days: weekday - 1));
    sunday = monday.add(Duration(days: 6));

    weekDays = List.generate(7, (index) {
      DateTime dayDate = monday.add(Duration(days: index));
      String dayName = [
        "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
      ][index];
      tasks[dayName] = [];
      taskControllers[dayName] = TextEditingController();
      timeControllers[dayName] = TextEditingController();
      return dayName;
    });
  }

  @override
  void dispose() {
    for (var controller in taskControllers.values) controller.dispose();
    for (var controller in timeControllers.values) controller.dispose();
    super.dispose();
  }

  void addTask(String day) {
    if (taskControllers[day]!.text.isNotEmpty && timeControllers[day]!.text.isNotEmpty) {
      setState(() {
        tasks[day]!.add({
          "task": taskControllers[day]!.text,
          "time": timeControllers[day]!.text,
          "completed": false
        });
        taskControllers[day]!.clear();
        timeControllers[day]!.clear();
      });
    }
  }

  void toggleTask(String day, int index) {
    setState(() {
      tasks[day]![index]["completed"] = !tasks[day]![index]["completed"];
    });
  }

  void removeTask(String day, int index) {
    setState(() {
      tasks[day]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly To-Do List"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: weekDays.length,
          itemBuilder: (context, index) {
            String day = weekDays[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(day, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: taskControllers[day],
                          decoration: InputDecoration(
                            hintText: "Add task...",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: timeControllers[day],
                          decoration: InputDecoration(
                            hintText: "Time",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.green),
                        onPressed: () => addTask(day),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: tasks[day]!.asMap().entries.map((entry) {
                      int taskIndex = entry.key;
                      var task = entry.value;
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 3),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: task["completed"],
                            onChanged: (bool? value) {
                              toggleTask(day, taskIndex);
                            },
                          ),
                          title: Text(
                            "${task["task"]} - ${task["time"]}",
                            style: TextStyle(
                              fontSize: 14,
                              decoration: task["completed"] ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red, size: 18),
                            onPressed: () => removeTask(day, taskIndex),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
