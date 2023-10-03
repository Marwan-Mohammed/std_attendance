import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:std_attendance/local_db/sql_db.dart';
import 'package:std_attendance/screens/student_attendance.dart';
import 'package:std_attendance/state/state.dart';
import 'package:std_attendance/utils/utils.dart';

class SelectSubject extends StatelessWidget {
  static const String screenRoute = '/select-subject';
  SqlDb sqlDb = SqlDb();

  SelectSubject({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AttendanceProvider>().checkSubject();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Subject'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, child) {
            return DropdownButton(
              hint: const Text("Select subject"),
              items: attendanceProvider.subjecs
                  .map((e) => DropdownMenuItem(
                        value: e['id'],
                        child: Text(e['name']),
                      ))
                  .toList(),
              onChanged: (value) async {
                attendanceProvider.setSelectedsubject(value);
              },
              value: attendanceProvider.selectedSubject,
            );
          }),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: () {
              if (context.read<AttendanceProvider>().selectedSubject == null) {
                showSnackBar(context, 'Please, select subject');
              } else {
                Navigator.pushNamed(context, StudentAttendance.screenRoute);
              }
            },
            textColor: Colors.white,
            color: Colors.blue,
            child: const Text('Next'),
          ),
        ],
      )),
    );
  }
}
