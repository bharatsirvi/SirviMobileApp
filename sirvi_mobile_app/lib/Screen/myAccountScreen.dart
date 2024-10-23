import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/models/userModel.dart';
import 'package:sirvi_mobile_app/provider/gotra_provider.dart';
import 'package:sirvi_mobile_app/provider/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';
import 'package:vibration/vibration.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<MyAccountPage> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _gotraController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String? _selectedGender = "Male";
  String? _selectedGotra;
  List<String> _gotraOptions = [];

  String _user_name = "";
  String? _user_gotra = "";
  bool _loadingSaveUser = false;

  bool _loadingProfileImage = false;
  // Flags to toggle editability
  bool _isNameEditable = false;
  bool _isFatherNameEditable = false;
  bool _isDobEditable = false;
  bool _isMobileEditable = false;
  bool _isEmailEditable = false;
  bool _isGotraEditable = false;
  bool _isGenderEditable = false;

  File? _imageFile;
  String? _imageUrl = "";
  Image? _mempryImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // _initializeApp();
    _loadUserData();
    _gotraOptions =
        Provider.of<GotrasProvider>(context, listen: false).gotraOptions;
  }

  void _loadUserData() {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    print('user gotra${user.gotra}');

    setState(() {
      _user_name = user.name;
      _user_gotra = user.gotra;
      _imageUrl = user.profilePic != "" ? user.profilePic! : "";

      Image mempryImage = Image.memory(base64Decode(_imageUrl!));

      _mempryImage = mempryImage;
    });

    _nameController.text = user.name;
    _fatherNameController.text = user.father_name!;
    _mobileController.text = user.mobile;
    _emailController.text = user.email!;
    _dobController.text = user.dob != ""
        ? DateFormat("dd/MM/yyyy").format(DateTime.parse(user.dob!))
        : "";
    _gotraController.text =
        user.gotra != "" ? LocaleData.getString(context, user.gotra!) : "";
    _genderController.text =
        user.gender != "" ? LocaleData.getString(context, user.gender!) : "";

    _selectedGotra = user.gotra ?? "";
    _selectedGender = user.gender ?? "";
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        _dobController.text = formattedDate;
        print("_dobcontrooler $formattedDate");
      });
    }
  }

  void _saveChanges() async {
    setState(() {
      _isNameEditable = false;
      _isFatherNameEditable = false;
      _isDobEditable = false;
      _isMobileEditable = false;
      _isEmailEditable = false;
      _isGotraEditable = false;
      _isGenderEditable = false;
      _loadingSaveUser = true;
    });
    if (_validateInputs()) {
      print("gotra=======>>${_gotraController.text}");
      await ApiService.saveUser(
        context: context,
        name: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        dob: _dobController.text.trim(),
        father_name: _fatherNameController.text.trim(),
        email: _emailController.text.trim(),
        gotra: _selectedGotra ?? "",
        gender: _selectedGender ?? "",
        proflieImage: _imageFile,
      );

      _loadUserData();
      setState(() {
        _loadingSaveUser = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Changes saved successfully')
      //   ),
      // );
    } else {
      setState(() {
        _loadingSaveUser = false;
      });
    }
  }

  bool _validateInputs() {
    if (!_validateGotra()) return false;
    if (!_validateMobile()) return false;
    if (!_validateEmail()) return false;
    if (!_validateDate()) return false;
    return true;
  }

  bool _validateGotra() {
    if (!_gotraOptions.contains(_selectedGotra)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.gotraErrMsg2.getString(context))),
      );
      return false;
    }
    return true;
  }

  bool _validateMobile() {
    final String mobilePattern = r'^[0-9]{10}$';
    final RegExp mobileRegExp = RegExp(mobilePattern);

    if (_mobileController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.mobileErrorMsg1.getString(context))),
      );
      return false;
    }

    if (!mobileRegExp.hasMatch(_mobileController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.mobileErrorMsg2.getString(context))),
      );
      return false;
    }
    return true;
  }

  bool _validateEmail() {
    final String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final RegExp emailRegExp = RegExp(emailPattern);
    if (_emailController.text.isEmpty) {
      return true;
    }
    if (!emailRegExp.hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.emailErrMsg2.getString(context))),
      );
      return false;
    }
    return true;
  }

  bool _validateDate() {
    if (_dobController.text.isEmpty) {
      return true;
    }
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    try {
      dateFormat.parseStrict(_dobController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.dobErrMsg2.getString(context))),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _nameController.dispose();
    _fatherNameController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _gotraController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _vibrate() async {
    Vibration.vibrate(duration: 100, amplitude: 128);
  }

  Future<bool> _onWillPop(bool canPop) async {
    if (_isNameEditable ||
        _isFatherNameEditable ||
        _isDobEditable ||
        _isMobileEditable ||
        _isEmailEditable ||
        _isGotraEditable ||
        _isGenderEditable) {
      _vibrate();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(LocaleData.discardChangesTitle.getString(context)),
            content: Text(LocaleData.discardChangesMessage.getString(context)),
            actions: [
              TextButton(
                onPressed: () {
                  canPop = true;
                  Navigator.of(context).pop();
                },
                child: Text(LocaleData.no.getString(context)),
              ),
              TextButton(
                onPressed: () {
                  canPop = true;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(_mempryImage);
                },
                child: Text(LocaleData.yes.getString(context)),
              ),
            ],
          );
        },
      );
      return false;
    }

    canPop = true;
    Navigator.of(context).pop(_mempryImage);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("image url contet $_imageUrl");
    // Example initial value for Date of Birth

    return PopScope(
      onPopInvoked: _onWillPop,
      canPop: false,
      key: Key('my_account_page'),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleData.myAccount.getString(context)),
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 56, 106),
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        _loadingProfileImage
                            ? Container(
                                width: 100,
                                height: 100,
                                color: const Color.fromARGB(77, 250, 12, 12),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                backgroundImage: _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : _imageUrl != ""
                                        ? _mempryImage!.image
                                        : const AssetImage(
                                            'assets/images/avatar_placeholder.png'),
                              ),
                        Positioned(
                          bottom: -1,
                          right: -1,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                                icon: const Icon(Icons.add_a_photo_rounded,
                                    color: Color(0xFFFF0844)),
                                onPressed: _pickImage),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      child: Text(
                    _user_name.toUpperCase() ?? "Bharat Kumar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  SizedBox(height: 20),
                  _buildEditableTextField(
                    isRequired: true,
                    controller: _nameController,
                    label: LocaleData.name.getString(context),
                    isEditable: _isNameEditable,
                    onEditPressed: () {
                      setState(() {
                        _isNameEditable = !_isNameEditable;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  _buildEditableTextField(
                    controller: _fatherNameController,
                    label: LocaleData.fathersName.getString(context),
                    isEditable: _isFatherNameEditable,
                    onEditPressed: () {
                      setState(() {
                        _isFatherNameEditable = !_isFatherNameEditable;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      DropdownMenu(
                        controller: _gotraController,
                        enableSearch: true,
                        width: 352,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFF0844)),
                          ),
                        ),
                        enableFilter: true,
                        leadingIcon: Icon(Icons.arrow_drop_down),
                        trailingIcon: Icon(
                          Icons.arrow_drop_down,
                          size: 0,
                        ),
                        selectedTrailingIcon: Icon(
                          Icons.arrow_drop_down,
                          size: 0,
                        ),
                        focusNode: FocusNode(canRequestFocus: true),
                        menuHeight: 200,
                        textStyle: _isGotraEditable
                            ? TextStyle(color: Colors.black)
                            : TextStyle(color: Colors.grey),
                        label: Text("${LocaleData.gotra.getString(context)}*"),
                        dropdownMenuEntries: _gotraOptions
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
                        enabled: _isGotraEditable,
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            _isGotraEditable ? Icons.check : Icons.edit,
                            color: Color(0xFFFF0844),
                          ),
                          onPressed: () {
                            setState(() {
                              _isGotraEditable = !_isGotraEditable;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      DropdownMenu(
                        controller: _genderController,
                        width: 352,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFF0844)),
                          ),
                        ),
                        leadingIcon: Icon(Icons.arrow_drop_down),
                        trailingIcon: Icon(
                          Icons.arrow_drop_down,
                          size: 0,
                        ),
                        selectedTrailingIcon: Icon(
                          Icons.arrow_drop_down,
                          size: 0,
                        ),
                        menuHeight: 200,
                        textStyle: _isGenderEditable
                            ? TextStyle(color: Colors.black)
                            : TextStyle(color: Colors.grey),
                        label: Text(LocaleData.gender.getString(context)),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                              label: LocaleData.male.getString(context),
                              value: "Male"),
                          DropdownMenuEntry(
                              label: LocaleData.female.getString(context),
                              value: "Female")
                        ],
                        onSelected: (value) {
                          setState(() {
                            _selectedGender = value.toString();
                          });
                        },
                        enabled: _isGenderEditable,
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            _isGenderEditable ? Icons.check : Icons.edit,
                            color: Color(0xFFFF0844),
                          ),
                          onPressed: () {
                            setState(() {
                              _isGenderEditable = !_isGenderEditable;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildEditableTextField(
                    isRequired: true,
                    controller: _mobileController,
                    label: LocaleData.mobileNo.getString(context),
                    isEditable: _isMobileEditable,
                    onEditPressed: () {
                      setState(() {
                        _isMobileEditable = !_isMobileEditable;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  _buildEditableTextField(
                    controller: _emailController,
                    label: LocaleData.email.getString(context),
                    isEditable: _isEmailEditable,
                    onEditPressed: () {
                      setState(() {
                        _isEmailEditable = !_isEmailEditable;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildEditableTextField(
                    controller: _dobController,
                    label: LocaleData.dob.getString(context),
                    isEditable: _isDobEditable,
                    onEditPressed: () {
                      setState(() {
                        _isDobEditable = !_isDobEditable;
                        if (_isDobEditable) {
                          _selectDate(context);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: Text(LocaleData.saveChanges.getString(context)),
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                        backgroundColor: Color(0xFFFF0844),
                        foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          if (_loadingSaveUser)
            Container(
              color: Colors.white30,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    required bool isEditable,
    required VoidCallback onEditPressed,
  }) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: isRequired ? "${label}*" : label,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFF0844)),
              ),
            ),
            enabled: isEditable,
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: Icon(
              isEditable ? Icons.check : Icons.edit,
              color: Color(0xFFFF0844),
            ),
            onPressed: onEditPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
      {required String label,
      required List<String> items,
      required String? value,
      required void Function(String?) onChanged,
      String? Function(String?)? validator}) {
    return Container(
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: Colors.white,
        iconSize: 0,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.arrow_drop_down),
          labelText: LocaleData.gender.getString(context),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF0844)),
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            alignment: Alignment.centerLeft,
            value: item,
            child: SizedBox(
              width: 100,
              child: Text(
                LocaleData.getString(context, item),
                style: TextStyle(fontSize: 14),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildNormalDropDownField({
    required String hintText,
    required List<String> items,
    required String? value,
    required void Function(String?) onSelected,
    required bool enabled,
  }) {
    return DropdownMenu(
      dropdownMenuEntries: items
          .map((option) => DropdownMenuEntry(
                label: LocaleData.getString(context, option),
                value: option,
              ))
          .toList(),
      onSelected: onSelected,
      hintText: hintText,
      enabled: enabled,
    );
  }
}
