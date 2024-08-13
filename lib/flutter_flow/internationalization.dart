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
    'py6ovdt7': {
      'en': 'PCIC Geotagging ',
      'tl': '',
    },
    'm6ts5v8u': {
      'en': 'Welcome Back',
      'tl': '',
    },
    'vtpwtki1': {
      'en': 'Please sign in to continue',
      'tl': '',
    },
    '71199j9k': {
      'en': 'Email Address',
      'tl': '',
    },
    'vy1wtl5k': {
      'en': 'Enter your email address...',
      'tl': '',
    },
    'f0cvuzcg': {
      'en': '',
      'tl': '',
    },
    's11m4d5b': {
      'en': 'Password',
      'tl': '',
    },
    '617sxtmo': {
      'en': 'Enter your password...',
      'tl': '',
    },
    'w242n4tp': {
      'en': '',
      'tl': '',
    },
    '32i6nk7l': {
      'en': 'Log in',
      'tl': '',
    },
    '3ztauu8v': {
      'en': 'Forgot Password ?',
      'tl': '',
    },
    'kyyyy0az': {
      'en': 'Field is required',
      'tl': '',
    },
    'm0y1kdcw': {
      'en': 'Please choose an option from the dropdown',
      'tl': '',
    },
    'xv20uueg': {
      'en': 'Field is required',
      'tl': '',
    },
    'jte1qgob': {
      'en': 'Password must be atleast 8 characters',
      'tl': '',
    },
    'xbwo0ppz': {
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
    'qkhyppx6': {
      'en': 'Sync Database',
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
    'smaqwno7': {
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
    'ohmnwbis': {
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
    'zkkhivvd': {
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
    '8kwpczkh': {
      'en': '',
      'tl': '',
    },
    'e0gy432x': {
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
    'j9rxgs8h': {
      'en': 'Form Details',
      'tl': 'Mga Detalye ng Form',
    },
    'zvbf8lkk': {
      'en': 'Assignment Id',
      'tl': 'Assignment Id',
    },
    'gjgpol8f': {
      'en': '-',
      'tl': '',
    },
    'x8d6g468': {
      'en': 'Farmer Name',
      'tl': 'Pangalan ng Magsasaka',
    },
    'no1n8b9w': {
      'en': '-',
      'tl': '',
    },
    'webbx3lh': {
      'en': 'Address',
      'tl': 'Address',
    },
    'unwimurv': {
      'en': '-',
      'tl': '',
    },
    'qfage2ic': {
      'en': 'Insurance Id',
      'tl': 'Insurance Id',
    },
    'ld4fzlai': {
      'en': '-',
      'tl': '',
    },
    'ezx6meo9': {
      'en': 'Mobile Number',
      'tl': 'Numero ng Mobile',
    },
    '9aydp8un': {
      'en': '-',
      'tl': '',
    },
    'gvdbo0h6': {
      'en': 'Farmer Type',
      'tl': 'Uri ng Magsasaka',
    },
    '4ltcm64a': {
      'en': '-',
      'tl': '',
    },
    '0blfogwv': {
      'en': 'Group Name',
      'tl': 'Pangalan ng grupo',
    },
    '92blrk04': {
      'en': '-',
      'tl': '',
    },
    'lst6ktx6': {
      'en': 'Group Address',
      'tl': 'Address ng Grupo',
    },
    '6xs82b56': {
      'en': '-',
      'tl': '',
    },
    'zv71woqo': {
      'en': 'Lender Name',
      'tl': 'Pangalan ng nagpapahiram',
    },
    'yexmpzwz': {
      'en': '-',
      'tl': '',
    },
    'jl733wsk': {
      'en': 'Lender Address',
      'tl': 'Address ng nagpapahiram',
    },
    'msmjq3c1': {
      'en': '-',
      'tl': '',
    },
    'zop5kb93': {
      'en': 'Region',
      'tl': 'Rehiyon',
    },
    'b12iqcln': {
      'en': 'CIC Number',
      'tl': 'Numero ng CIC',
    },
    'qhvztmpv': {
      'en': '-',
      'tl': '',
    },
    'p1282pce': {
      'en': 'Farm Location',
      'tl': 'Lokasyon ng Bukid',
    },
    'drw0h32n': {
      'en': '-',
      'tl': '',
    },
    'hvb7985g': {
      'en': 'Location Sketch Plan',
      'tl': 'Plano ng Sketch ng Lokasyon',
    },
    'cat2uvtb': {
      'en': 'North',
      'tl': 'Hilaga',
    },
    '8hclpkqm': {
      'en': '-',
      'tl': '',
    },
    'hytwamsl': {
      'en': 'East',
      'tl': 'Silangan',
    },
    '0low7psj': {
      'en': '-',
      'tl': '',
    },
    'qtzirwg5': {
      'en': 'South',
      'tl': 'Timog',
    },
    '03a9045c': {
      'en': '-',
      'tl': '',
    },
    'gmqdadav': {
      'en': 'West',
      'tl': 'Kanluran',
    },
    '5ohs3fsy': {
      'en': '-',
      'tl': '',
    },
    'tsu0lxo2': {
      'en': 'Location Sketch Plan',
      'tl': 'Plano ng Sketch ng Lokasyon',
    },
    '792xrz3k': {
      'en': 'Area Planted',
      'tl': 'Lugar na Nakatanim',
    },
    'ftsdowzw': {
      'en': '-',
      'tl': '',
    },
    'zxmreuh1': {
      'en': 'Date of Planting (DS)',
      'tl': 'Petsa ng Pagtanim (DS)',
    },
    'nt3syuhh': {
      'en': '-',
      'tl': '',
    },
    'ncrtgoe1': {
      'en': 'Datee of Planting (TP)',
      'tl': 'Petsa ng Pagtatanim (TP)',
    },
    'ltmuyine': {
      'en': '-',
      'tl': '',
    },
    'nzua63mv': {
      'en': 'Seed Variety Planted',
      'tl': 'Iba\'t-ibang Binhi na Nakatanim',
    },
    'xsqheqcj': {
      'en': '-',
      'tl': '',
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
    'yyhjt5l3': {
      'en': '-',
      'tl': '',
    },
    'or3srkkk': {
      'en': 'Track Date',
      'tl': 'Petsa ng Pagsubaybay',
    },
    'usxs21ur': {
      'en': '-',
      'tl': '',
    },
    '01tvwwxt': {
      'en': 'Total Area (ha)',
      'tl': 'Kabuuang Lugar (ha)',
    },
    'zrkc0xc5': {
      'en': '-',
      'tl': '',
    },
    'vp2u9vxf': {
      'en': 'Total Distance',
      'tl': 'Kabuuang distansya',
    },
    'q7ree8kc': {
      'en': '-',
      'tl': '',
    },
    'v9d4i47l': {
      'en': 'Seed Details',
      'tl': 'Mga Detalye ng Binhi',
    },
    '762mtpey': {
      'en': 'Type',
      'tl': 'Uri',
    },
    'b1c50rc1': {
      'en': '-',
      'tl': '',
    },
    'veh8acpl': {
      'en': 'Variety',
      'tl': 'Iba\'t-ibang',
    },
    '9gr8ck19': {
      'en': '-',
      'tl': '',
    },
    'anco0w5m': {
      'en': 'Date Details',
      'tl': 'Mga Detalye ng Petsa',
    },
    '27rka9jx': {
      'en': 'Date of Planting (DS)',
      'tl': 'Petsa ng Pagtanim (DS)',
    },
    'fp05g6sc': {
      'en': '-',
      'tl': '',
    },
    '3zj0x11r': {
      'en': 'Date of Planting (TP)',
      'tl': 'Petsa ng Pagtatanim (TP)',
    },
    'ipmw8aq2': {
      'en': '-',
      'tl': '',
    },
    'lnj6pjl7': {
      'en': 'Agent Confirmation',
      'tl': 'Kumpirmasyon ng Ahente',
    },
    '966yfol9': {
      'en': 'Remarks',
      'tl': 'Remarks',
    },
    '0m6zk42a': {
      'en': '-',
      'tl': '',
    },
    '7ftdujb6': {
      'en': 'Confirmed By',
      'tl': 'Kinumpirma ni',
    },
    'sg8dshub': {
      'en': '-',
      'tl': '',
    },
    '8bdkh9n1': {
      'en': 'Prepared By',
      'tl': 'Inihanda ni',
    },
    'c148ed4e': {
      'en': '-',
      'tl': '',
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
      'en': 'Re-Submit',
      'tl': '',
    },
    '4jnx5njc': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // ppir
  {
    'k6qjt4aw': {
      'en': 'Geotag',
      'tl': '',
    },
    '3veba0qh': {
      'en': 'Repeat Geotag',
      'tl': '',
    },
    '57upt8rw': {
      'en': 'Download',
      'tl': '',
    },
    'ze2pl4ye': {
      'en': 'Geotag Information',
      'tl': '',
    },
    'n95y5s6i': {
      'en': 'Last Coordinates',
      'tl': '',
    },
    'hae09rgg': {
      'en': 'Total Area',
      'tl': '',
    },
    'tqztw6m9': {
      'en': 'Date Time',
      'tl': '',
    },
    'be7rp1bl': {
      'en': 'Total Hectares',
      'tl': '',
    },
    'y2s7hj5w': {
      'en': 'Farm Location',
      'tl': '',
    },
    'gmc39std': {
      'en': 'Seed Variety',
      'tl': '',
    },
    'jn43drww': {
      'en': 'rice',
      'tl': '',
    },
    'lbxujdxy': {
      'en': 'corn',
      'tl': '',
    },
    '9mikx6ak': {
      'en': 'Select the Type of Rice ',
      'tl': '',
    },
    'o5fvkvth': {
      'en': 'this is the rice',
      'tl': '',
    },
    'nd5lsz8y': {
      'en': 'Please select...',
      'tl': '',
    },
    'uorchiy2': {
      'en': 'Search for an item...',
      'tl': '',
    },
    'lyts6olw': {
      'en': 'Select the Type of Corn ',
      'tl': '',
    },
    '9nnzotiz': {
      'en': 'this is the rice',
      'tl': '',
    },
    'muwach4e': {
      'en': 'Please select...',
      'tl': '',
    },
    'pvvdbdwh': {
      'en': 'Search for an item...',
      'tl': '',
    },
    'hw506fw0': {
      'en': 'Actual Area Planted',
      'tl': '',
    },
    'ult8jtry': {
      'en': 'Actual Date of Planting (DS)',
      'tl': '',
    },
    '5xaja5pg': {
      'en': 'Actual Date of Planting (TP)',
      'tl': '',
    },
    '80o0gacf': {
      'en': 'Remarks',
      'tl': '',
    },
    'lxsn39s5': {
      'en': 'Prepared by',
      'tl': '',
    },
    'p2htj2ad': {
      'en': 'Tap to Signature',
      'tl': '',
    },
    'bf0l7x1o': {
      'en': 'Confirm by',
      'tl': '',
    },
    'wyigefcb': {
      'en': 'Tap to Signature',
      'tl': '',
    },
    'b7688dq2': {
      'en': 'DON\'T DELETE TAT IS TESTING HERE',
      'tl': '',
    },
    'qhfraqcp': {
      'en': 'Cancel',
      'tl': '',
    },
    '85i1pnil': {
      'en': 'Save',
      'tl': '',
    },
    'n9o7a192': {
      'en': 'Submit',
      'tl': '',
    },
    '4ho4omqk': {
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
    '6h2ly5jn': {
      'en': '',
      'tl': '',
    },
    '8h7692fq': {
      'en': 'Find your task...',
      'tl': '',
    },
    'bcsla8bm': {
      'en': 'Option 1',
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
      'en': 'Offline Map',
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
  // taskDetailsCopyx
  {
    'oskk6d39': {
      'en': 'Form Details',
      'tl': '',
    },
    'jgp1qdzg': {
      'en': 'Assignment Id',
      'tl': '',
    },
    'ua2ed6p2': {
      'en': 'Farmer Name',
      'tl': '',
    },
    'gxay60s8': {
      'en': 'Address',
      'tl': '',
    },
    'g90uj4i5': {
      'en': 'Insurance Id',
      'tl': '',
    },
    '8e842nqx': {
      'en': 'Mobile Number',
      'tl': '',
    },
    'g7rnel3m': {
      'en': 'Farmer Type',
      'tl': '',
    },
    '9jazarr0': {
      'en': 'Group Name',
      'tl': '',
    },
    'behrff99': {
      'en': 'Group Address',
      'tl': '',
    },
    'q2xm4uqc': {
      'en': 'Lender Name',
      'tl': '',
    },
    'nrx7s8s0': {
      'en': 'Lender Address',
      'tl': '',
    },
    'zelz7qj7': {
      'en': 'Region',
      'tl': '',
    },
    'okl9uy72': {
      'en': 'CIC Number',
      'tl': '',
    },
    'cft4el2i': {
      'en': 'Farm Location',
      'tl': '',
    },
    '93dpnvby': {
      'en': '',
      'tl': '',
    },
    'k8lxsltp': {
      'en': 'Location Sketch Plan',
      'tl': '',
    },
    '06hp4i6n': {
      'en': 'North',
      'tl': '',
    },
    'w4y1p2tj': {
      'en': 'East',
      'tl': '',
    },
    'vckq82bc': {
      'en': 'South',
      'tl': '',
    },
    'o0rqnyb3': {
      'en': 'West',
      'tl': '',
    },
    'tol4nxo3': {
      'en': 'Location Sketch Plan',
      'tl': '',
    },
    'rw0sh80k': {
      'en': 'Area Planted',
      'tl': '',
    },
    'lnpo3wrz': {
      'en': 'Date of Planting (DS)',
      'tl': '',
    },
    'lpjly72a': {
      'en': 'Datee of Planting (TP)',
      'tl': '',
    },
    'k3if5czh': {
      'en': 'Seed Variety Planted',
      'tl': '',
    },
    '08kgdns5': {
      'en': 'Completed Task  Details',
      'tl': '',
    },
    '3dmm4vvn': {
      'en': 'Tracking Details',
      'tl': '',
    },
    'y8nfprqq': {
      'en': 'Last Coordinates',
      'tl': '',
    },
    'k33o4ljv': {
      'en': 'Track Date',
      'tl': '',
    },
    'thqeur7g': {
      'en': 'Total Area (ha)',
      'tl': '',
    },
    '8tjfp8ru': {
      'en': 'Total Distance',
      'tl': '',
    },
    'h8d78nen': {
      'en': 'Seed Details',
      'tl': '',
    },
    'xy41gm52': {
      'en': 'Type',
      'tl': '',
    },
    'yzp4hxop': {
      'en': 'Variety',
      'tl': '',
    },
    'ub3h3340': {
      'en': 'Date Details',
      'tl': '',
    },
    '4loop0tv': {
      'en': 'Date of Planting (DS)',
      'tl': '',
    },
    'kb0lp36o': {
      'en': 'Date of Planting (TP)',
      'tl': '',
    },
    '5owl6nia': {
      'en': 'Agent Confirmation',
      'tl': '',
    },
    'teqhks3p': {
      'en': 'Remarks',
      'tl': '',
    },
    'ah35yr12': {
      'en': 'Confirmed By',
      'tl': '',
    },
    '3jldlj7l': {
      'en': 'Prepared By',
      'tl': '',
    },
    'whebqhau': {
      'en': 'Geotag',
      'tl': '',
    },
    '1a6n1vqa': {
      'en': 'Continue Form',
      'tl': '',
    },
    '50098527': {
      'en': 'Geotag',
      'tl': '',
    },
    'd4ieef23': {
      'en': 'Resubmit',
      'tl': '',
    },
    'sdd0mquj': {
      'en': 'Re-Submit',
      'tl': '',
    },
    'a5mnvgzd': {
      'en': 'Home',
      'tl': '',
    },
  },
  // onboarding01
  {
    '2hf8uvq6': {
      'en': 'Welcome!',
      'tl': '',
    },
    '5lzr6222': {
      'en': 'Welcome Agent in the PCIC Geotagging Application!',
      'tl': '',
    },
    'byq4vn69': {
      'en': 'Get Started',
      'tl': '',
    },
    '3ckpvaqt': {
      'en': 'My Account',
      'tl': '',
    },
    'e5zj0r88': {
      'en': 'Welcome!',
      'tl': '',
    },
    'sdylopj4': {
      'en': 'Welcome Agent in the PCIC Geotagging Application!',
      'tl': '',
    },
    'ult64d5q': {
      'en': 'Get Started',
      'tl': '',
    },
    'ywz684yl': {
      'en': 'My Account',
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
  // taskDetailsCopyxx
  {
    '0oy9ifrt': {
      'en': 'Form Details',
      'tl': '',
    },
    'k9mlejzv': {
      'en': 'Assignment Id',
      'tl': '',
    },
    'be37kfpd': {
      'en': 'Farmer Name',
      'tl': '',
    },
    'qpvdw1xo': {
      'en': 'Address',
      'tl': '',
    },
    'idrwqmhk': {
      'en': 'Insurance Id',
      'tl': '',
    },
    'al80eo7h': {
      'en': 'Mobile Number',
      'tl': '',
    },
    'tdjrym3l': {
      'en': 'Farmer Type',
      'tl': '',
    },
    '5k0kgydt': {
      'en': 'Group Name',
      'tl': '',
    },
    '0eqe1guh': {
      'en': 'Group Address',
      'tl': '',
    },
    'd63lvet6': {
      'en': 'Lender Name',
      'tl': '',
    },
    'jf76re1s': {
      'en': 'Lender Address',
      'tl': '',
    },
    'l1sklwon': {
      'en': 'Region',
      'tl': '',
    },
    '1490o35z': {
      'en': 'CIC Number',
      'tl': '',
    },
    'nvxfegvp': {
      'en': 'Farm Location',
      'tl': '',
    },
    'ri4glm1o': {
      'en': 'Location Sketch Plan',
      'tl': '',
    },
    '8ori52ax': {
      'en': 'North',
      'tl': '',
    },
    '6jencldj': {
      'en': 'East',
      'tl': '',
    },
    'cxqx741q': {
      'en': 'South',
      'tl': '',
    },
    'ja725isb': {
      'en': 'West',
      'tl': '',
    },
    '3103u0dm': {
      'en': 'Location Sketch Plan',
      'tl': '',
    },
    '2xkh8w0a': {
      'en': 'Area Planted',
      'tl': '',
    },
    'ygnc5zns': {
      'en': 'Date of Planting (DS)',
      'tl': '',
    },
    'cx9ye2yt': {
      'en': 'Datee of Planting (TP)',
      'tl': '',
    },
    'guwa56fo': {
      'en': 'Seed Variety Planted',
      'tl': '',
    },
    'lfrxhmef': {
      'en': 'Completed Task  Details',
      'tl': '',
    },
    '569fwwjg': {
      'en': 'Tracking Details',
      'tl': '',
    },
    '6prx1iyn': {
      'en': 'Last Coordinates',
      'tl': '',
    },
    '8629sgox': {
      'en': 'Track Date',
      'tl': '',
    },
    'g1masszs': {
      'en': 'Total Area (ha)',
      'tl': '',
    },
    'sdjoxl4t': {
      'en': 'Total Distance',
      'tl': '',
    },
    'axrnlqyl': {
      'en': 'Seed Details',
      'tl': '',
    },
    'v9j94qyn': {
      'en': 'Type',
      'tl': '',
    },
    '49imppnf': {
      'en': 'Variety',
      'tl': '',
    },
    '03ju80eo': {
      'en': 'Date Details',
      'tl': '',
    },
    '6gwgytpe': {
      'en': 'Date of Planting (DS)',
      'tl': '',
    },
    'kc1kkytp': {
      'en': 'Date of Planting (TP)',
      'tl': '',
    },
    'bsc4g0yq': {
      'en': 'Agent Confirmation',
      'tl': '',
    },
    'fcisshvt': {
      'en': 'Remarks',
      'tl': '',
    },
    'uap105un': {
      'en': 'Confirmed By',
      'tl': '',
    },
    'rlo83szj': {
      'en': 'Prepared By',
      'tl': '',
    },
    '6key2kle': {
      'en': 'Geotag',
      'tl': '',
    },
    '1cv0g8k6': {
      'en': 'Geotag',
      'tl': '',
    },
    '13wgcmqb': {
      'en': 'Continue Form',
      'tl': '',
    },
    'rlzcpz01': {
      'en': 'Resubmit',
      'tl': '',
    },
    'wmv2zwgj': {
      'en': 'Re-Submit',
      'tl': '',
    },
    '9by11dqq': {
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
  // alertDialog
  {
    '4poy7kn4': {
      'en': 'Info',
      'tl': '',
    },
    '5w0hrwzw': {
      'en':
          'The current gpx file will be deleted. \nAre you sure you want to continue?',
      'tl': '',
    },
    'ma51aika': {
      'en': 'CANCEL',
      'tl': '',
    },
    'z8ore9hv': {
      'en': 'CONTINUE',
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
    'o9ko1105': {
      'en': 'Reconnect',
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
