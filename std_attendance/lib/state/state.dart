import 'package:flutter/material.dart';
import 'package:std_attendance/local_db/sql_db.dart';

class AttendanceProvider extends ChangeNotifier {
  List<Map> _teachers = [];
  List<Map> get teachers => _teachers;
  int? _selectedTeacher;
  int? get selectedTeacher => _selectedTeacher;
  List<Map> _subjects = [];
  int? _selectedSubject;
  List<Map> get subjecs => _subjects;
  int? get selectedSubject => _selectedSubject;
  List<Map> _selectedsubjectStudents = [];
  Map _selectedsubjectcurrentStudent = {};
  Map get selectedsubjectcurrentStudent => _selectedsubjectcurrentStudent;
  int _selectedsubjectCurrentStudentIndex = 0;
  SqlDb sqlDb = SqlDb();

  AttendanceProvider() {
    checkTeacher();
    //checkSubject();
    //checkStudent();
  }

  Future checkTeacher() async {
    List<Map> response1 = await sqlDb.readData("SELECT * FROM subject ");
    print(response1);
    List<Map> response2 = await sqlDb.readData("SELECT * FROM student ");
    print(response2);

    ////
    List<Map> response = await sqlDb.readData("SELECT * FROM teacher ");
    print(response);

    _teachers = response;
    await sqlDb.deleteData('DELETE FROM attendance ');
    notifyListeners();
  }

  Future checkSubject() async {
    List<Map> response = await sqlDb
        .readData("SELECT * FROM subject WHERE teacher_id = $_selectedTeacher");
    _subjects = response;
    notifyListeners();
  }

  Future checkStudent() async {
    List<Map> response = await sqlDb.readData('''
        SELECT student.id,student.fname FROM student, subject on
        student.level=subject.level AND
        student.dept=subject.dept AND
        student.college=subject.college 
        WHERE subject.id = $_selectedSubject
        ''');
    _selectedsubjectStudents = response;
    _selectedsubjectCurrentStudentIndex = 0;
    if (_selectedsubjectStudents.isNotEmpty) {
      _selectedsubjectcurrentStudent = _selectedsubjectStudents[0];
    }
    notifyListeners();
  }

  void setSelectedTeacher(dynamic teach) {
    _selectedTeacher = teach;
    notifyListeners();
  }

  void setSelectedsubject(dynamic subj) {
    _selectedSubject = subj;
    notifyListeners();
  }

  Future studentAttenddance(int isAttend, context) async {
    if (_selectedsubjectStudents.isNotEmpty) {
      int response = await sqlDb.insertData('''
                            INSERT INTO attendance (std_id , sub_id , is_attend )
                            VALUES(${_selectedsubjectcurrentStudent['id']},$_selectedSubject, $isAttend)
                            ''');
      List<Map> response1 = await sqlDb.readData("SELECT * FROM attendance ");
      print(response1);
      ++_selectedsubjectCurrentStudentIndex;

      if (_selectedsubjectCurrentStudentIndex <
          _selectedsubjectStudents.length) {
        _selectedsubjectcurrentStudent =
            _selectedsubjectStudents[_selectedsubjectCurrentStudentIndex];

        notifyListeners();
      } else {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }
}
