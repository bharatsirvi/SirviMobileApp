import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:sirvi_mobile_app/Screen/addMyStudent.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/models/myStudent.dart';
import 'package:sirvi_mobile_app/provider/my_students_provider.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';
import 'package:sirvi_mobile_app/utills/deleteConfirmationBox.dart';
import 'package:sirvi_mobile_app/utills/dialogBoxForMsg.dart';
import 'package:sirvi_mobile_app/utills/student_details_dialog.dart';

class ViewMyStudent extends StatefulWidget {
  const ViewMyStudent({super.key});

  @override
  State<ViewMyStudent> createState() => _ViewMyStudentState();

  static void showStudentDetailDialog(BuildContext context, MyStudent student,
      {bool isEditing = false}) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Student Details",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: StudentDetailDialog(student: student, isEditing: isEditing),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}

class _ViewMyStudentState extends State<ViewMyStudent> {
  bool _loadingDeleteStudent = false;
  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<MyStudentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.studentDetails.getString(context)),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 56, 106),
      ),
      body: Stack(children: [
        if (studentProvider.students.isEmpty) ...[
          Center(
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_off,
                      size: 100,
                      color: Color.fromARGB(255, 255, 151, 177),
                    ),
                    SizedBox(height: 10),
                    Text(
                      LocaleData.noStudentsAddedYet.getString(context),
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMyStudent()));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 255, 56, 106),
                      ),
                      child: Text(LocaleData.addStudent.getString(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ] else ...[
          ListView.builder(
            itemCount: studentProvider.students.length,
            itemBuilder: (context, index) {
              final student = studentProvider.students[index];
              return Dismissible(
                key: Key(student.id),
                direction: DismissDirection.startToEnd,
                behavior: HitTestBehavior.translucent,
                confirmDismiss: (direction) async {
                  bool? result =
                      await showDeleteConfirmationDialog(context, student.name);
                  if (result == null) {
                    return false;
                  }
                  if (result) {
                    deleteMyStudent(context, student);
                  }
                  return result;
                },
                background: Container(
                  color: Colors.transparent,
                ),
                child: Card(
                  elevation: 3,
                  shadowColor: Color.fromARGB(255, 234, 181, 194),
                  margin:
                      EdgeInsets.only(top: 15, bottom: 25, left: 25, right: 25),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    leading: Text(
                      "${index + 1}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ), // First letter of student name
                    title: Text(
                      '${student.name} s/o ${student.fatherName}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                            '${LocaleData.gotra.getString(context)}: ${LocaleData.getString(context, student.gotra)}'),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                            "${LocaleData.studyLevel.getString(context)}: ${LocaleData.getString(context, student.studyLevel)}"),
                        const SizedBox(
                          height: 3,
                        ),
                        student.currentClass != ""
                            ? Text(
                                "${LocaleData.classLabel.getString(context)}: ${student.currentClass}")
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                        student.collegeYear != ""
                            ? Text(
                                "${LocaleData.collegeYear.getString(context)}: ${student.collegeYear}")
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                      ],
                    ),
                    onTap: () {
                      ViewMyStudent.showStudentDetailDialog(context, student);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Color.fromARGB(255, 255, 56, 106),
                          onPressed: () {
                            ViewMyStudent.showStudentDetailDialog(
                                context, student,
                                isEditing: true);
                            // Implement update student logic
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Colors.red[900],
                          onPressed: () async {
                            bool? result = await showDeleteConfirmationDialog(
                                context, student.name);
                            if (result!) {
                              deleteMyStudent(context, student);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
        if (_loadingDeleteStudent)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ]),
    );
  }

  Future<bool?> showDeleteConfirmationDialog(
      BuildContext context, String item) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(item: item);
      },
    );
  }

  void showDialogBoxForMsg(
      {required BuildContext context,
      required String message,
      required Color color,
      required IconData icon}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        Timer(Duration(milliseconds: 1000), () {
          Navigator.of(context).pop(true);
        });
        return DialogBoxForMessege(message: message, color: color, icon: icon);
      },
    );
  }

  void deleteMyStudent(BuildContext context, MyStudent student) async {
    setState(() {
      _loadingDeleteStudent = true;
    });
    await ApiService.deleteStudent(context: context, student: student)
        .then((sucess) => {
              if (sucess)
                {
                  setState(() {
                    _loadingDeleteStudent = false;
                  }),
                  // showDialogBoxForMsg(
                  //     context: context,
                  //     message: LocaleData.studentDeleted.getString(context),
                  //     color: Color.fromARGB(255, 255, 56, 106),
                  //     icon: Icons.delete),
                }
            });
    setState(() {
      _loadingDeleteStudent = false;
    });
  }
}
