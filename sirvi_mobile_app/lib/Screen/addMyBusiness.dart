import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sirvi_mobile_app/Screen/myBusiness.dart';
import 'package:sirvi_mobile_app/localization/locales.dart';
import 'package:sirvi_mobile_app/services/api_services.dart';

class AddMyBusiness extends StatefulWidget {
  const AddMyBusiness({super.key});

  @override
  AddMyBusinessState createState() => AddMyBusinessState();
}

class AddMyBusinessState extends State<AddMyBusiness> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _ownersControllers = [
    TextEditingController()
  ];
  File? _imageFile;
  String? _selectedCategory;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = 'AAI MATADI ENTERPRISES';
    _locationController.text = 'Kolkata';
    _mobileController.text = '9876543210';
    _ownersControllers[0].text = 'Amit Kumar';
    _ownersControllers[1].text = 'Rahul Kumar';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _ownersControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addOwnerField() {
    if (_ownersControllers.length == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 3 owners allowed only')));
      return;
    }
    setState(() {
      _ownersControllers.add(TextEditingController());
    });
  }

  void _removeOwnerField(int index) {
    setState(() {
      _ownersControllers.removeAt(index);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _addNewBusiness() async {
    if (_formKey.currentState?.validate() ?? false) {
      print(
          "name => ${_nameController.text} , mobile => ${_mobileController.text}, email{} ");
      await ApiService.addBusiness(
              context: context,
              name: _nameController.text.trim(),
              mobile: _mobileController.text.trim(),
              email: _emailController.text.trim(),
              location: _locationController.text.trim(),
              category: _selectedCategory!,
              owners: _ownersControllers
                  .map((controller) => controller.text.trim())
                  .toList(),
              businessImage: _imageFile!)
          .then((sucess) => {
                if (sucess)
                  {
                    // Future.microtask(() {
                    //   showDialogBoxForMsg(
                    //       context: context,
                    //       message: LocaleData.studentAdded.getString(context),
                    //       color: Color.fromARGB(255, 255, 101, 139),
                    //       icon: Icons.person_add_alt_1_outlined);
                    // }),
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyBusiness()))
                  }
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Business'),
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 56, 106),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildTextField(_nameController, 'Business Name',
                      isRequired: true,
                      errorMessage: 'Business name is required'),
                  const SizedBox(height: 10),
                  _buildTextField(_locationController, 'Business Location',
                      isRequired: true,
                      errorMessage: 'Business Location is required'),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category*',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 190, 206)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF0844),
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Medical', child: Text('Medical')),
                      DropdownMenuItem(value: 'Shop', child: Text('Shop')),
                      DropdownMenuItem(
                          value: 'Service', child: Text('Service')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Category is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ..._ownersControllers.asMap().entries.map((entry) {
                          int index = entry.key;
                          TextEditingController controller = entry.value;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                        labelText: 'Owner Name ${index + 1}*',
                                        border: const OutlineInputBorder(),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 190, 206)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFFF0844),
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Owner Name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (_ownersControllers.length > 1)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _removeOwnerField(index),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }).toList(),
                        TextButton.icon(
                          onPressed: _addOwnerField,
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.green[500],
                          ),
                          label: Text(
                            'Add Owner',
                            style: TextStyle(color: Colors.green[500]),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 10),
                  _buildTextField(
                    _mobileController,
                    'Mobile No.',
                    isRequired: true,
                    validator: _validateMobile,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    _emailController,
                    'Email',
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 255, 190, 206)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              color: const Color.fromARGB(255, 255, 243, 249),
                              padding: const EdgeInsets.all(16),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('UPLOAD PHOTO'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Icon(Icons.add_a_photo)
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_imageFile != null)
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Image(image: FileImage(_imageFile!)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _addNewBusiness,
                    label: const Text('Add Business',
                        style: TextStyle(fontSize: 18)),
                    icon: const Icon(Icons.add_business),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      backgroundColor: const Color.fromARGB(255, 255, 227, 241),
                      foregroundColor: const Color.fromARGB(255, 255, 56, 106),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
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
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 255, 190, 206)),
        ),
        focusedBorder: const OutlineInputBorder(
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

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleData.mobileErrorMsg1.getString(context);
    }
    final pattern = RegExp(r'^\d{10}$');
    if (!pattern.hasMatch(value)) {
      return LocaleData.mobileErrorMsg2.getString(context);
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final pattern = RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$');
    if (!pattern.hasMatch(value)) {
      return LocaleData.emailErrMsg2.getString(context);
    }
    return null;
  }
}
