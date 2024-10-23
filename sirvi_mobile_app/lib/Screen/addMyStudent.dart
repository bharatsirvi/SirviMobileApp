import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sirvi_mobile_app/Screen/myStudents.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/models/myStudent.dart';
import 'package:sirvi_mobile_app/provider/gotra_provider.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';
import 'package:sirvi_mobile_app/utills/dialogBoxForMsg.dart';

class AddMyStudent extends StatefulWidget {
  @override
  AddMyStudentState createState() => AddMyStudentState();
}

class AddMyStudentState extends State<AddMyStudent> {
  bool _loadingAddStudent = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studyAtController = TextEditingController();
  final TextEditingController _studyPlaceController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _gotraController = TextEditingController();

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

  String? _selectedMedium;
  String? _selectedStudyLevel;
  String? _selectedGender;
  String? _selectedStudyType;
  String? _selectedCurrentClass;
  String? _selectedCollegeYear;
  String? _selectedGotra;

  @override
  void initState() {
    super.initState();
    intializeValue();
    _gotraOptions =
        Provider.of<GotrasProvider>(context, listen: false).gotraOptions;
  }

  void intializeValue() {
    _selectedMedium = _mediumOptions[0];
    _selectedStudyLevel = _studyLevelOptions[1];
    _selectedGender = _genderOptions[0];
    // _selectedStudyType = _studyTypeOptions[0];
    _selectedGotra = 'Solanki';
    _selectedCollegeYear = "4";
    _nameController.text = "Rahul";
    _fatherNameController.text = "Narendra";
    _dobController.text = "12/12/1999";
    _mobileController.text = "1234567890";
    // _emailController.text = "rahut@gmail.com";
    _studyPlaceController.text = "Ahmedabad";
    // _villageController.text = "Khod";
    // _studyAtController.text = "Gujarat University";
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  void _addStudent() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _loadingAddStudent = true;
      });
      await ApiService.addStudent(
              context: context,
              name: _nameController.text.trim(),
              fatherName: _fatherNameController.text.trim(),
              mobile: _mobileController.text.trim(),
              dob: _dobController.text.trim(),
              email: _emailController.text.trim(),
              studyAt: _studyAtController.text.trim(),
              village: _villageController.text.trim(),
              studyPlace: _studyPlaceController.text.trim(),
              gender: _selectedGender ?? "",
              gotra: _selectedGotra ?? "",
              medium: _selectedMedium ?? "",
              studyLevel: _selectedStudyLevel ?? "",
              currentClass: _selectedCurrentClass,
              collegeYear: _selectedCollegeYear,
              studyType: _selectedStudyType)
          .then((sucess) => {
                if (sucess)
                  {
                    setState(() {
                      _loadingAddStudent = false;
                    }),

                    // showDialogBoxForMsg(
                    //     context: context,
                    //     message: LocaleData.studentAdded.getString(context),
                    //     color: const Color.fromARGB(255, 157, 201, 158),
                    //     icon: Icons.delete),
                    Future.microtask(() {
                      showDialogBoxForMsg(
                          context: context,
                          message: LocaleData.studentAdded.getString(context),
                          color: Color.fromARGB(255, 255, 101, 139),
                          icon: Icons.person_add_alt_1_outlined);
                    }),
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Mystudents()))
                  }
              });

      setState(() {
        _loadingAddStudent = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 154, 5, 5),
          content: Text(
            "Please Fill All Required Field",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.addStudent.getString(context)),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 56, 106),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  _buildTextField(
                    _nameController,
                    LocaleData.name.getString(context),
                    errorMessage: LocaleData.nameErrMsg.getString(context),
                    isRequired: true,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(_fatherNameController,
                      LocaleData.fathersName.getString(context),
                      isRequired: true,
                      errorMessage:
                          LocaleData.fathersNameErrMsg.getString(context)),
                  SizedBox(height: 10),
                  _buildDropdownField(
                      label: LocaleData.gender.getString(context),
                      items: _genderOptions,
                      isRequired: true,
                      onChanged: (String? value) => _selectedGender = value,
                      value: _selectedGender,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleData.genderErrMsg.getString(context);
                        }
                        return null;
                      }),
                  SizedBox(height: 10),
                  _buildDropdownField(
                      label: LocaleData.gotra.getString(context),
                      items: _gotraOptions,
                      isRequired: true,
                      onChanged: (String? value) => _selectedGotra = value!,
                      value: _selectedGotra,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleData.gotraErrMsg1.getString(context);
                        }
                        return null;
                      }),
                  SizedBox(height: 10),
                  _buildTextField(
                      _dobController, LocaleData.dob.getString(context),
                      validator: _validateDate,
                      isRequired: true,
                      readOnly: true,
                      onTap: () => _selectDate(context)),
                  SizedBox(height: 10),
                  _buildTextField(
                      isRequired: true,
                      _mobileController,
                      LocaleData.mobileNo.getString(context),
                      validator: _validateMobile),
                  SizedBox(height: 10),
                  _buildTextField(
                      _emailController, LocaleData.email.getString(context),
                      validator: _validateEmail),
                  SizedBox(height: 10),
                  _buildDropdownField(
                      isRequired: true,
                      label: LocaleData.medium.getString(context),
                      items: _mediumOptions,
                      onChanged: (String? value) => _selectedMedium = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleData.mediumErrMsg.getString(context);
                        }
                        return null;
                      },
                      value: _selectedMedium),
                  SizedBox(height: 10),
                  _buildDropdownField(
                      isRequired: true,
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
                          return LocaleData.studyLevelErrMsg.getString(context);
                        }
                        return null;
                      }),
                  if (_selectedStudyLevel == "School" ||
                      _selectedStudyLevel == "College")
                    const SizedBox(height: 10),
                  if (_selectedStudyLevel == 'School')
                    _buildDropdownField(
                        isRequired: true,
                        label: LocaleData.classLabel.getString(context),
                        items: List.generate(
                            12, (index) => (index + 1).toString()),
                        value: _selectedCurrentClass,
                        onChanged: (String? value) =>
                            _selectedCurrentClass = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleData.classErrMsg.getString(context);
                          }
                        }),
                  if (_selectedStudyLevel == 'College')
                    _buildDropdownField(
                        isRequired: true,
                        label: LocaleData.collegeYear.getString(context),
                        value: _selectedCollegeYear,
                        items:
                            List.generate(5, (index) => (index + 1).toString()),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCollegeYear = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleData.collegeYearErrMsg
                                .getString(context);
                          }
                        }),
                  SizedBox(height: 10),
                  _buildTextField(_studyAtController,
                      LocaleData.schoolInstitute.getString(context)),
                  SizedBox(height: 10),
                  _buildTextField(
                      _studyPlaceController,
                      isRequired: true,
                      LocaleData.studyPlace.getString(context),
                      errorMessage:
                          LocaleData.studyPlaceErrMsg.getString(context)),
                  SizedBox(height: 10),
                  _buildDropdownField(
                    label: LocaleData.studyType.getString(context),
                    items: _studyTypeOptions,
                    value: _selectedStudyType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStudyType = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  _buildTextField(_villageController,
                      LocaleData.village.getString(context)),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
        if (_loadingAddStudent)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton.extended(
            onPressed: _addStudent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            label: Text(LocaleData.add.getString(context)),
            elevation: 5,
            icon: Icon(Icons.add_circle_outline),
            backgroundColor: Color.fromARGB(255, 255, 234, 244),
            foregroundColor: Color.fromARGB(255, 255, 56, 106),
          ),
        ),
      ]),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {String? errorMessage,
      bool isRequired = false,
      bool readOnly = false,
      void Function()? onTap,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isRequired ? '${label}*' : label,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 255, 190, 206)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF0844),
          ),
        ),
      ),
      readOnly: readOnly,
      onTap: onTap,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            return null;
          },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    bool isRequired = false,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: isRequired ? '${label}*' : label,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 255, 190, 206)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF0844),
          ),
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(LocaleData.getString(context, item)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  // Widget _buildAutocompleteField(TextEditingController controller, String label,
  //     List<String> options, String? Function(String?)? validator,
  //     [String? errorMessage]) {
  //   return Autocomplete<String>(
  //     optionsBuilder: (TextEditingValue textEditingValue) {
  //       if (textEditingValue.text.isEmpty) {
  //         return const Iterable<String>.empty();
  //       }
  //       return options.where((String option) {
  //         return option
  //             .toLowerCase()
  //             .contains(textEditingValue.text.toLowerCase());
  //       });
  //     },
  //     onSelected: (String selection) {
  //       controller.text = selection;
  //     },
  //     fieldViewBuilder: (BuildContext context,
  //         TextEditingController fieldController,
  //         FocusNode focusNode,
  //         VoidCallback onFieldSubmitted) {
  //       return TextFormField(
  //         controller: fieldController,
  //         focusNode: focusNode,
  //         decoration: InputDecoration(
  //           labelText: label,
  //           border: OutlineInputBorder(),
  //           enabledBorder: OutlineInputBorder(
  //             borderSide: BorderSide(color: Color.fromARGB(255, 255, 190, 206)),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderSide: BorderSide(
  //               color: Color(0xFFFF0844),
  //             ),
  //           ),
  //         ),
  //         validator: validator ??
  //             (value) {
  //               if (value == null || value.isEmpty) {
  //                 return errorMessage;
  //               }
  //               return null;
  //             },
  //       );
  //     },
  //   );
  // }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleData.dobErrMsg1.getString(context);
    }
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    try {
      dateFormat.parseStrict(_dobController.text);
    } catch (e) {
      return LocaleData.dobErrMsg2.getString(context);
    }
    return null;
  }

  String? _validateGotra(String? value) {
    if (_gotraController.text == '' || _gotraController.text.isEmpty) {
      return LocaleData.gotraErrMsg1.getString(context);
    }
    print('gotra ${_gotraController.text}');
    if (!_gotraOptions.contains(value) && value != '') {
      return LocaleData.gotraErrMsg2.getString(context);
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleData.mobileErrorMsg1.getString(context);
      ;
    }
    final pattern = RegExp(r'^\d{10}$');
    if (!pattern.hasMatch(value ?? '')) {
      return LocaleData.gotraErrMsg2.getString(context);
      ;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final pattern = RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$');
    if (!pattern.hasMatch(value ?? '')) {
      return LocaleData.emailErrMsg2.getString(context);
    }
    return null;
  }
}
