import 'package:flutter/material.dart';
import 'package:gmma/screens/employee/employee_assigned_jobs_screen.dart';
import 'package:gmma/screens/employee/employee_completed_jobs_screen.dart';
import 'package:gmma/screens/employee/employee_ongoing_jobs_screen.dart';

class EmployeeTabsScreen extends StatefulWidget {
  const EmployeeTabsScreen({Key? key}) : super(key: key);

  static const routeName = '/EmployeeTabsScreen';

  @override
  State<EmployeeTabsScreen> createState() => _EmployeeTabsScreenState();
}

class _EmployeeTabsScreenState extends State<EmployeeTabsScreen> {
  List<Map<String, dynamic>>? _pages;
  List<String>? _arguments;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _selectPageIndex(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<String>;
    if (args != null) {
      setState(() {
        _arguments = args;
        _pages = [
          {
            'page': EmployeeAssignedJobsScreen(
              garageEmployeeID: _arguments![0],
              employeeIDNumber: _arguments![1],
            ),
            'title': 'Assigned Jobs',
          },
          {
            'page': EmployeeOngoingJobsScreen(
              garageEmployeeID: _arguments![0],
              employeeIDNumber: _arguments![1],
            ),
            'title': 'Ongoing Jobs',
          },
          {
            'page': EmployeeCompletedJobsScreen(
              garageEmployeeID: _arguments![0],
              employeeIDNumber: _arguments![1],
            ),
            'title': 'Completed Jobs',
          },
        ];
      });
    }
    if (_arguments == null || _pages == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages![_selectedPageIndex]['title'],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _pages![_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPageIndex,
        backgroundColor: Theme.of(context).primaryColorLight,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment),
            label: 'Assigned Jobs',
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bolt),
            label: 'Ongoing Jobs',
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_turned_in),
            label: 'Completed Jobs',
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
