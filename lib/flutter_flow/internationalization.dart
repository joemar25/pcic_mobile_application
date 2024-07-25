import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'tl'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? tlText = '',
  }) =>
      [enText, tlText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // login
  {
    'hsmsoal9': {
      'en': 'Login',
      'tl': '',
    },
    'onarar2h': {
      'en': 'Please sign in to continue',
      'tl': '',
    },
    'js4zrnhp': {
      'en': 'Enter your email address',
      'tl': '',
    },
    '5i1rsq7x': {
      'en': '',
      'tl': '',
    },
    'tei5629d': {
      'en': 'Enter your password',
      'tl': '',
    },
    'bws7du9e': {
      'en': 'Login',
      'tl': '',
    },
    'qpfpmvtl': {
      'en': 'Forgot Password?',
      'tl': '',
    },
    'w45297gi': {
      'en': 'Field is required',
      'tl': '',
    },
    'yc7u2stc': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'g6x5ocx1': {
      'en': 'Field is required',
      'tl': '',
    },
    'mpoif9dk': {
      'en': 'Password must be atleast 8 characters',
      'tl': '',
    },
    '97dgo696': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'wg8l5x4u': {
      'en': 'Home',
      'tl': '',
    },
  },
  // profile
  {
    'wqj3hsrh': {
      'en': 'Profile',
      'tl': '',
    },
    '8cppvoty': {
      'en': 'Account Settings',
      'tl': '',
    },
    '11dsrxu6': {
      'en': 'Switch to Dark Mode',
      'tl': '',
    },
    '3uy0o9hw': {
      'en': 'Switch to Light Mode',
      'tl': '',
    },
    '4ibmae0j': {
      'en': 'Edit Profile',
      'tl': '',
    },
    'zqsohbrx': {
      'en': 'Change Password',
      'tl': '',
    },
    'buokrewg': {
      'en': 'Log Out',
      'tl': '',
    },
    'kcupitz3': {
      'en': '__',
      'tl': '',
    },
  },
  // chats
  {
    'yq8kfovp': {
      'en': 'Messages',
      'tl': '',
    },
    '8hlwocb6': {
      'en': 'Below are messages with your friends.',
      'tl': '',
    },
    'gcfnxasp': {
      'en': 'Below are messages with your friends.',
      'tl': '',
    },
    'qjs4iqx3': {
      'en': '__',
      'tl': '',
    },
  },
  // edit_password
  {
    'igo0j7mh': {
      'en': 'Change Password',
      'tl': '',
    },
    'rqho0nbl': {
      'en':
          'We will reset your password. Please enter the password and confirmation password below, and then confirm.',
      'tl': '',
    },
    'jsat8wzg': {
      'en': 'Old Password',
      'tl': '',
    },
    '9qdzutxx': {
      'en': 'Enter Old Password...',
      'tl': '',
    },
    '6i3l397c': {
      'en': 'New Password',
      'tl': '',
    },
    'h4q8epxo': {
      'en': 'Enter New Password...',
      'tl': '',
    },
    'gfj61loc': {
      'en': 'Confirm Password',
      'tl': '',
    },
    'h1tl8jic': {
      'en': 'Confirm New Password...',
      'tl': '',
    },
    'mjwnfucf': {
      'en': 'Confirm Changes',
      'tl': '',
    },
    'i10lphec': {
      'en': 'Home',
      'tl': '',
    },
  },
  // edit_profile
  {
    '5fv645iv': {
      'en': 'Edit Profile',
      'tl': '',
    },
    'r9vm5mt1': {
      'en': 'Your Name',
      'tl': '',
    },
    'ntj2ozhk': {
      'en': 'Save Changes',
      'tl': '',
    },
  },
  // messages
  {
    'emndaizi': {
      'en': 'Type here to respond...',
      'tl': '',
    },
    'rbq8h8d1': {
      'en': 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
      'tl': '',
    },
    'yav59de8': {
      'en': 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
      'tl': '',
    },
    'zxojetjq': {
      'en': 'Home',
      'tl': '',
    },
  },
  // task_details
  {
    'x1jz4y0y': {
      'en': 'Task Details',
      'tl': '',
    },
    'ihmcvc23': {
      'en': 'This task is completed',
      'tl': '',
    },
    'j9rxgs8h': {
      'en': 'Form Details',
      'tl': '',
    },
    'zvbf8lkk': {
      'en': 'Assignment Id',
      'tl': '',
    },
    'x8d6g468': {
      'en': 'Farmer Name',
      'tl': '',
    },
    'webbx3lh': {
      'en': 'Address',
      'tl': '',
    },
    'qfage2ic': {
      'en': 'Insurance Id',
      'tl': '',
    },
    'ezx6meo9': {
      'en': 'Mobile Number',
      'tl': '',
    },
    'gvdbo0h6': {
      'en': 'Farmer Type',
      'tl': '',
    },
    '0blfogwv': {
      'en': 'Group Name',
      'tl': '',
    },
    'lst6ktx6': {
      'en': 'Group Address',
      'tl': '',
    },
    'zv71woqo': {
      'en': 'Lender Name',
      'tl': '',
    },
    'jl733wsk': {
      'en': 'Lender Address',
      'tl': '',
    },
    'zop5kb93': {
      'en': 'Region',
      'tl': '',
    },
    'b12iqcln': {
      'en': 'CIC Number',
      'tl': '',
    },
    'p1282pce': {
      'en': 'Farm Location',
      'tl': '',
    },
    'zm252mzp': {
      'en': '',
      'tl': '',
    },
    'hvb7985g': {
      'en': 'Location Sketch Plan',
      'tl': '',
    },
    'cat2uvtb': {
      'en': 'North',
      'tl': '',
    },
    'hytwamsl': {
      'en': 'East',
      'tl': '',
    },
    'qtzirwg5': {
      'en': 'South',
      'tl': '',
    },
    'gmqdadav': {
      'en': 'West',
      'tl': '',
    },
    'tsu0lxo2': {
      'en': 'Location Sketch Plan',
      'tl': '',
    },
    '792xrz3k': {
      'en': 'Area Planted',
      'tl': '',
    },
    'zxmreuh1': {
      'en': 'Date of Planting (DS)',
      'tl': '',
    },
    'ncrtgoe1': {
      'en': 'Datee of Planting (TP)',
      'tl': '',
    },
    'nzua63mv': {
      'en': 'Seed Variety Planted',
      'tl': '',
    },
    'dgbzqn0h': {
      'en': 'Completed Task  Details',
      'tl': '',
    },
    'nd1fqdu9': {
      'en': 'Tracking Details',
      'tl': '',
    },
    'uxt6f9xl': {
      'en': 'Last Coordinates',
      'tl': '',
    },
    'or3srkkk': {
      'en': 'Track Date',
      'tl': '',
    },
    '01tvwwxt': {
      'en': 'Total Area (ha)',
      'tl': '',
    },
    'vp2u9vxf': {
      'en': 'Total Distance',
      'tl': '',
    },
    'v9d4i47l': {
      'en': 'Seed Details',
      'tl': '',
    },
    '762mtpey': {
      'en': 'Type',
      'tl': '',
    },
    'veh8acpl': {
      'en': 'Variety',
      'tl': '',
    },
    'anco0w5m': {
      'en': 'Date Details',
      'tl': '',
    },
    '27rka9jx': {
      'en': 'Date of Planting (DS)',
      'tl': '',
    },
    '3zj0x11r': {
      'en': 'Date of Planting (TP)',
      'tl': '',
    },
    'lnj6pjl7': {
      'en': 'Agent Confirmation',
      'tl': '',
    },
    '966yfol9': {
      'en': 'Remarks',
      'tl': '',
    },
    '7ftdujb6': {
      'en': 'Confirmed By',
      'tl': '',
    },
    'tjm5ey7c': {
      'en': 'Signature',
      'tl': '',
    },
    '8bdkh9n1': {
      'en': 'Prepared By',
      'tl': '',
    },
    'aq1euelx': {
      'en': 'Signature',
      'tl': '',
    },
    'ahzx9d2y': {
      'en': 'Geotag',
      'tl': '',
    },
    '096k25yu': {
      'en': 'Recorded',
      'tl': '',
    },
    'e0abx8jq': {
      'en': 'Actions',
      'tl': '',
    },
    'g06chmkk': {
      'en': 'Geotag',
      'tl': '',
    },
    'm6egon7b': {
      'en': 'Resubmit',
      'tl': '',
    },
    '4jnx5njc': {
      'en': 'Home',
      'tl': '',
    },
  },
  // ppir
  {
    'erm3i53g': {
      'en': 'PPIR Form',
      'tl': '',
    },
    '3s84cgqw': {
      'en': 'Geotag Information',
      'tl': '',
    },
    '4o9qvz6v': {
      'en': 'Last Coordinates',
      'tl': '',
    },
    'oflb4doq': {
      'en': 'Date Time',
      'tl': '',
    },
    'li1l6k0w': {
      'en': 'Total Hectares',
      'tl': '',
    },
    'irvio488': {
      'en': 'Farm Location',
      'tl': '',
    },
    'oi19exk2': {
      'en': 'Geotag Control',
      'tl': '',
    },
    'bi2tyefd': {
      'en': 'Repeat Again',
      'tl': '',
    },
    'w3oxp9o9': {
      'en': 'View Geotag',
      'tl': '',
    },
    'quqb1avc': {
      'en': 'Seed Variety',
      'tl': '',
    },
    'wt2nxkv8': {
      'en': 'rice',
      'tl': '',
    },
    '3zzenggt': {
      'en': 'corn',
      'tl': '',
    },
    'e3nzk0t1': {
      'en': 'Select the Type of Rice ',
      'tl': '',
    },
    'a7yszlux': {
      'en': 'this is the rice',
      'tl': '',
    },
    'hgkqza7h': {
      'en': 'Please select...',
      'tl': '',
    },
    'za7pn038': {
      'en': 'Search for an item...',
      'tl': '',
    },
    'uj8vq3kw': {
      'en': 'Select the Type of Corn ',
      'tl': '',
    },
    'kd2ri9yq': {
      'en': 'this is the rice',
      'tl': '',
    },
    'f7j9hfpn': {
      'en': 'Please select...',
      'tl': '',
    },
    'rxggzdj9': {
      'en': 'Search for an item...',
      'tl': '',
    },
    '4x78xwmh': {
      'en': 'Actual Area Planted',
      'tl': '',
    },
    'dbhyempf': {
      'en': 'Actual Date of Planting (DS)',
      'tl': '',
    },
    'msrak9du': {
      'en': 'Actual Date of Planting (TS)',
      'tl': '',
    },
    '762st5cb': {
      'en': 'Remarks',
      'tl': '',
    },
    '99efrqt6': {
      'en': 'Prepared by',
      'tl': '',
    },
    'rkv9xt3s': {
      'en': 'Signature',
      'tl': '',
    },
    '8zawh1wx': {
      'en': 'Confirm by',
      'tl': '',
    },
    '2n6hawkd': {
      'en': 'Signature',
      'tl': '',
    },
    'vxop43vj': {
      'en': 'Cancel',
      'tl': '',
    },
    'kyab355w': {
      'en': 'Submit',
      'tl': '',
    },
    '4ho4omqk': {
      'en': 'Home',
      'tl': '',
    },
  },
  // form_success
  {
    '0g4vu9er': {
      'en': 'Congrats!',
      'tl': '',
    },
    '4pa6ldza': {
      'en': 'Tasks Submitted',
      'tl': '',
    },
    'fa57m321': {
      'en': 'Well Done!',
      'tl': '',
    },
    'z6rup7cd': {
      'en': 'Go Home',
      'tl': '',
    },
    'tg07lnkp': {
      'en': 'Home',
      'tl': '',
    },
  },
  // fail
  {
    'v6ssh8ir': {
      'en': 'Fail!',
      'tl': '',
    },
    'qki1g985': {
      'en': 'Home',
      'tl': '',
    },
  },
  // dashboard
  {
    'ek6mnpyv': {
      'en': 'Welcome',
      'tl': '',
    },
    'kqdeja9y': {
      'en': 'Good morning ',
      'tl': '',
    },
    'c9cu64hs': {
      'en': '!',
      'tl': '',
    },
    'vte71nhh': {
      'en': 'Task Overview',
      'tl': '',
    },
    'm10j35jr': {
      'en': 'For Dispatch',
      'tl': '',
    },
    'x0uyqjdj': {
      'en': 'Ongoing',
      'tl': '',
    },
    'v1rudbl9': {
      'en': 'Completed',
      'tl': '',
    },
    'ofobycr1': {
      'en': 'Find your task...',
      'tl': '',
    },
    'msy3t5xu': {
      'en': 'Option 1',
      'tl': '',
    },
    '40z3ewor': {
      'en': 'For Dispatch',
      'tl': '',
    },
    'eqlfjogs': {
      'en': 'Ongoing',
      'tl': '',
    },
    'i9ibpnoq': {
      'en': 'Completed',
      'tl': '',
    },
    '67jgj8w9': {
      'en': 'Home',
      'tl': '',
    },
  },
  // mapTesting
  {
    '08dw4jhj': {
      'en': 'Page Title',
      'tl': '',
    },
    'hdh6xlcb': {
      'en': 'Home',
      'tl': '',
    },
  },
  // success_profile
  {
    'e2bluypq': {
      'en': 'Success!',
      'tl': '',
    },
    'ioe9pmrx': {
      'en': 'Home',
      'tl': '',
    },
  },
  // marApiTest
  {
    '0ov0kosw': {
      'en': 'API Tester',
      'tl': '',
    },
    'lgzgz3y8': {
      'en': 'Test API Calls',
      'tl': '',
    },
    'u0bh28ib': {
      'en': 'Test GET',
      'tl': '',
    },
    'y9wod308': {
      'en': 'Test POST',
      'tl': '',
    },
    'lh091m1k': {
      'en': 'Test PUT',
      'tl': '',
    },
    '05jb6auu': {
      'en': 'Test DELETE',
      'tl': '',
    },
  },
  // forgotPassword
  {
    'ajwqbdpu': {
      'en': 'Forgot Password',
      'tl': '',
    },
    'owzqo8qh': {
      'en':
          'We will send you an email with a link to reset your password, please enter the email associated with your account below.',
      'tl': '',
    },
    '7xh7q3rt': {
      'en': 'Your email address...',
      'tl': '',
    },
    'a29ygr1c': {
      'en': 'Enter your email...',
      'tl': '',
    },
    'x3d82sua': {
      'en': 'Send Link',
      'tl': '',
    },
    '2stfj7a7': {
      'en': 'Home',
      'tl': '',
    },
  },
  // geotagging
  {
    'wkawnowa': {
      'en': 'Lat',
      'tl': '',
    },
    'lvzg53kl': {
      'en': 'Lng',
      'tl': '',
    },
    'qx4ly86s': {
      'en': 'Address',
      'tl': '',
    },
    '5rckehtu': {
      'en': 'Assignment Id',
      'tl': '',
    },
    'brrixmb6': {
      'en': 'Finish',
      'tl': '',
    },
    '0o8w3vlv': {
      'en': 'Home',
      'tl': '',
    },
  },
  // otherForm
  {
    'fa31tvpx': {
      'en': 'Page Title',
      'tl': '',
    },
    '0o8w3vlv': {
      'en': 'Home',
      'tl': '',
    },
  },
  // tasks
  {
    'j0q6t8qb': {
      'en': 'North: ',
      'tl': '',
    },
    'kdar2g2n': {
      'en': 'West: ',
      'tl': '',
    },
    'b2p4m05y': {
      'en': 'South: ',
      'tl': '',
    },
    '8zz0rgpr': {
      'en': 'East: ',
      'tl': '',
    },
    'vfsgjz34': {
      'en': 'Assignment Id',
      'tl': '',
    },
    '0869xbo0': {
      'en': 'Address',
      'tl': '',
    },
  },
  // chat
  {
    'fti6qnj7': {
      'en': 'Type here to respond...',
      'tl': '',
    },
  },
  // empty_lists
  {
    'qc74sp6j': {
      'en': 'No ',
      'tl': '',
    },
    'hh1zsrbx': {
      'en': 'It seems that you don\'t have any recent activity.',
      'tl': '',
    },
  },
  // userCard
  {
    'q2srxkm7': {
      'en': 'UserName',
      'tl': '',
    },
    'e7kvimdo': {
      'en': 'Subtitle',
      'tl': '',
    },
  },
  // changePhoto
  {
    'n5sjoaqa': {
      'en': 'Change Photo',
      'tl': '',
    },
    'yjbcio9o': {
      'en':
          'Upload a new photo below in order to change your avatar seen by others.',
      'tl': '',
    },
    'wr32c2ky': {
      'en': 'Upload Image',
      'tl': '',
    },
  },
  // signature
  {
    'nsefvndz': {
      'en': 'Signature',
      'tl': '',
    },
    's03qmvgh': {
      'en': 'Retry signature',
      'tl': '',
    },
    '6si6e5tk': {
      'en': 'Save',
      'tl': '',
    },
  },
  // sliderContainer
  {
    '4dvpzqez': {
      'en': 'Geotagging',
      'tl': '',
    },
    '0dhjdczh': {
      'en': 'Start',
      'tl': '',
    },
    'z7iocca5': {
      'en': 'Pin drop',
      'tl': '',
    },
    'bryj461x': {
      'en': 'Stop',
      'tl': '',
    },
    'u9apm1jr': {
      'en': 'Location',
      'tl': '',
    },
    '2ugch3dd': {
      'en': 'Coordinates',
      'tl': '',
    },
    '2g99ky91': {
      'en': 'Hello World',
      'tl': '',
    },
    'qdfww9v5': {
      'en': 'Hello World',
      'tl': '',
    },
    'e8w0ri0f': {
      'en': 'Address',
      'tl': '',
    },
    '507lgqrm': {
      'en': 'Hello World',
      'tl': '',
    },
    'dcziw3kd': {
      'en': 'Hello World',
      'tl': '',
    },
  },
  // Miscellaneous
  {
    '0ftylq1b': {
      'en':
          'PCIC Mobile Application needs access to your camera to enable Geotagging. This will help us accurately tag photos with your current location for better service delivery and documentation. Please grant camera access to continue.',
      'tl': '',
    },
    '2kgfkeu0': {
      'en':
          'PCIC Mobile Application needs access to your photo library to enable Geotagging. This will help us select and tag photos with your current location for better service delivery and documentation. Please grant photo library access to continue.',
      'tl': '',
    },
    '9xlvkb3u': {
      'en':
          'PCIC Mobile Application needs access to your location to enable Geotagging. This will help us accurately get gpx data with your current location for better service. Please grant Location access to continue.',
      'tl': '',
    },
    'klzb3gt7': {
      'en': '',
      'tl': '',
    },
    'wibvpqn3': {
      'en': '',
      'tl': '',
    },
    'hs555eff': {
      'en':
          'PCIC Mobile Application needs access to your location to enable Geotagging. This will help us accurately tag photos with your current location for better service delivery and documentation. Please grant location access to continue.',
      'tl': '',
    },
    'bzztgqlw': {
      'en': '',
      'tl': '',
    },
    'krsmb8tl': {
      'en': '',
      'tl': '',
    },
    'f4jve0im': {
      'en': '',
      'tl': '',
    },
    'ewy589yo': {
      'en': '',
      'tl': '',
    },
    'gnfsybzi': {
      'en': '',
      'tl': '',
    },
    'ukvuy6cu': {
      'en': '',
      'tl': '',
    },
    'gtbp0v1t': {
      'en': '',
      'tl': '',
    },
    'jcgvyvtj': {
      'en': '',
      'tl': '',
    },
    'fudyyijm': {
      'en': '',
      'tl': '',
    },
    '6belcyg0': {
      'en': '',
      'tl': '',
    },
    'suw462ve': {
      'en': '',
      'tl': '',
    },
    'lyghfiui': {
      'en': '',
      'tl': '',
    },
    '8ulvwwkv': {
      'en': '',
      'tl': '',
    },
    'sz6shdxb': {
      'en': '',
      'tl': '',
    },
    'klsd2ugc': {
      'en': '',
      'tl': '',
    },
    'ud5jbo3g': {
      'en': '',
      'tl': '',
    },
    'lrllsiiu': {
      'en': '',
      'tl': '',
    },
    'ut26nd9a': {
      'en': '',
      'tl': '',
    },
    'fmc974s7': {
      'en': '',
      'tl': '',
    },
    'b0js4q72': {
      'en': '',
      'tl': '',
    },
    'zl1r319i': {
      'en': '',
      'tl': '',
    },
    '43jzgspj': {
      'en': '',
      'tl': '',
    },
    'djw9fayn': {
      'en': '',
      'tl': '',
    },
    'hjnako4z': {
      'en': '',
      'tl': '',
    },
    'yciz7fe5': {
      'en': '',
      'tl': '',
    },
  },
].reduce((a, b) => a..addAll(b));
