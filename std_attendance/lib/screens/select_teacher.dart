import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:std_attendance/local_db/sql_db.dart';
import 'package:std_attendance/screens/select_subject.dart';
import 'package:std_attendance/state/state.dart';
import 'package:std_attendance/utils/utils.dart';

class SelectTeacher extends StatelessWidget {
  static const String screenRoute = '/select-teacher';
  SqlDb sqlDb = SqlDb();

  SelectTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController pass = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select teacher'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, child) {
            return DropdownButton(
              hint: const Text("Select teacher"),
              items: attendanceProvider.teachers
                  .map((e) => DropdownMenuItem(
                        value: e['id'],
                        child: Text(e['fname']),
                      ))
                  .toList(),
              onChanged: (value) async {
                attendanceProvider.setSelectedTeacher(value);
              },
              value: attendanceProvider.selectedTeacher,
            );
          }),
          const SizedBox(height: 10),
          TextFormField(
            textAlign: TextAlign.center,
            //readOnly: true,
            controller: pass,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: () async {
              if (context.read<AttendanceProvider>().selectedTeacher == null) {
                showSnackBar(context, 'Please, select teacher');
              } else if (pass.text == '') {
                showSnackBar(context, 'Please, enter password');
              } else {
                List<Map> response = await sqlDb.readData(
                    "SELECT * FROM teacher WHERE id = ${context.read<AttendanceProvider>().selectedTeacher} and pass = '${pass.text}'");

                if (response.isNotEmpty) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectSubject(),
                      ),
                      (route) => false);
                } else {
                  showSnackBar(context, 'Please, enter valid password');
                }
              }
            },
            textColor: Colors.white,
            color: Colors.blue,
            child: const Text('Next'),
          ),
          /*IconButton(
              onPressed: () async {
                await sqlDb.deleteDb();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),*/
        ],
      )),
    );
  }
}
