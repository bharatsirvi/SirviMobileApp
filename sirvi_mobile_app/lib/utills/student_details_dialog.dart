import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sirvi_mobile_app/Screen/viewMyStudents.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/models/myStudent.dart';
import 'package:sirvi_mobile_app/provider/gotra_provider.dart';
import 'package:sirvi_mobile_app/provider/my_students_provider.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';
import 'package:sirvi_mobile_app/utills/deleteConfirmationBox.dart';
import 'package:sirvi_mobile_app/utills/dialogBoxForMsg.dart';

class StudentDetailDialog extends StatefulWidget {
  MyStudent student;
  final bool isEditing;

  StudentDetailDialog({required this.student, this.isEditing = false})
      : super() {}

  @override
  _StudentDetailDialogState createState() => _StudentDetailDialogState();
}

class _StudentDetailDialogState extends State<StudentDetailDialog> {
  bool _loadingUpdateStudent = false;
  bool _loadingDeleteStudent = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _gotraController;
  late TextEditingController _dobController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _studyAtController;
  late TextEditingController _studyPlaceController;
  late TextEditingController _villageController;

  String? _selectedGender;
  String? _selectedMedium;
  String? _selectedStudyLevel;
  String? _selectedCurrentClass;
  String? _selectedCollegeYear;
  String? _selectedStudyType;
  String _selectedGotra = "";
  late bool _isEditing;
  List<String> _gotraOptions = [];
  List<String> _mediumOptions = [
    "Hindi",
    "English",
    "Gujarati",
    "Marathi",
    "Other"
  ];
  List<String> _studyLevelOptions = ["School", "College", "Higher"];
  List<String> _genderOptions = ["Male", "Female"];
  List<String> _studyTypeOptions = ["Coaching", "Self Study"];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;
    _gotraOptions =
        Provider.of<GotrasProvider>(context, listen: false).gotraOptions;

    _loadMyStudentsData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _gotraController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _studyAtController.dispose();
    _studyPlaceController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }
    return null;
  }

  String? _validateGotra(String? value) {
    if (_selectedGotra == null || _selectedGotra.isEmpty) {
      return 'Gotra is required';
    }

    if (_selectedGotra != '' && !_gotraOptions.contains(_selectedGotra)) {
      return 'Select a valid Gotra';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile Number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter 10-digit mobile number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {String? errorMessage,
      String? Function(String?)? validator,
      bool readOnly = false,
      void Function()? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.always,
      onTap: onTap,

      showCursor: true,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 10,
          height: 0.1,
        ),
        constraints: BoxConstraints(maxHeight: 43.0, minHeight: 43.0),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.4),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.4),
        ),
      ),
      style: TextStyle(fontSize: 14.0), // Smaller input text
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            return null;
          },
    );
  }

  Widget _buildAutocompleteDropdownField(
      TextEditingController controller, List<String> options) {
    return Container(
      child: DropdownMenu(
        errorText: _validateGotra(_selectedGotra),
        controller: _gotraController,
        expandedInsets: EdgeInsets.symmetric(
          horizontal: 0,
        ),
        enableFilter: true,
        enableSearch: true,
        trailingIcon: Icon(Icons.arrow_drop_down, color: Colors.transparent),
        selectedTrailingIcon:
            Icon(Icons.arrow_drop_down, color: Colors.transparent),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 14, color: Colors.black87),
          errorStyle: TextStyle(
            fontSize: 10,
            height: 0.1,
          ),
          constraints: BoxConstraints(),
          // isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.4),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 0.4),
          ),
        ),
        focusNode: FocusNode(
          canRequestFocus: true,
        ),
        textStyle: TextStyle(fontSize: 14.0),
        menuHeight: 200,
        dropdownMenuEntries: options
            .map((option) => DropdownMenuEntry(
                  label: LocaleData.getString(context, option),
                  value: option,
                ))
            .toList(),
        onSelected: (value) {
          setState(() {
            _selectedGotra = value.toString();
          });
        },
      ),
    );
  }

  Widget _buildAutocompleteField(TextEditingController controller, String label,
      List<String> options, String? Function(String?)? validator,
      [String? errorMessage]) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
        _selectedGotra = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: widget.student.gotra != ""
                ? widget.student.gotra
                : LocaleData.gotra.getString(context),
            hintStyle: TextStyle(fontSize: 14, color: Colors.black87),
            errorStyle: TextStyle(
              fontSize: 10,
              height: 0.1,
            ),
            constraints: BoxConstraints(maxHeight: 30.0, minHeight: 43.0),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.4),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 0.4),
            ),
          ),
          style: TextStyle(fontSize: 14.0),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return errorMessage;
                }
                return null;
              },
        );
      },
    );
  }

  Widget _buildDropdownField(
      {required String label,
      required List<String> items,
      required String? value,
      required void Function(String?) onChanged,
      String? Function(String?)? validator}) {
    return DropdownButtonFormField<String>(
      value: value,
      autovalidateMode: AutovalidateMode.always,
      focusNode: FocusNode(
        canRequestFocus: true,
      ),
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 10,
          height: 0.1,
        ),
        constraints: BoxConstraints(maxHeight: 43.0, minHeight: 43.0),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.4),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.4),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            LocaleData.getString(context, item),
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Dialog(
        elevation: 100,
        backgroundColor: Color.fromARGB(255, 255, 245, 249),
        insetPadding: EdgeInsets.all(30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 10, top: 15, left: 24, right: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Center(
                      child: Text(
                        LocaleData.studentDetails.getString(context),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      right: -15,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                _buildDetailView(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _isEditing
                        ? TextButton.icon(
                            label: Text(
                              LocaleData.save.getString(context),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 56, 106)),
                            ),
                            icon: Icon(
                              Icons.save,
                              color: Color.fromARGB(255, 255, 56, 106),
                            ),
                            onPressed: _saveStudentDetails)
                        : TextButton.icon(
                            label: Text(
                              LocaleData.edit.getString(context),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 56, 106)),
                            ),
                            icon: Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 255, 56, 106),
                            ),
                            onPressed: _toggleEdit,
                          ),
                    _isEditing
                        ? TextButton.icon(
                            label: Text(LocaleData.cancel.getString(context),
                                style: TextStyle(color: Colors.red[900])),
                            icon: Icon(Icons.cancel, color: Colors.red[900]),
                            onPressed: () {
                              _loadMyStudentsData();
                              Navigator.pop(context);
                            },
                          )
                        : TextButton.icon(
                            label: Text(LocaleData.delete.getString(context),
                                style: TextStyle(color: Colors.red[900])),
                            icon: Icon(Icons.delete_forever,
                                color: Colors.red[900]),
                            onPressed: () async {
                              bool? result = await showDeleteConfirmationDialog(
                                  context, widget.student.name);
                              if (result!) {
                                deleteMyStudent(context, widget.student);
                              }
                            },
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      if (_loadingUpdateStudent || _loadingDeleteStudent)
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ]);
  }

  Widget _buildDetailRow(String label, Widget valueWidget) {
    return Padding(
      padding: _isEditing
          ? EdgeInsets.all(0)
          : const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _isEditing
              ? Flexible(child: valueWidget)
              : Expanded(flex: 1, child: valueWidget),
        ],
      ),
    );
  }

  Widget _buildDetailView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            LocaleData.name.getString(context),
            _isEditing
                ? _buildTextField(
                    _nameController, LocaleData.name.getString(context),
                    errorMessage: 'Name is required')
                : Text(widget.student.name),
          ),
          _buildDetailRow(
              LocaleData.fathersName.getString(context),
              _isEditing
                  ? _buildTextField(_fatherNameController,
                      LocaleData.fathersName.getString(context),
                      errorMessage: "Father's Name is required")
                  : Text(widget.student.fatherName)),
          _buildDetailRow(
              LocaleData.gotra.getString(context),
              _isEditing
                  ? Expanded(
                      child: _buildDropdownField(
                        label: LocaleData.gotra.getString(context),
                        items: _gotraOptions,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGotra = value!;
                          });
                        },
                        value: _selectedGotra,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Gotra is required';
                          }
                          return null;
                        },
                      ),
                    )
                  : Text(LocaleData.getString(
                      context, '${widget.student.gotra}'))),
          _buildDetailRow(
              LocaleData.gender.getString(context),
              _isEditing
                  ? _buildDropdownField(
                      label: LocaleData.gender.getString(context),
                      items: _genderOptions,
                      onChanged: (String? value) => _selectedGender = value,
                      value: _selectedGender,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Gender is required';
                        }
                        return null;
                      })
                  : Text(LocaleData.getString(context, widget.student.gender))),
          _buildDetailRow(
              LocaleData.medium.getString(context),
              _isEditing
                  ? _buildDropdownField(
                      label: LocaleData.medium.getString(context),
                      items: _mediumOptions,
                      onChanged: (String? value) => _selectedMedium = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Medium is required';
                        }
                        return null;
                      },
                      value: _selectedMedium)
                  : Text(LocaleData.getString(context, widget.student.medium))),
          _buildDetailRow(
              LocaleData.dob.getString(context),
              _isEditing
                  ? _buildTextField(
                      _dobController, LocaleData.dob.getString(context),
                      validator: _validateDate,
                      readOnly: true,
                      onTap: () => _selectDate(context))
                  : Text(widget.student.dob != ""
                      ? DateFormat("dd/MM/yyyy")
                          .format(DateTime.parse(widget.student.dob))
                      : "")),
          _buildDetailRow(
              LocaleData.schoolInstitute.getString(context),
              _isEditing
                  ? _buildTextField(
                      _studyAtController,
                      LocaleData.schoolInstitute.getString(context),
                    )
                  : Text(widget.student.studyAt)),
          _buildDetailRow(
              LocaleData.studyPlace.getString(context),
              _isEditing
                  ? _buildTextField(_studyPlaceController,
                      LocaleData.studyPlace.getString(context),
                      errorMessage: 'Study Place is required')
                  : Text(widget.student.studyPlace)),
          _buildDetailRow(
              LocaleData.studyLevel.getString(context),
              _isEditing
                  ? _buildDropdownField(
                      label: LocaleData.studyLevel.getString(context),
                      items: _studyLevelOptions,
                      value: _selectedStudyLevel,
                      onChanged: (String? value) {
                        print("vlae $value");
                        setState(() {
                          _selectedStudyLevel = value;
                          _selectedCollegeYear = null;
                          _selectedCurrentClass = null;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Study Level is required';
                        }
                        return null;
                      })
                  : Text(LocaleData.getString(
                      context, '${widget.student.studyLevel}'))),
          _selectedStudyLevel == "School"
              ? _buildDetailRow(
                  LocaleData.classLabel.getString(context),
                  _isEditing
                      ? _buildDropdownField(
                          label: LocaleData.classLabel.getString(context),
                          items: List.generate(
                              12, (index) => (index + 1).toString()),
                          value: _selectedCurrentClass,
                          onChanged: (String? value) =>
                              _selectedCurrentClass = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Class is required';
                            }
                          })
                      : Text(LocaleData.getString(
                          context, widget.student.currentClass!)))
              : SizedBox(),
          _selectedStudyLevel == "College"
              ? _buildDetailRow(
                  LocaleData.collegeYear.getString(context),
                  _isEditing
                      ? _buildDropdownField(
                          label: LocaleData.collegeYear.getString(context),
                          value: _selectedCollegeYear,
                          items: List.generate(
                              5, (index) => (index + 1).toString()),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedCollegeYear = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'College Year is required';
                            }
                          })
                      : Text(LocaleData.getString(
                          context, widget.student.collegeYear!)))
              : SizedBox(),
          _buildDetailRow(
              LocaleData.studyType.getString(context),
              _isEditing
                  ? _buildDropdownField(
                      label: LocaleData.studyType.getString(context),
                      items: _studyTypeOptions,
                      value: _selectedStudyType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStudyType = newValue;
                        });
                      },
                    )
                  : Text(LocaleData.getString(
                      context, widget.student.studyType!))),
          _buildDetailRow(
              LocaleData.village.getString(context),
              _isEditing
                  ? _buildTextField(
                      _villageController, LocaleData.village.getString(context))
                  : Text(widget.student.village)),
          _buildDetailRow(
              LocaleData.email.getString(context),
              _isEditing
                  ? _buildTextField(
                      _emailController, LocaleData.email.getString(context),
                      validator: _validateEmail)
                  : Text(widget.student.email)),
          _buildDetailRow(
              LocaleData.mobileNo.getString(context),
              _isEditing
                  ? _buildTextField(
                      _mobileController, LocaleData.mobileNo.getString(context),
                      validator: _validateMobile)
                  : Text(widget.student.mobile)),
        ],
      ),
    );
  }

  void _toggleEdit() {
    _loadMyStudentsData();
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveStudentDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loadingUpdateStudent = true;
      });
      final updatedStudent = widget.student.copyWith(
        name: _nameController.text,
        fatherName: _fatherNameController.text,
        dob: _dobController.text,
        mobile: _mobileController.text,
        email: _emailController.text,
        studyAt: _studyAtController.text,
        studyPlace: _studyPlaceController.text,
        village: _villageController.text,
        gotra: _selectedGotra,
        gender: _selectedGender,
        medium: _selectedMedium,
        studyLevel: _selectedStudyLevel,
        currentClass: _selectedCurrentClass,
        collegeYear: _selectedCollegeYear,
        studyType: _selectedStudyType,
      );
      print("updated Data -----> ${updatedStudent.toJson()}");
      await ApiService.updateStudent(
              context: context, updatedStundent: updatedStudent)
          .then((sucess) => {
                if (sucess)
                  {
                    setState(() {
                      String newDate =
                          "${DateFormat('dd/MM/yyyy').parse(updatedStudent.dob).toIso8601String()}Z";
                      updatedStudent.dob = newDate;
                      widget.student = updatedStudent;
                      _loadingUpdateStudent = false;
                    }),
                    showDialogBoxForMsg(
                        context: context,
                        message: LocaleData.studentUpdated.getString(context),
                        color: const Color.fromARGB(255, 157, 201, 158),
                        icon: Icons.check_circle),
                    _toggleEdit()
                  }
              });
      setState(() {
        _loadingUpdateStudent = false;
      });
    }
  }

  void _loadMyStudentsData() {
    _nameController = TextEditingController(text: widget.student.name);
    _fatherNameController =
        TextEditingController(text: widget.student.fatherName);
    _gotraController = TextEditingController(
        text: '${LocaleData.getString(context, '${widget.student.gotra}')}');

    _dobController = TextEditingController(
        text: widget.student.dob != ""
            ? DateFormat("dd/MM/yyyy")
                .format(DateTime.parse(widget.student.dob))
            : "");
    _mobileController = TextEditingController(text: widget.student.mobile);
    _emailController = TextEditingController(text: widget.student.email);
    _studyAtController = TextEditingController(text: widget.student.studyAt);
    _studyPlaceController =
        TextEditingController(text: widget.student.studyPlace);
    _villageController = TextEditingController(text: widget.student.village);

    _selectedGotra = widget.student.gotra;
    _selectedGender = widget.student.gender;
    _selectedMedium = widget.student.medium;
    _selectedStudyLevel = widget.student.studyLevel;
    _selectedCurrentClass = widget.student.currentClass;
    _selectedCollegeYear = widget.student.collegeYear;
    _selectedStudyType = widget.student.studyType;
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
      required IconData icon}) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        Timer(Duration(milliseconds: 1000), () {
          Navigator.of(context).pop(); // Use the dialog context
        });
        return DialogBoxForMessege(message: message, color: color, icon: icon);
      },
    );
    // Timer(Duration(milliseconds: 1500), () {
    //   Navigator.of(context).pop();
    // });
  }

  void deleteMyStudent(BuildContext context, MyStudent student) async {
    setState(() {
      _loadingDeleteStudent = true;
    });
    bool result = false;
    await ApiService.deleteStudent(context: context, student: student)
        .then((sucess) => {
              if (sucess)
                {
                  setState(() {
                    _loadingDeleteStudent = false;
                  }),
                  Navigator.pop(context),
                  // Future.microtask(() {
                  //   showDialogBoxForMsg(
                  //       context: context,
                  
                  //       message: LocaleData.studentDeleted.getString(context),
                  //       color: Color.fromARGB(255, 255, 56, 106),
                  //       icon: Icons.delete);
                  // }),
                }
            });
    setState(() {
      _loadingDeleteStudent = false;
    });
  }
}
