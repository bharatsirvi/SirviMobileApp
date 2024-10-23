import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale('en', LocaleData.EN),
  MapLocale('hi', LocaleData.HI),
];

mixin LocaleData {
  static const String name = "Name";
  static const String Continue = "Continue";
  static const String welcome = "WELCOME";
  static const String appName = "Sirvi App";
  static const String nameErrorMsg = 'Please Enter Name';
  static const String mobileErrorMsg1 = 'Please Enter Mobile Number';
  static const String mobileErrorMsg2 = 'Invalid mobile number';
  static const String passwordErrorMsg1 = 'Please enter password';
  static const String passwordErrorMsg2 =
      'Password must be at least 6 characters';
  static const String otpSendMsg = 'OTP sent to';
  static const String signUp = 'Sign Up';
  static const String mobileNo = 'Mobile Number';
  static const String password = 'Password';
  static const String verified = 'Verified';
  static const String sending = 'Sending';
  static const String sendOtp = 'Send OTP';
  static const String firstClickOnSend = 'Please First Click On Send OTP';
  static const String accountExitsMsg = 'Already have an account?';
  static const String login = "Login";
  static const String loginmsg = "login";
  static const String changeLang = "Change Language";
  static const String hindilang = 'Hindi(BHARAT)';
  static const String accountNotExitsMsg = "Don't have an account?";
  static const String forgotPassword = 'Forgot Password';
  static const String createOne = 'Create One';
  static const String myAccount = 'My Account';
  static const String student = 'Student';
  static const String business = 'Business';
  static const String helpSupport = 'Help & Support';
  static const String logout = 'Logout';
  static const String edit = 'Edit';
  static const String profile = 'Profile';
  static const String home = "Home";
  static const String event = "Event";
  static const String image = "Image";
  static const String fathersName = "Father's Name";
  static const String email = "Email";
  static const String dob = "Date Of Birth";
  static const String gotra = "Gotra";
  static const String gender = "Gender";
  static const String saveChanges = "Save Changes";
  static const String discardChangesTitle = "Discard Changes?";
  static const String discardChangesMessage =
      "Do you want to discard the changes?";
  static const String yes = "Yes";
  static const String no = "No";
  static const String gotraErrMsg2 =
      "Gotra must be one of the predefined options";
  static const String emailErrMsg2 = "Invalid email address";
  static const String dobErrMsg2 = "Invalid date format";
  static const String male = 'Male';
  static const String female = 'Female';
  static const String bhyal = 'Bhyal';
  static const String sindhara = 'Sindhara';
  static const String hambad = 'Hambad';
  static const String chauhan = 'Chauhan';
  static const String kag = 'Kag';
  static const String choyal = 'Choyal';
  static const String aglecha = 'Aglecha';
  static const String khandala = 'Khandala';
  static const String barfa = 'Barfa';
  static const String septa = 'Septa';
  static const String mogrecha = 'Mogrecha';
  static const String devda = 'Devda';
  static const String muleva = 'Muleva';
  static const String solanki = 'Solanki';
  static const String rathore = 'Rathore';
  static const String chavadiya = 'Chavadiya';
  static const String gahlot = 'Gahlot';
  static const String parihar = 'Parihar';

  static const String studentDetails = "Student Details";
  static const String save = "Save";
  static const String cancel = "Cancel";
  static const String delete = "Delete";
  static const String medium = "Medium";
  static const String schoolInstitute = "School/Institute";
  static const String studyPlace = "Study Place";
  static const String studyLevel = "Study Level";
  static const String classLabel = "Class";
  static const String collegeYear = "College Year";
  static const String studyType = "Study Type";
  static const String village = "Village";

  static const String hindi = "Hindi";
  static const String english = "English";
  static const String gujarati = "Gujarati";
  static const String marathi = "Marathi";
  static const String other = "Other";

  static const String school = "School";
  static const String college = "College";
  static const String higher = "Higher";

  static const String coaching = "Coaching";
  static const String selfStudy = "Self Study";

  static const String studentDeleted = "Student Deleted!";
  static const String addStudent = "Add Student";
  static const String noStudentsAddedYet = "NO STUDENTS ADDED YET!";
  static const String viewAll = "View All";
  static const String deleteConfirmation = "Delete Confirmation";
  static const String deleteConfirmationMessage =
      "Are you sure you want to delete ?";
  static const String add = "ADD";
  static const String studentUpdated = "Student Updated!";
  static const String nameErrMsg = "Name is required";
  static const String fathersNameErrMsg = "Father's Name is required";
  static const String genderErrMsg = "Gender is required";
  static const String gotraErrMsg1 = "Gotra is required";
  static const String dobErrMsg1 = "Date of Birth is required";
  static const String mediumErrMsg = "Medium is required";
  static const String studyLevelErrMsg = "Study Level is required";
  static const String classErrMsg = "Class is required";
  static const String collegeYearErrMsg = "College Year is required";
  static const String studyPlaceErrMsg = "Study Place is required";
  static const String studentAdded = "Student Added!";
  static const String fillRequiredFieldMsg = "Please Fill All Required Field";
  static const String logoutConfirmation = "Logout!";
  static const String logoutConfirmationMessage =
      "Are you sure you want to leave?";
  static Map<String, Map<String, dynamic>> localizedStrings = {
    'en': EN,
    'hi': HI,
  };

  // Method to get localized string based on key and current locale
  static String getString(BuildContext context, String key) {
    FlutterLocalization localization = FlutterLocalization.instance;
    Locale currentLocale = localization.currentLocale!;
    String languageCode = currentLocale.languageCode;
    String result = localizedStrings[languageCode]?[key] ?? '';
    return result;
  }

  static const Map<String, dynamic> EN = {
    name: "Name",
    Continue: "Continue",
    welcome: "Welcome",
    appName: "Sirvi App",
    nameErrorMsg: "Please Enter Name",
    mobileErrorMsg1: 'Please Enter Mobile Number',
    mobileErrorMsg2: 'Please enter valid mobile number',
    passwordErrorMsg1: 'Please enter password',
    passwordErrorMsg2: 'Password must be at least 6 characters',
    otpSendMsg: 'OTP sent to',
    signUp: 'Sign Up',
    mobileNo: 'Mobile Number',
    password: 'Password',
    verified: 'Verified',
    sending: 'Sending',
    sendOtp: 'Send OTP',
    firstClickOnSend: 'Please First Click On Send OTP',
    accountExitsMsg: 'Already have an account',
    login: "Login",
    loginmsg: "Login",
    changeLang: "Change Language",
    hindilang: 'Hindi',
    accountNotExitsMsg: "Don't have an account?",
    forgotPassword: 'Forgot Password',
    createOne: "create One",
    myAccount: 'My Account',
    student: 'Student',
    business: 'Business',
    helpSupport: 'Help & Support',
    logout: 'Logout',
    edit: 'Edit',
    profile: 'Profile',
    home: "Home",
    event: "Event",
    image: "Image",
    fathersName: "Father's Name",
    email: 'Email',
    dob: 'Date Of Birth',
    gotra: 'Gotra',
    gender: 'Gender',
    saveChanges: 'Save Changes',
    discardChangesTitle: 'Discard Changes?',
    discardChangesMessage: 'Do you want to discard the changes?',
    yes: 'Yes',
    no: 'No',
    gotraErrMsg2: 'Gotra must be one of the predefined options',
    emailErrMsg2: 'Invalid email address',
    dobErrMsg2: 'Invalid date format',
    male: 'Male',
    female: 'Female',
    bhyal: 'Bhyal',
    sindhara: 'Sindhara',
    hambad: 'Hambad',
    chauhan: 'Chauhan',
    kag: 'Kag',
    choyal: 'Choyal',
    aglecha: 'Aglecha',
    khandala: 'Khandala',
    barfa: 'Barfa',
    septa: 'Septa',
    mogrecha: 'Mogrecha',
    devda: 'Devda',
    muleva: 'Muleva',
    solanki: 'Solanki',
    parihar: 'Parihar',
    rathore: 'Rathore',
    chavadiya: 'Chavadiya',
    gahlot: 'Gahlot',
    studentDetails: "Student Details",
    save: "Save",
    cancel: "Cancel",
    delete: "Delete",
    medium: "Medium",
    schoolInstitute: "School/Institute",
    studyPlace: "Study Place",
    studyLevel: "Study Level",
    classLabel: "Class",
    collegeYear: "College Year",
    studyType: "Study Type",
    village: "Village",
    hindi: "Hindi",
    english: "English",
    gujarati: "Gujarati",
    marathi: "Marathi",
    other: "Other",
    school: "School",
    college: "College",
    higher: "Higher",
    coaching: "Coaching",
    selfStudy: "Self Study",
    studentDeleted: "Student Deleted!",
    addStudent: "Add Student",
    noStudentsAddedYet: "NO STUDENTS ADDED YET!",
    viewAll: "View All",
    deleteConfirmation: "Delete Confirmation",
    deleteConfirmationMessage: "Are you sure you want to delete ?",
    add: "ADD",
    "1": "1st",
    "2": "2nd",
    "3": "3rd",
    "4": "4th",
    "5": "5th",
    "6": "6th",
    "7": "7th",
    "8": "8th",
    "9": "9th",
    "10": "10th",
    "11": "11th",
    "12": "12th",
    studentUpdated: "Student Updated!",
    nameErrMsg: "Name is required",
    fathersNameErrMsg: "Father's Name is required",
    genderErrMsg: "Gender is required",
    gotraErrMsg1: "Gotra is required",
    dobErrMsg1: "Date of Birth is required",
    mediumErrMsg: "Medium is required",
    studyLevelErrMsg: "Study Level is required",
    classErrMsg: "Class is required",
    collegeYearErrMsg: "College Year is required",
    studyPlaceErrMsg: "Study Place is required",
    studentAdded: "Student Added!",
    fillRequiredFieldMsg: "Please Fill All Required Field",
    logoutConfirmation: "Logout!",
    logoutConfirmationMessage: 'Are you sure you want to leave?'
  };
  static getStringInEng(BuildContext context, String key) {
    return localizedStrings['en']?[key] ?? '';
  }

  static const Map<String, dynamic> HI = {
    name: "नाम",
    Continue: "आगे बढे",
    welcome: "नमस्ते",
    appName: "सीरवी समाज",
    nameErrorMsg: "कृपया नाम दर्ज करें",
    mobileErrorMsg1: 'कृपया मोबाइल नंबर दर्ज करें',
    mobileErrorMsg2: 'मान्य मोबाइल नंबर भरे',
    passwordErrorMsg1: 'कृपया पासवर्ड दर्ज करें',
    passwordErrorMsg2: 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए',
    otpSendMsg: 'ओ.टी.पी भेजा गया',
    signUp: 'खाता खोलें',
    mobileNo: 'मोबाइल नंबर',
    password: 'पासवर्ड',
    verified: 'सत्यापित',
    sending: 'भेज रहा है',
    sendOtp: 'ओ.टी.पी भेजें',
    firstClickOnSend: 'कृपया पहले (ओ.टी.पी भेजें) पर दबाएं',
    accountExitsMsg: 'पहले से ही एक खाता है ?',
    login: 'आगे बढ़ें',
    loginmsg: "लॉग इन",
    changeLang: 'भाषा बदलें',
    hindilang: "हिन्दी(भारत)",
    accountNotExitsMsg: "खाता नहीं है ?",
    forgotPassword: 'पासवर्ड भूल गए ?',
    createOne: "नया खाता बनाएं",
    myAccount: 'मेरी जानकारी',
    student: 'विद्यार्थी',
    business: 'व्यापार',
    helpSupport: 'सहायता और सुझाव',
    logout: 'लॉगआउट',
    edit: 'संपादित करें',
    profile: 'प्रोफाइल',
    home: "होम",
    event: "कार्यक्रम",
    image: "फोटो",
    fathersName: "पिता का नाम",
    email: 'ईमेल',
    dob: 'जन्म तिथि',
    gotra: 'गोत्र',
    gender: 'लिंग',
    saveChanges: 'बदले',
    discardChangesTitle: 'बाहर जाये?',
    discardChangesMessage: 'क्या आप बदलाव को खारिज करना चाहते हैं?',
    yes: 'हाँ',
    no: 'नहीं',
    emailErrMsg2: 'मान्य ईमेल भरे',
    gotraErrMsg2: 'गोत्र विकल्पों में से एक होना चाहिए',
    dobErrMsg2: 'मान्य तारीख भरे',
    male: 'पुरुष',
    female: 'महिला',
    bhyal: 'भ्याल',
    sindhara: 'सिंधारा',
    hambad: 'हंबद',
    chauhan: 'चौहान',
    kag: 'काग',
    choyal: 'चोयल',
    aglecha: 'अगलेचा',
    khandala: 'खंडाला',
    barfa: 'बरफा',
    septa: 'सेप्टा',
    mogrecha: 'मोगरेचा',
    devda: 'देवदा',
    muleva: 'मूलेवा',
    solanki: 'सोलंकी',
    parihar: 'परिहार',
    rathore: 'राठौड़',
    chavadiya: 'चावडिया',
    gahlot: 'गहलोत',
    studentDetails: "छात्र विवरण",
    save: "सहेजें",
    cancel: "रद्द करें",
    delete: "हटाएं",
    medium: "माध्यम",
    schoolInstitute: "स्कूल/संस्थान",
    studyPlace: "अध्ययन स्थान",
    studyLevel: "अध्ययन स्तर",
    classLabel: "कक्षा",
    collegeYear: "कॉलेज वर्ष",
    studyType: "अध्ययन प्रकार",
    village: "गांव",
    hindi: "हिंदी",
    english: "अंग्रेज़ी",
    gujarati: "गुजराती",
    marathi: "मराठी",
    other: "अन्य",
    school: "स्कूल",
    college: "कॉलेज",
    higher: "उच्च",
    coaching: "कोचिंग",
    selfStudy: "स्वयं अध्ययन",
    studentDeleted: "छात्र हटा दिया गया!",
    addStudent: "छात्र जोड़ें",
    noStudentsAddedYet: "अभी तक कोई छात्र जोड़ा नहीं गया है!",
    viewAll: " छात्र देखें",
    deleteConfirmation: "हटाने की पुष्टि",
    deleteConfirmationMessage: "क्या आप हटाना चाहते हो?",
    add: "जोड़ें",
    "1": "1",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
    "10": "10",
    studentUpdated: "छात्र अपडेट किया गया!",
    nameErrMsg: "कृपया नाम दर्ज करें",
    fathersNameErrMsg: "कृपया पिता का नाम दर्ज करें",
    genderErrMsg: "कृपया लिंग दर्ज करें",
    gotraErrMsg1: "कृपया गोत्र दर्ज करें",
    dobErrMsg1: "कृपया जन्म तिथि दर्ज करें",
    mediumErrMsg: "कृपया माध्यम दर्ज करें",
    studyLevelErrMsg: "कृपया अध्ययन स्तर दर्ज करें",
    classErrMsg: "कृपया कक्षा दर्ज करें",
    collegeYearErrMsg: "कृपया कॉलेज वर्ष दर्ज करें",
    studyPlaceErrMsg: "कृपया अध्ययन स्थान दर्ज करें",
    studentAdded: "छात्र जोड़ा गया!",
    fillRequiredFieldMsg: "कृपया सभी आवश्यक जानकारी भरें",
    logoutConfirmation: "लॉगआउट !",
    logoutConfirmationMessage: "क्या आप बाहर जाना चाहते हैं?"
  };
}
