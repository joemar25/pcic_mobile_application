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
    'loe9uree': {
      'en': 'PCIC Geotagging ',
      'tl': '',
    },
    '4okdmfv6': {
      'en': 'Welcome Back',
      'tl': '',
    },
    'wd51ceym': {
      'en': 'Please sign in to continue',
      'tl': '',
    },
    'dfm6pibp': {
      'en': 'Email Address',
      'tl': '',
    },
    'ie3newb4': {
      'en': 'Enter your email address...',
      'tl': '',
    },
    's13svqys': {
      'en': '',
      'tl': '',
    },
    'ates91zw': {
      'en': 'Password',
      'tl': '',
    },
    '0vxezk07': {
      'en': 'Enter your password...',
      'tl': '',
    },
    'twjqjyyn': {
      'en': '',
      'tl': '',
    },
    'lvomy5y7': {
      'en': 'Log in',
      'tl': '',
    },
    'p48qx3c2': {
      'en': 'Forgot Password ?',
      'tl': '',
    },
    'ze2n4vlq': {
      'en': 'Field is required',
      'tl': '',
    },
    'bzdqtdr8': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'bi8ton4q': {
      'en': 'Field is required',
      'tl': '',
    },
    'j7dhgc8q': {
      'en': 'Password must be atleast 8 characters',
      'tl': '',
    },
    '9aqb52if': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'wg8l5x4u': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // profile
  {
    'xqwyoxrh': {
      'en': 'Account',
      'tl': '',
    },
    '00if4ta7': {
      'en': 'Dark Mode',
      'tl': '',
    },
    '10h4gixp': {
      'en': 'Light Mode',
      'tl': '',
    },
    'q6imwgsn': {
      'en': 'Edit Profile',
      'tl': '',
    },
    'n0xjnlm2': {
      'en': 'Change Password',
      'tl': '',
    },
    '3r8ompzr': {
      'en': 'Download Maps',
      'tl': '',
    },
    'yttqc4w2': {
      'en': 'Sign Out',
      'tl': '',
    },
    'kcupitz3': {
      'en': 'Account',
      'tl': '__',
    },
  },
  // chats
  {
    'pue7zwxs': {
      'en': 'Messages',
      'tl': '',
    },
    '0ovitz68': {
      'en': 'Conversations',
      'tl': '',
    },
    'i2p6e78d': {
      'en': 'You are offline.',
      'tl': '',
    },
    'ks6c14gr': {
      'en': 'Compose',
      'tl': '',
    },
    'qjs4iqx3': {
      'en': 'Messages',
      'tl': '__',
    },
  },
  // editPassword
  {
    'gvf2mmiy': {
      'en': 'Change Password',
      'tl': '',
    },
    'zo0cddz7': {
      'en':
          'We will reset your password. Please enter the password and confirmation password below, and then confirm.',
      'tl': '',
    },
    'jsat8wzg': {
      'en': 'Old Password',
      'tl': 'Lumang password',
    },
    '9qdzutxx': {
      'en': 'Enter Old Password...',
      'tl': 'Ilagay ang Lumang Password...',
    },
    '3vbq0l5k': {
      'en': '',
      'tl': '',
    },
    '6i3l397c': {
      'en': 'New Password',
      'tl': 'Bagong Password',
    },
    'h4q8epxo': {
      'en': 'Enter New Password...',
      'tl': 'Maglagay ng Bagong Password...',
    },
    '6436aj7q': {
      'en': '',
      'tl': '',
    },
    'gfj61loc': {
      'en': 'Confirm Password',
      'tl': 'Kumpirmahin ang Password',
    },
    'h1tl8jic': {
      'en': 'Confirm New Password...',
      'tl': 'Kumpirmahin ang bagong password...',
    },
    'o6en6bvs': {
      'en': '',
      'tl': '',
    },
    'mjwnfucf': {
      'en': 'Confirm Changes',
      'tl': 'Kumpirmahin ang Mga Pagbabago',
    },
    'i10lphec': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // editProfile
  {
    '23dohx91': {
      'en': 'Edit Profile',
      'tl': '',
    },
    'r9vm5mt1': {
      'en': 'Name',
      'tl': 'Ang pangalan mo',
    },
    '8kwpczkh': {
      'en': '',
      'tl': '',
    },
    'ntj2ozhk': {
      'en': 'Save Changes',
      'tl': 'I-save ang mga pagbabago',
    },
    'gg4hbnhb': {
      'en': 'Field is required',
      'tl': '',
    },
    'k90ss0sh': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
  },
  // messages
  {
    'of52etyq': {
      'en': 'Message..',
      'tl': '',
    },
    'wjgzxgkw': {
      'en': 'Type your message here',
      'tl': '',
    },
    'f9pdwlqc': {
      'en': 'Send',
      'tl': '',
    },
    'zxojetjq': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // taskDetails
  {
    '7l5eyyx5': {
      'en': 'Form Details',
      'tl': '',
    },
    'zvbf8lkk': {
      'en': 'Assignment Id',
      'tl': 'Assignment Id',
    },
    'x8d6g468': {
      'en': 'Farmer Name',
      'tl': 'Pangalan ng Magsasaka',
    },
    'webbx3lh': {
      'en': 'Address',
      'tl': 'Address',
    },
    'qfage2ic': {
      'en': 'Insurance Id',
      'tl': 'Insurance Id',
    },
    'ezx6meo9': {
      'en': 'Mobile Number',
      'tl': 'Numero ng Mobile',
    },
    'gvdbo0h6': {
      'en': 'Farmer Type',
      'tl': 'Uri ng Magsasaka',
    },
    '0blfogwv': {
      'en': 'Group Name',
      'tl': 'Pangalan ng grupo',
    },
    'lst6ktx6': {
      'en': 'Group Address',
      'tl': 'Address ng Grupo',
    },
    'zv71woqo': {
      'en': 'Lender Name',
      'tl': 'Pangalan ng nagpapahiram',
    },
    'jl733wsk': {
      'en': 'Lender Address',
      'tl': 'Address ng nagpapahiram',
    },
    'zop5kb93': {
      'en': 'Region',
      'tl': 'Rehiyon',
    },
    'b12iqcln': {
      'en': 'CIC Number',
      'tl': 'Numero ng CIC',
    },
    'p1282pce': {
      'en': 'Farm Location',
      'tl': 'Lokasyon ng Bukid',
    },
    'hvb7985g': {
      'en': 'Location Sketch Plan',
      'tl': 'Plano ng Sketch ng Lokasyon',
    },
    'cat2uvtb': {
      'en': 'North',
      'tl': 'Hilaga',
    },
    'hytwamsl': {
      'en': 'East',
      'tl': 'Silangan',
    },
    'qtzirwg5': {
      'en': 'South',
      'tl': 'Timog',
    },
    'gmqdadav': {
      'en': 'West',
      'tl': 'Kanluran',
    },
    'tsu0lxo2': {
      'en': 'Location Sketch Plan',
      'tl': 'Plano ng Sketch ng Lokasyon',
    },
    '792xrz3k': {
      'en': 'Area Planted',
      'tl': 'Lugar na Nakatanim',
    },
    'zxmreuh1': {
      'en': 'Date of Planting (DS)',
      'tl': 'Petsa ng Pagtanim (DS)',
    },
    'ncrtgoe1': {
      'en': 'Date of Planting (TP)',
      'tl': 'Petsa ng Pagtatanim (TP)',
    },
    'nzua63mv': {
      'en': 'Seed Variety Planted',
      'tl': 'Iba\'t-ibang Binhi na Nakatanim',
    },
    'dgbzqn0h': {
      'en': 'Completed Task  Details',
      'tl': 'Mga Detalye ng Nakumpletong Gawain',
    },
    'nd1fqdu9': {
      'en': 'Tracking Details',
      'tl': 'Mga Detalye sa Pagsubaybay',
    },
    'uxt6f9xl': {
      'en': 'Last Coordinates',
      'tl': 'Mga Huling Coordinate',
    },
    'or3srkkk': {
      'en': 'Track Date',
      'tl': 'Petsa ng Pagsubaybay',
    },
    '01tvwwxt': {
      'en': 'Total Area (ha)',
      'tl': 'Kabuuang Lugar (ha)',
    },
    'vp2u9vxf': {
      'en': 'Total Distance',
      'tl': 'Kabuuang distansya',
    },
    'v9d4i47l': {
      'en': 'Seed Details',
      'tl': 'Mga Detalye ng Binhi',
    },
    '762mtpey': {
      'en': 'Type',
      'tl': 'Uri',
    },
    'veh8acpl': {
      'en': 'Variety',
      'tl': 'Iba\'t-ibang',
    },
    'anco0w5m': {
      'en': 'Date Details',
      'tl': 'Mga Detalye ng Petsa',
    },
    '27rka9jx': {
      'en': 'Date of Planting (DS)',
      'tl': 'Petsa ng Pagtanim (DS)',
    },
    '3zj0x11r': {
      'en': 'Date of Planting (TP)',
      'tl': 'Petsa ng Pagtatanim (TP)',
    },
    'lnj6pjl7': {
      'en': 'Agent Confirmation',
      'tl': 'Kumpirmasyon ng Ahente',
    },
    '966yfol9': {
      'en': 'Remarks',
      'tl': 'Remarks',
    },
    '7ftdujb6': {
      'en': 'Confirmed By',
      'tl': 'Kinumpirma ni',
    },
    '8bdkh9n1': {
      'en': 'Prepared By',
      'tl': 'Inihanda ni',
    },
    'ahzx9d2y': {
      'en': 'Geotag',
      'tl': 'Geotag',
    },
    '65kky15n': {
      'en': 'Geotag',
      'tl': '',
    },
    '7qj8fid9': {
      'en': 'Continue Form',
      'tl': '',
    },
    'auvo0ea6': {
      'en': 'Resubmit',
      'tl': '',
    },
    '0mkqs892': {
      'en': 'Geotag Again',
      'tl': '',
    },
    '4jnx5njc': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // formSuccess
  {
    '0g4vu9er': {
      'en': 'Congrats!',
      'tl': 'Congrats!',
    },
    '4pa6ldza': {
      'en': 'Task ',
      'tl': 'Mga gawain',
    },
    'fa57m321': {
      'en': 'Well Done!',
      'tl': 'Magaling!',
    },
    'z6rup7cd': {
      'en': 'Go Home',
      'tl': 'Umuwi kana',
    },
    'tg07lnkp': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // fail
  {
    'v6ssh8ir': {
      'en': 'Fail!',
      'tl': 'Nabigo!',
    },
    'jv3aqrf6': {
      'en': 'Okay',
      'tl': '',
    },
    'qki1g985': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // dashboard
  {
    '5q4it2k3': {
      'en': 'Task Overview',
      'tl': '',
    },
    'b756yymk': {
      'en': 'Welcome',
      'tl': '',
    },
    'xfwf34si': {
      'en': 'Good morning ',
      'tl': '',
    },
    'lx95ug5f': {
      'en': '!',
      'tl': '',
    },
    'j8akb40n': {
      'en': 'For Dispatch',
      'tl': '',
    },
    'qvw65nm7': {
      'en': 'Ongoing',
      'tl': '',
    },
    'gtnjyr06': {
      'en': 'Completed',
      'tl': '',
    },
    'ba2q7w08': {
      'en': 'For Dispatch',
      'tl': '',
    },
    'nxy1vlhk': {
      'en': 'Ongoing',
      'tl': '',
    },
    'c0a56ui1': {
      'en': 'Completed',
      'tl': '',
    },
    '67jgj8w9': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // successProfile
  {
    'e2bluypq': {
      'en': 'Success!',
      'tl': 'Tagumpay!',
    },
    'ioe9pmrx': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // forgotPassword
  {
    'ajwqbdpu': {
      'en': 'Forgot Password',
      'tl': 'Nakalimutan ang password',
    },
    'owzqo8qh': {
      'en':
          'We will send you an email with a link to reset your password, please enter the email associated with your account below.',
      'tl':
          'Padadalhan ka namin ng email na may link para i-reset ang iyong password, mangyaring ilagay ang email na nauugnay sa iyong account sa ibaba.',
    },
    '7xh7q3rt': {
      'en': 'Email Address',
      'tl': 'Ang iyong email address...',
    },
    'a29ygr1c': {
      'en': 'Enter your email...',
      'tl': 'Ilagay ang iyong email...',
    },
    'l0mxal5w': {
      'en': '',
      'tl': '',
    },
    'x3d82sua': {
      'en': 'Send Link',
      'tl': 'Magpasa ng link',
    },
    'c2yh7kit': {
      'en': 'Field is required',
      'tl': '',
    },
    'jldhk7m2': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    '2stfj7a7': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // geotagging
  {
    'qx4ly86s': {
      'en': 'Address: ',
      'tl': 'Address',
    },
    'lvzg53kl': {
      'en': 'Lng: ',
      'tl': 'Lng',
    },
    'zuoev2f9': {
      'en': 'Lat: ',
      'tl': '',
    },
    'cmxtd6yw': {
      'en': 'Finish',
      'tl': '',
    },
    '0o8w3vlv': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // mapTest
  {
    'yigfujp5': {
      'en': 'Offline Map',
      'tl': '',
    },
    'p5v52glk': {
      'en': 'Home',
      'tl': '',
    },
  },
  // pcicMap
  {
    'hopzh8rp': {
      'en': 'Map Search',
      'tl': '',
    },
    'xg5zqtpy': {
      'en': 'Downloaded',
      'tl': '',
    },
    'idur2ho8': {
      'en': 'Map Download',
      'tl': '',
    },
    '8n2rvzxw': {
      'en': 'Home',
      'tl': '',
    },
  },
  // offlineDbTest
  {
    'tcs90efh': {
      'en': 'Area 69',
      'tl': '',
    },
    '4twa0pya': {
      'en': 'List of Tasks',
      'tl': '',
    },
    'lj1x71om': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // offlineTasksAndPpirList
  {
    'o7uaesf0': {
      'en': 'Sync Task & PPIR',
      'tl': '',
    },
    'g6jjirj5': {
      'en': 'Offline Tasks Sync Test',
      'tl': '',
    },
    'ua766qme': {
      'en': 'Home',
      'tl': '',
    },
  },
  // onboarding
  {
    'e5zj0r88': {
      'en': 'Welcome Agent!',
      'tl': '',
    },
    'sdylopj4': {
      'en': 'to the PCIC Geotagging Application!',
      'tl': '',
    },
    'ult64d5q': {
      'en': 'Get Started',
      'tl': '',
    },
    's10teuws': {
      'en': 'Home',
      'tl': '',
    },
  },
  // syncData
  {
    '5l39d1ob': {
      'en': 'Tap to Sync',
      'tl': '',
    },
    'mh2af94v': {
      'en': 'Dashboard',
      'tl': '',
    },
    '2nf0agys': {
      'en': 'Home',
      'tl': '',
    },
  },
  // syncKing
  {
    'e3h43o18': {
      'en': 'Sync Task & PPIR',
      'tl': '',
    },
    '3i8noo2z': {
      'en': 'Dashboard',
      'tl': '',
    },
    'nm7pj9jt': {
      'en': 'Offline Tasks Sync Test',
      'tl': '',
    },
    '5fh27y4l': {
      'en': 'Home',
      'tl': '',
    },
  },
  // offlineSync
  {
    'nzwziy9t': {
      'en': 'Dashboard',
      'tl': '',
    },
    'v3jq6q5p': {
      'en': 'Home',
      'tl': '',
    },
  },
  // ppirForm
  {
    'oco9wa86': {
      'en': 'Geotag',
      'tl': '',
    },
    'le02hvs2': {
      'en': 'Tap here to dismiss map',
      'tl': '',
    },
    '8bwk8let': {
      'en': 'Cannot view GPX because you are offline.',
      'tl': '',
    },
    'tmnposi8': {
      'en': 'or',
      'tl': '',
    },
    '2mqikph7': {
      'en': 'If you download the map, ',
      'tl': '',
    },
    'frbq9zj2': {
      'en': 'TAP HERE',
      'tl': '',
    },
    '3wv9swhr': {
      'en': '.',
      'tl': '',
    },
    'vlpe8yky': {
      'en': 'Repeat Geotag',
      'tl': '',
    },
    '0er41e9i': {
      'en': 'Download',
      'tl': '',
    },
    'kjo3rf9g': {
      'en': 'Geotag Information',
      'tl': '',
    },
    'g8oor25r': {
      'en': 'Last Coordinates',
      'tl': '',
    },
    'j4k9ydv4': {
      'en': 'Total Area (ha)',
      'tl': '',
    },
    'bcn0bfjf': {
      'en': 'Date Time',
      'tl': '',
    },
    'wr9xhmty': {
      'en': 'Total Distance',
      'tl': '',
    },
    'opc4bpk1': {
      'en': 'Farm Location',
      'tl': '',
    },
    'l6pbtiio': {
      'en': 'Seed Variety',
      'tl': '',
    },
    'n2eymfb9': {
      'en': 'rice',
      'tl': '',
    },
    '2fy8z531': {
      'en': 'corn',
      'tl': '',
    },
    'fd5vtp4q': {
      'en': 'Select the Type of Rice ',
      'tl': '',
    },
    '9vpclvfb': {
      'en': 'Option 1',
      'tl': '',
    },
    'svwg4lfn': {
      'en': 'Please select...',
      'tl': '',
    },
    'wx9ezblr': {
      'en': 'Search for an item...',
      'tl': '',
    },
    'aqzhnbj5': {
      'en': 'Select the Type of Corn ',
      'tl': '',
    },
    'kyt3fdec': {
      'en': 'Option 1',
      'tl': '',
    },
    'frfbun0t': {
      'en': 'Please select...',
      'tl': '',
    },
    'vkwu56pa': {
      'en': 'Search for an item...',
      'tl': '',
    },
    'n872ktx2': {
      'en': 'Area',
      'tl': '',
    },
    'nuiqbq4u': {
      'en': 'Actual Area Planted',
      'tl': '',
    },
    'of9zu2fh': {
      'en': 'Actual Date of Planting (DS)',
      'tl': '',
    },
    'a0a2mg8u': {
      'en': 'Actual Date of Planting (TP)',
      'tl': '',
    },
    'f5is9k8s': {
      'en': 'Report Confirmation',
      'tl': '',
    },
    'xd5quvbx': {
      'en': 'Remarks',
      'tl': '',
    },
    '2slf6a8t': {
      'en': 'Prepared by',
      'tl': '',
    },
    'd6o99v59': {
      'en': 'Tap to Signature',
      'tl': '',
    },
    '8r38llaf': {
      'en': 'Confirm by',
      'tl': '',
    },
    '7ozi615f': {
      'en': 'Tap to Signature',
      'tl': '',
    },
    'aae0jxzm': {
      'en': 'Cancel',
      'tl': '',
    },
    'lgxphrlo': {
      'en': 'Save',
      'tl': '',
    },
    'wrod6how': {
      'en': 'Submit',
      'tl': '',
    },
    '6k4ph13p': {
      'en': 'Home',
      'tl': '',
    },
  },
  // tasks
  {
    '83q8pggh': {
      'en': 'Assignment Id',
      'tl': 'Assignment Id',
    },
    '0869xbo0': {
      'en': 'Address',
      'tl': 'Address',
    },
  },
  // chat
  {
    'fti6qnj7': {
      'en': 'Type here to respond...',
      'tl': 'Mag-type dito para tumugon...',
    },
  },
  // emptyLists
  {
    'qc74sp6j': {
      'en': 'No ',
      'tl': 'Hindi',
    },
    'hh1zsrbx': {
      'en': 'It seems that you don\'t have any recent activity.',
      'tl': 'Mukhang wala kang anumang kamakailang aktibidad.',
    },
  },
  // changePhoto
  {
    'n5sjoaqa': {
      'en': 'Change Photo',
      'tl': 'Baguhin ang Larawan',
    },
    'yjbcio9o': {
      'en':
          'Upload a new photo below in order to change your avatar seen by others.',
      'tl':
          'Mag-upload ng bagong larawan sa ibaba upang mapalitan ang iyong avatar na nakita ng iba.',
    },
    'wr32c2ky': {
      'en': 'Upload Image',
      'tl': 'Mag-upload ng Larawan',
    },
  },
  // signature
  {
    'nsefvndz': {
      'en': 'Signature',
      'tl': 'Lagda',
    },
    's03qmvgh': {
      'en': 'Retry signature',
      'tl': 'Subukang muli ang lagda',
    },
  },
  // backupTasks
  {
    'd4vy1q7s': {
      'en': 'North: ',
      'tl': '',
    },
    'c3uh2jd8': {
      'en': 'West: ',
      'tl': '',
    },
    'fav0lit3': {
      'en': 'South: ',
      'tl': '',
    },
    'c46yhefm': {
      'en': 'East: ',
      'tl': '',
    },
    '6ov3yzwq': {
      'en': 'Assignment Id',
      'tl': '',
    },
    'ftz1qs3j': {
      'en': 'Address',
      'tl': '',
    },
  },
  // signoutDialog
  {
    'pd2yz8ne': {
      'en': 'Confirm Sign Out',
      'tl': '',
    },
    'q15wq9be': {
      'en': 'Are you sure you want to sign out?',
      'tl': '',
    },
    'm2zyxgem': {
      'en': 'Cancel',
      'tl': '',
    },
    'quqrp02y': {
      'en': 'Sign Out',
      'tl': '',
    },
  },
  // userChats
  {
    'gb6dx75i': {
      'en': 'Select User',
      'tl': '',
    },
    'hjf1n0gp': {
      'en': 'Randy Peterson',
      'tl': '',
    },
    'umnwo680': {
      'en': 'name@domainname.com',
      'tl': '',
    },
    '6770atir': {
      'en': 'Randy Peterson',
      'tl': '',
    },
    'ifqnarpx': {
      'en': 'name@domainname.com',
      'tl': '',
    },
    '7t4vwu9u': {
      'en': 'Randy Peterson',
      'tl': '',
    },
    'trqe09c9': {
      'en': 'name@domainname.com',
      'tl': '',
    },
  },
  // alertContinueDialog
  {
    '4poy7kn4': {
      'en': 'Alert',
      'tl': '',
    },
    '5w0hrwzw': {
      'en':
          'The current gpx file will be deleted. \nAre you sure you want to continue?',
      'tl': '',
    },
    '9nbvgmc2': {
      'en': 'Cancel',
      'tl': '',
    },
    '6qtpudw1': {
      'en': 'Sign Out',
      'tl': '',
    },
  },
  // noInternetDialog
  {
    'm2d8uxk3': {
      'en': 'Info',
      'tl': '',
    },
    'wreq3f64': {
      'en':
          'You have no current internet connection. To download a map, please connect to the internet.',
      'tl': '',
    },
    'x2kr3ijp': {
      'en': 'Reconnect',
      'tl': '',
    },
  },
  // permissionDialog
  {
    'vsbe3eji': {
      'en': 'Notice',
      'tl': '',
    },
    'bsqylrb4': {
      'en':
          'You must be Online and the Location permission must be enabled to proceed.',
      'tl': '',
    },
    'ighw54es': {
      'en': 'Okay',
      'tl': '',
    },
  },
  // continueReGeotagDialog
  {
    'txdl513w': {
      'en': 'Alert',
      'tl': '',
    },
    'aevwr0vt': {
      'en':
          'The current gpx file will be deleted. \nAre you sure you want to continue?',
      'tl': '',
    },
    'pol5d0m3': {
      'en': 'Cancel',
      'tl': '',
    },
    'xhp3rkfj': {
      'en': 'Continue',
      'tl': '',
    },
  },
  // continueGoBackDialog
  {
    '6fpxyw60': {
      'en': 'Warning',
      'tl': '',
    },
    'zoypq20i': {
      'en':
          'This will cancel the current progress of geotagging. Do you want to continue?',
      'tl': '',
    },
    '4m3l8rlv': {
      'en': 'Cancel',
      'tl': '',
    },
    '2temga0h': {
      'en': 'Continue',
      'tl': '',
    },
  },
  // continueSubmitDialog
  {
    '2gqa0lrn': {
      'en': 'Info',
      'tl': '',
    },
    'x6p50a5s': {
      'en': 'Do you want to Submit all the data above?',
      'tl': '',
    },
    '30viluzv': {
      'en': 'Cancel',
      'tl': '',
    },
    '8vm8xjo5': {
      'en': 'Continue',
      'tl': '',
    },
  },
  // continueSaveDialog
  {
    'n8g6v3fj': {
      'en': 'Info',
      'tl': '',
    },
    '8a42qjb7': {
      'en': 'Do you want to Save the data above?',
      'tl': '',
    },
    'clidangu': {
      'en': 'Cancel',
      'tl': '',
    },
    'nsdqb1mh': {
      'en': 'Continue',
      'tl': '',
    },
  },
  // continueCancelDialog
  {
    '4i07fax8': {
      'en': 'Warning',
      'tl': '',
    },
    'hg3q7i0o': {
      'en':
          'This will cancel your current progress in the tasks. Are you sure you want to cancel?',
      'tl': '',
    },
    '7ytcjqdh': {
      'en': 'Cancel',
      'tl': '',
    },
    'c75bzs2e': {
      'en': 'Continue',
      'tl': '',
    },
  },
  // fillOutAllFieldsDialog
  {
    'nfddva3z': {
      'en': 'Alert',
      'tl': '',
    },
    'ctq3a7as': {
      'en': 'Please fill out all fields.',
      'tl': '',
    },
    'nzt0dax8': {
      'en': 'Okay',
      'tl': '',
    },
  },
  // uploadFailedDialog
  {
    'v46c8giv': {
      'en': 'Failed',
      'tl': '',
    },
    '014tcrks': {
      'en': 'Failed to upload to FTP.',
      'tl': '',
    },
    'gn2n1vua': {
      'en': 'Okay',
      'tl': '',
    },
  },
  // noInternetDialogCopy
  {
    'x9y1e4s4': {
      'en': 'Info',
      'tl': '',
    },
    'vjr5drgf': {
      'en': 'You have no current internet connection.',
      'tl': '',
    },
    'f76rmfhb': {
      'en': 'Dismiss',
      'tl': '',
    },
  },
  // Miscellaneous
  {
    '6afd8gwy': {
      'en': 'Label here...',
      'tl': '',
    },
    'x8lsse0f': {
      'en': 'Hint text here ...',
      'tl': '',
    },
    '3gp3iqd8': {
      'en': 'Button',
      'tl': '',
    },
    '0ftylq1b': {
      'en':
          '\"PCIC Mobile Application requires access to your camera to enable geotagging. This feature will allow us to accurately tag photos with your current location, improving service delivery and documentation. Please grant camera access to continue.\"',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong camera upang paganahin ang geotagging. Ang tampok na ito ay magbibigay-daan sa amin upang tumpak na i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ang camera ng access upang magpatuloy.\"',
    },
    '2kgfkeu0': {
      'en':
          '\"PCIC Mobile Application requires access to your photo library to enable geotagging. This will help us select and tag photos with your current location, improving service delivery and documentation. Please grant photo library access to continue.\"',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong library ng larawan upang paganahin ang geotagging. Makakatulong ito sa amin na piliin at i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ng access sa library ng larawan upang magpatuloy.\"',
    },
    '9xlvkb3u': {
      'en':
          '\"PCIC Mobile Application requires access to your location to enable geotagging. This will allow us to accurately obtain GPX data with your current location, improving our service. Please grant location access to continue.\"',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong lokasyon upang paganahin ang geotagging. Ito ay magbibigay-daan sa amin na tumpak na makakuha ng data ng GPX sa iyong kasalukuyang lokasyon, pagpapabuti ng aming serbisyo. Mangyaring bigyan ng access sa lokasyon upang magpatuloy.\"',
    },
    'klzb3gt7': {
      'en': '',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong library ng larawan upang paganahin ang geotagging. Makakatulong ito sa amin na piliin at i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ng access sa library ng larawan upang magpatuloy.\"',
    },
    'wibvpqn3': {
      'en': '',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong camera upang paganahin ang geotagging. Ang tampok na ito ay magbibigay-daan sa amin upang tumpak na i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ang camera ng access upang magpatuloy.\"',
    },
    'hs555eff': {
      'en':
          'PCIC Mobile Application needs access to your location to enable Geotagging. This will help us accurately tag photos with your current location for better service delivery and documentation. Please grant location access to continue.',
      'tl':
          '\"Ang PCI Mobile Application ay nangangailangan ng access sa iyong camera upang paganahin ang geotagging. Ang tampok na ito ay magbibigay-daan sa amin upang tumpak na i-tag ang mga larawan sa iyong kasalukuyang lokasyon, pagpapabuti ng paghahatid ng serbisyo at dokumentasyon. Mangyaring bigyan ang camera ng access upang magpatuloy.\"',
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
