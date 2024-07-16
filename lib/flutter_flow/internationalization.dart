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
    'jt05juc8': {
      'en': 'Login',
      'tl': '',
    },
    '732ldtxr': {
      'en': 'Please sign in to continue',
      'tl': '',
    },
    'zrugc18v': {
      'en': 'Please enter your email address',
      'tl': '',
    },
    'wwu2ppy8': {
      'en': 'Enter your password',
      'tl': '',
    },
    '55s98hwg': {
      'en': 'Login',
      'tl': '',
    },
    'es23frz3': {
      'en': 'Forgot Password?',
      'tl': '',
    },
    'wg8l5x4u': {
      'en': 'Home',
      'tl': '',
    },
  },
  // profile
  {
    'klihs5ae': {
      'en': 'Switch to Dark Mode',
      'tl': '',
    },
    'yau913co': {
      'en': 'Switch to Light Mode',
      'tl': '',
    },
    '2ul2xenc': {
      'en': 'Account Settings',
      'tl': '',
    },
    'hrbpg65x': {
      'en': 'Change Password',
      'tl': '',
    },
    '1nrn06bw': {
      'en': 'Edit Profile',
      'tl': '',
    },
    'eo4s9jju': {
      'en': 'Log Out',
      'tl': '',
    },
    'wqj3hsrh': {
      'en': 'Profile',
      'tl': '',
    },
    'kcupitz3': {
      'en': '__',
      'tl': '',
    },
  },
  // chats
  {
    'y0w2rxtr': {
      'en': 'Below are messages with your friends.',
      'tl': '',
    },
    '6gdbj059': {
      'en':
          'This was really great, i\'m so glad that we could  catchup this weekend.',
      'tl': '',
    },
    'yq8kfovp': {
      'en': 'Messages',
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
    '8gn7gyn6': {
      'en':
          'We will reset your password. Please enter the password and confirmation password below, and then confirm.',
      'tl': '',
    },
    '8czpn5by': {
      'en': 'Old Password',
      'tl': '',
    },
    'ymf9vfxa': {
      'en': 'Enter Old Password...',
      'tl': '',
    },
    'shhywakx': {
      'en': 'New Password',
      'tl': '',
    },
    'v83gfzii': {
      'en': 'Enter New Password...',
      'tl': '',
    },
    'ay6qixx3': {
      'en': 'Confirm Password',
      'tl': '',
    },
    'rnbffd2o': {
      'en': 'Confirm New Password...',
      'tl': '',
    },
    '95gjq5pg': {
      'en': 'Confirm Changes',
      'tl': '',
    },
    'f8nam65m': {
      'en':
          'We will reset your password. Please enter the password and confirmation password below, and then confirm.',
      'tl': '',
    },
    'lzuqa0w8': {
      'en': 'Old Password',
      'tl': '',
    },
    'ricrz5ul': {
      'en': 'Enter Old Password...',
      'tl': '',
    },
    'ryc7q1bn': {
      'en': 'New Password',
      'tl': '',
    },
    'ys7x94x3': {
      'en': 'Enter New Password...',
      'tl': '',
    },
    'kpj4y9s2': {
      'en': 'Confirm Password',
      'tl': '',
    },
    '7412oguu': {
      'en': 'Confirm New Password...',
      'tl': '',
    },
    'b9rmlc3s': {
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
    'r4at3e87': {
      'en': 'Back',
      'tl': '',
    },
    'zxojetjq': {
      'en': 'Home',
      'tl': '',
    },
  },
  // geotag
  {
    'pkpqltl8': {
      'en': 'Start',
      'tl': '',
    },
    'nu29o86l': {
      'en': 'Stop',
      'tl': '',
    },
    'f2po16v3': {
      'en': 'Geotag',
      'tl': '',
    },
    'zylazy17': {
      'en': 'Location',
      'tl': '',
    },
    '84gcw4vd': {
      'en': 'Data',
      'tl': '',
    },
    'cnjmpf7g': {
      'en': 'Geotagiging Status',
      'tl': '',
    },
    'dr5lt5bq': {
      'en': 'Start = ',
      'tl': '',
    },
    '3j41u30c': {
      'en': 'Farmer',
      'tl': '',
    },
    'orn89csd': {
      'en': '-',
      'tl': '',
    },
    'jr3ttmbd': {
      'en': '-',
      'tl': '',
    },
    't1wzhx1o': {
      'en': '-',
      'tl': '',
    },
    'iu8si2g9': {
      'en': '-',
      'tl': '',
    },
    'i5dlnb98': {
      'en': 'Form',
      'tl': '',
    },
    'xhdkna2k': {
      'en': '-',
      'tl': '',
    },
    '9bpfk3kg': {
      'en': '-',
      'tl': '',
    },
    'd6unw9y8': {
      'en': '-',
      'tl': '',
    },
    'wqm0d69x': {
      'en': '-',
      'tl': '',
    },
    '0o8w3vlv': {
      'en': 'Home',
      'tl': '',
    },
  },
  // task_details
  {
    'k4p9gns5': {
      'en': 'Form Details',
      'tl': '',
    },
    'v8dtt2vs': {
      'en': 'Assignment Id',
      'tl': '',
    },
    '6mzh2uon': {
      'en': 'Farmer Name',
      'tl': '',
    },
    'umpaaiis': {
      'en': 'Address',
      'tl': '',
    },
    'd2ykgn36': {
      'en': 'Insurance Id',
      'tl': '',
    },
    'ysis00n8': {
      'en': 'Mobile Number',
      'tl': '',
    },
    '7ccgy9wz': {
      'en': 'Farmer Type',
      'tl': '',
    },
    't6o265ng': {
      'en': 'Group Name',
      'tl': '',
    },
    'tahfceh8': {
      'en': 'Group Address',
      'tl': '',
    },
    '22hrwz9g': {
      'en': 'Lender Name',
      'tl': '',
    },
    'fuslprag': {
      'en': 'Lender Address',
      'tl': '',
    },
    'pm9qvc0q': {
      'en': 'Region',
      'tl': '',
    },
    'fpmzxpbt': {
      'en': 'MAR - Region',
      'tl': '',
    },
    '3gw4pxgd': {
      'en': 'Farm Location',
      'tl': '',
    },
    'ezrkfc7v': {
      'en': 'CIC Number',
      'tl': '',
    },
    '6t1xvbcc': {
      'en': 'Location Sketch Plan',
      'tl': '',
    },
    'jsqnnkid': {
      'en': 'North',
      'tl': '',
    },
    '8wbopula': {
      'en': 'East',
      'tl': '',
    },
    '01yqjqhm': {
      'en': 'South',
      'tl': '',
    },
    'cdxsxifv': {
      'en': 'West',
      'tl': '',
    },
    '8eqbqtc0': {
      'en': 'Location Sketch Plan',
      'tl': '',
    },
    '9i4y79o7': {
      'en': 'Area Planted',
      'tl': '',
    },
    '9071utka': {
      'en': 'Date of Planting (DS)',
      'tl': '',
    },
    'oqv0po4g': {
      'en': 'Datee of Planting (TP)',
      'tl': '',
    },
    '7olr9ewi': {
      'en': 'Seed Variety Planted',
      'tl': '',
    },
    'jlh6u081': {
      'en': 'Completed Task  Details',
      'tl': '',
    },
    'n3mnsnhx': {
      'en': 'Tracking Details',
      'tl': '',
    },
    'w10i6i6m': {
      'en': 'Last Coordinates',
      'tl': '',
    },
    '2p949smk': {
      'en': 'Track Date',
      'tl': '',
    },
    'm5djaddp': {
      'en': 'Total Area (ha)',
      'tl': '',
    },
    '86v4vmu0': {
      'en': 'Total Distance',
      'tl': '',
    },
    '3skiq927': {
      'en': 'Seed Details',
      'tl': '',
    },
    'me0xag6p': {
      'en': 'Type',
      'tl': '',
    },
    'iue8io53': {
      'en': 'Variety',
      'tl': '',
    },
    'bqgsxsrk': {
      'en': 'Date Details',
      'tl': '',
    },
    'bqak90cm': {
      'en': 'Date of Planting (DS)',
      'tl': '',
    },
    'qiuljlpt': {
      'en': 'Date of Planting (TP)',
      'tl': '',
    },
    'b6l66gp3': {
      'en': 'Agent Confirmation',
      'tl': '',
    },
    'f2g23lnf': {
      'en': 'Remarks',
      'tl': '',
    },
    '9429900j': {
      'en': 'Confirmed By',
      'tl': '',
    },
    'iph48t8e': {
      'en': 'Signature',
      'tl': '',
    },
    '92jn45m4': {
      'en': 'Prepared By',
      'tl': '',
    },
    '0jg7r026': {
      'en': 'Signature',
      'tl': '',
    },
    'ofswtz4e': {
      'en': 'Geotag',
      'tl': '',
    },
    '3z0jjcg8': {
      'en': 'Recorded',
      'tl': '',
    },
    'mw8epesl': {
      'en': 'Actions here (',
      'tl': '',
    },
    '5u67akkk': {
      'en': 'Geotag',
      'tl': '',
    },
    '4papqutb': {
      'en': 'Task Details',
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
    'nmjyhx0m': {
      'en': 'Corn Options',
      'tl': '',
    },
    'niuf5yh1': {
      'en': 'Please select...',
      'tl': '',
    },
    '7v7xn67o': {
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
    'vp0zoc5w': {
      'en': 'Signatures',
      'tl': '',
    },
    '99efrqt6': {
      'en': 'Actual Date of Plantin (DS)',
      'tl': '',
    },
    '762st5cb': {
      'en': 'Remarks',
      'tl': '',
    },
    '8zawh1wx': {
      'en': 'Actual Date of Plantin (TP)',
      'tl': '',
    },
    'alw8i4ys': {
      'en': 'Cancel',
      'tl': '',
    },
    'te54zxo0': {
      'en': 'Save',
      'tl': '',
    },
    '4ho4omqk': {
      'en': 'Home',
      'tl': '',
    },
  },
  // success
  {
    '0g4vu9er': {
      'en': 'Congrats!',
      'tl': '',
    },
    '4pa6ldza': {
      'en': 'Tasks Submitted',
      'tl': '',
    },
    'ai3ttl34': {
      'en': 'You completed a task from:',
      'tl': '',
    },
    'fa57m321': {
      'en': 'joemar@domain.com',
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
    'k0kesbjh': {
      'en': 'Welcome',
      'tl': '',
    },
    'u6gemicl': {
      'en': 'Good morning ',
      'tl': '',
    },
    'umzkjxbm': {
      'en': '!',
      'tl': '',
    },
    '3j3z3g1c': {
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
    'ld4fzlai': {
      'en': 'Completed',
      'tl': '',
    },
    '177zd66x': {
      'en': 'For Dispatch',
      'tl': '',
    },
    '48zqsd5y': {
      'en': 'Ongoing',
      'tl': '',
    },
    'sq6fc48l': {
      'en': 'Completed',
      'tl': '',
    },
    'xkyxse1s': {
      'en': 'For Dispatch',
      'tl': '',
    },
    'bfdm0w23': {
      'en': 'Ongoing',
      'tl': '',
    },
    'qw8wzlx9': {
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
    'nu2n1800': {
      'en': 'My Tasks',
      'tl': '',
    },
    'd1a9eor7': {
      'en': 'Find your task...',
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
    'w2vfxllh': {
      'en': 'For Dispatch',
      'tl': '',
    },
    '1kfbj74g': {
      'en': 'Ongoing',
      'tl': '',
    },
    '75sfmuuv': {
      'en': 'Completed',
      'tl': '',
    },
    '8f6ijlwy': {
      'en': 'For Dispatch',
      'tl': '',
    },
    'n9x0ua1h': {
      'en': 'Ongoing',
      'tl': '',
    },
    '18ta8q88': {
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
  // messagesCopy
  {
    'loncu578': {
      'en': 'Type here to respond...',
      'tl': '',
    },
    '8ujlz6e0': {
      'en': 'Home',
      'tl': '',
    },
  },
  // tasks
  {
    'j0q6t8qb': {
      'en': 'N:',
      'tl': '',
    },
    'kdar2g2n': {
      'en': 'W:',
      'tl': '',
    },
    'b2p4m05y': {
      'en': 'S:',
      'tl': '',
    },
    '8zz0rgpr': {
      'en': 'E:',
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
  // toast
  {
    'gkhial38': {
      'en': 'Notification Title',
      'tl': '',
    },
    '7xn0va3a': {
      'en': 'Some body copy that is present in this small notification.',
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
    '5i1rsq7x': {
      'en': '',
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
