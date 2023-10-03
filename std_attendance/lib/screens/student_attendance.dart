import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:std_attendance/state/state.dart';

class StudentAttendance extends StatelessWidget {
  static const String screenRoute = '/student-attendance';

  const StudentAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController studentName = TextEditingController();
    context.read<AttendanceProvider>().checkStudent();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Attendance'),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, child) {
            if (attendanceProvider.selectedsubjectcurrentStudent.isNotEmpty) {
              studentName.text =
                  attendanceProvider.selectedsubjectcurrentStudent['fname'];
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  textAlign: TextAlign.center,
                  //readOnly: true,
                  controller: studentName,
                  decoration: const InputDecoration(
                      //hintText: "Salon name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () async {
                          await attendanceProvider.studentAttenddance(
                              1, context);
                        },
                        style: IconButton.styleFrom(),
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: () async {
                          await attendanceProvider.studentAttenddance(
                              0, context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        )),
                  ],
                )
              ],
            );
          })),
    );
  }
}
