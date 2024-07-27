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
      'tl': 'Mag log in',
    },
    'onarar2h': {
      'en': 'Please sign in to continue',
      'tl': 'Mangyaring mag-sign in upang magpatuloy',
    },
    'js4zrnhp': {
      'en': 'Enter your email address',
      'tl': 'ilagay ang iyong email address',
    },
    '5i1rsq7x': {
      'en': '',
      'tl': '',
    },
    'tei5629d': {
      'en': 'Enter your password',
      'tl': 'Ipasok ang iyong password',
    },
    'bws7du9e': {
      'en': 'Login',
      'tl': 'Mag log in',
    },
    'qpfpmvtl': {
      'en': 'Forgot Password?',
      'tl': 'Nakalimutan ang password?',
    },
    'w45297gi': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'yc7u2stc': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'g6x5ocx1': {
      'en': 'Field is required',
      'tl': 'Kinakailangan ang field',
    },
    'mpoif9dk': {
      'en': 'Password must be atleast 8 characters',
      'tl': 'Hindi dapat bababa sa 8 character ang password',
    },
    '97dgo696': {
      'en': 'Please choose an option from the dropdown',
      'tl': 'Mangyaring pumili ng opsyon mula sa dropdown',
    },
    'wg8l5x4u': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // profile
  {
    'wqj3hsrh': {
      'en': 'Profile',
      'tl': 'Profile',
    },
    '8cppvoty': {
      'en': 'Account Settings',
      'tl': 'Mga Setting ng Account',
    },
    '11dsrxu6': {
      'en': 'Switch to Dark Mode',
      'tl': 'Lumipat sa Dark Mode',
    },
    '3uy0o9hw': {
      'en': 'Switch to Light Mode',
      'tl': 'Lumipat sa Light Mode',
    },
    '4ibmae0j': {
      'en': 'Edit Profile',
      'tl': 'Ibahin ang profile',
    },
    'zqsohbrx': {
      'en': 'Change Password',
      'tl': 'Palitan ANG password',
    },
    'buokrewg': {
      'en': 'Log Out',
      'tl': 'Log Out',
    },
    'kcupitz3': {
      'en': '__',
      'tl': '__',
    },
  },
  // chats
  {
    'yq8kfovp': {
      'en': 'Messages',
      'tl': 'Mga mensahe',
    },
    '8hlwocb6': {
      'en': 'Below are messages with your friends.',
      'tl': 'Nasa ibaba ang mga mensahe sa iyong mga kaibigan.',
    },
    'gcfnxasp': {
      'en': 'Below are messages with your friends.',
      'tl': 'Nasa ibaba ang mga mensahe sa iyong mga kaibigan.',
    },
    'qjs4iqx3': {
      'en': '__',
      'tl': '__',
    },
  },
  // editPassword
  {
    'igo0j7mh': {
      'en': 'Change Password',
      'tl': 'Palitan ANG password',
    },
    'rqho0nbl': {
      'en':
          'We will reset your password. Please enter the password and confirmation password below, and then confirm.',
      'tl':
          'Ire-reset namin ang iyong password. Mangyaring ipasok ang password at password sa pagkumpirma sa ibaba, at pagkatapos ay kumpirmahin.',
    },
    'jsat8wzg': {
      'en': 'Old Password',
      'tl': 'Lumang password',
    },
    '9qdzutxx': {
      'en': 'Enter Old Password...',
      'tl': 'Ilagay ang Lumang Password...',
    },
    '6i3l397c': {
      'en': 'New Password',
      'tl': 'Bagong Password',
    },
    'h4q8epxo': {
      'en': 'Enter New Password...',
      'tl': 'Maglagay ng Bagong Password...',
    },
    'gfj61loc': {
      'en': 'Confirm Password',
      'tl': 'Kumpirmahin ang Password',
    },
    'h1tl8jic': {
      'en': 'Confirm New Password...',
      'tl': 'Kumpirmahin ang bagong password...',
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
    '5fv645iv': {
      'en': 'Edit Profile',
      'tl': 'Ibahin ang profile',
    },
    'r9vm5mt1': {
      'en': 'Your Name',
      'tl': 'Ang pangalan mo',
    },
    'ntj2ozhk': {
      'en': 'Save Changes',
      'tl': 'I-save ang mga pagbabago',
    },
  },
  // messages
  {
    'emndaizi': {
      'en': 'Type here to respond...',
      'tl': 'Mag-type dito para tumugon...',
    },
    'rbq8h8d1': {
      'en': 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
      'tl':
          'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
    },
    'yav59de8': {
      'en': 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
      'tl':
          'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
    },
    'zxojetjq': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // taskDetails
  {
    'x1jz4y0y': {
      'en': 'Task Details',
      'tl': 'Mga Detalye ng Gawain',
    },
    'ihmcvc23': {
      'en': 'This task is completed',
      'tl': 'Nakumpleto ang gawaing ito',
    },
    'j9rxgs8h': {
      'en': 'Form Details',
      'tl': 'Mga Detalye ng Form',
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
    'zm252mzp': {
      'en': '',
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
      'en': 'Datee of Planting (TP)',
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
    'tjm5ey7c': {
      'en': 'Signature',
      'tl': 'Lagda',
    },
    '8bdkh9n1': {
      'en': 'Prepared By',
      'tl': 'Inihanda ni',
    },
    'aq1euelx': {
      'en': 'Signature',
      'tl': 'Lagda',
    },
    'ahzx9d2y': {
      'en': 'Geotag',
      'tl': 'Geotag',
    },
    '096k25yu': {
      'en': 'Recorded',
      'tl': 'Naitala',
    },
    'e0abx8jq': {
      'en': 'Actions',
      'tl': 'Mga aksyon',
    },
    'g06chmkk': {
      'en': 'Continue Form',
      'tl': 'Ipagpatuloy ang Form',
    },
    '63201k0m': {
      'en': 'Geotag',
      'tl': 'Geotag',
    },
    'm6egon7b': {
      'en': 'Resubmit',
      'tl': 'Muling isumite',
    },
    '4jnx5njc': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // ppir
  {
    'erm3i53g': {
      'en': 'PPIR Form',
      'tl': 'Form ng PPIR',
    },
    '3s84cgqw': {
      'en': 'Geotag Information',
      'tl': 'Impormasyon sa Geotag',
    },
    '4o9qvz6v': {
      'en': 'Last Coordinates',
      'tl': 'Mga Huling Coordinate',
    },
    'oflb4doq': {
      'en': 'Date Time',
      'tl': 'Petsa Oras',
    },
    'li1l6k0w': {
      'en': 'Total Hectares',
      'tl': 'Kabuuang Ektarya',
    },
    'irvio488': {
      'en': 'Farm Location',
      'tl': 'Lokasyon ng Bukid',
    },
    'oi19exk2': {
      'en': 'Geotag Control',
      'tl': 'Geotag Control',
    },
    'bi2tyefd': {
      'en': 'Repeat Again',
      'tl': 'Ulitin Muli',
    },
    'w3oxp9o9': {
      'en': 'View Geotag',
      'tl': 'Tingnan ang Geotag',
    },
    'quqb1avc': {
      'en': 'Seed Variety',
      'tl': 'Iba\'t-ibang Binhi',
    },
    'wt2nxkv8': {
      'en': 'rice',
      'tl': 'kanin',
    },
    '3zzenggt': {
      'en': 'corn',
      'tl': 'mais',
    },
    'e3nzk0t1': {
      'en': 'Select the Type of Rice ',
      'tl': 'Piliin ang Uri ng Bigas',
    },
    'a7yszlux': {
      'en': 'this is the rice',
      'tl': 'ito ang bigas',
    },
    'hgkqza7h': {
      'en': 'Please select...',
      'tl': 'Pakipili...',
    },
    'za7pn038': {
      'en': 'Search for an item...',
      'tl': 'Maghanap ng item...',
    },
    'uj8vq3kw': {
      'en': 'Select the Type of Corn ',
      'tl': 'Piliin ang Uri ng Mais',
    },
    'kd2ri9yq': {
      'en': 'this is the rice',
      'tl': 'ito ang bigas',
    },
    'f7j9hfpn': {
      'en': 'Please select...',
      'tl': 'Pakipili...',
    },
    'rxggzdj9': {
      'en': 'Search for an item...',
      'tl': 'Maghanap ng item...',
    },
    '4x78xwmh': {
      'en': 'Actual Area Planted',
      'tl': 'Aktwal na Lugar na Nakatanim',
    },
    'dbhyempf': {
      'en': 'Actual Date of Planting (DS)',
      'tl': 'Aktwal na Petsa ng Pagtatanim (DS)',
    },
    'msrak9du': {
      'en': 'Actual Date of Planting (TP)',
      'tl': 'Aktwal na Petsa ng Pagtatanim (TP)',
    },
    '762st5cb': {
      'en': 'Remarks',
      'tl': 'Remarks',
    },
    '99efrqt6': {
      'en': 'Prepared by',
      'tl': 'Inihanda ni',
    },
    '8zawh1wx': {
      'en': 'Confirm by',
      'tl': 'Kumpirmahin ni',
    },
    'vxop43vj': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    'kyab355w': {
      'en': 'Save',
      'tl': 'I-save',
    },
    '7i7p5yr3': {
      'en': 'Submit',
      'tl': 'Ipasa',
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
      'en': 'Tasks ',
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
    'ek6mnpyv': {
      'en': 'Welcome',
      'tl': 'Maligayang pagdating',
    },
    'kqdeja9y': {
      'en': 'Good morning ',
      'tl': 'Magandang umaga',
    },
    'c9cu64hs': {
      'en': '!',
      'tl': '!',
    },
    'vte71nhh': {
      'en': 'Task Overview',
      'tl': 'Pangkalahatang-ideya ng Gawain',
    },
    'm10j35jr': {
      'en': 'For Dispatch',
      'tl': 'Para sa Dispatch',
    },
    'x0uyqjdj': {
      'en': 'Ongoing',
      'tl': 'Patuloy',
    },
    'v1rudbl9': {
      'en': 'Completed',
      'tl': 'Nakumpleto',
    },
    'ngstgmic': {
      'en': 'Find your task...',
      'tl': '',
    },
    'u6l06te5': {
      'en': 'Option 1',
      'tl': '',
    },
    '40z3ewor': {
      'en': 'For Dispatch',
      'tl': 'Para sa Dispatch',
    },
    'eqlfjogs': {
      'en': 'Ongoing',
      'tl': 'Patuloy',
    },
    'i9ibpnoq': {
      'en': 'Completed',
      'tl': 'Nakumpleto',
    },
    'xfnacy2o': {
      'en': 'geotag',
      'tl': '',
    },
    '67jgj8w9': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // mapTesting
  {
    'p5a4ilu5': {
      'en': 'Testing Map',
      'tl': 'Mapa ng Pagsubok',
    },
    'hdh6xlcb': {
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
  // marApiTest
  {
    '0ov0kosw': {
      'en': 'API Tester',
      'tl': 'API Tester',
    },
    'lgzgz3y8': {
      'en': 'Test API Calls',
      'tl': 'Subukan ang Mga Tawag sa API',
    },
    'u0bh28ib': {
      'en': 'Test GET',
      'tl': 'Subukan ang GET',
    },
    'y9wod308': {
      'en': 'Test POST',
      'tl': 'Subukan ang POST',
    },
    'lh091m1k': {
      'en': 'Test PUT',
      'tl': 'Subukan ang PUT',
    },
    '05jb6auu': {
      'en': 'Test DELETE',
      'tl': 'Subukan ang DELETE',
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
      'en': 'Your email address...',
      'tl': 'Ang iyong email address...',
    },
    'a29ygr1c': {
      'en': 'Enter your email...',
      'tl': 'Ilagay ang iyong email...',
    },
    'x3d82sua': {
      'en': 'Send Link',
      'tl': 'Magpasa ng link',
    },
    '2stfj7a7': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // geotagging
  {
    'wkawnowa': {
      'en': 'Loc',
      'tl': 'Lat',
    },
    'yp5wp81q': {
      'en': 'Lat',
      'tl': '',
    },
    'lvzg53kl': {
      'en': 'Lng',
      'tl': 'Lng',
    },
    'qx4ly86s': {
      'en': 'Address',
      'tl': 'Address',
    },
    '5rckehtu': {
      'en': 'Assignment Id',
      'tl': 'Assignment Id',
    },
    'brrixmb6': {
      'en': 'Start',
      'tl': 'Tapusin',
    },
    'pstdbhmc': {
      'en': 'Finish',
      'tl': 'Tapusin',
    },
    '0o8w3vlv': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // otherForm
  {
    'fa31tvpx': {
      'en': 'Area 69',
      'tl': 'Lugar 69',
    },
    '9ctwde8e': {
      'en': 'Mar said, This is under maintenance!',
      'tl': 'Sabi ni Mar, Under maintenance ito!',
    },
    'z8fvrgds': {
      'en': 'Home',
      'tl': 'Bahay',
    },
  },
  // sss
  {
    'yigfujp5': {
      'en': 'Page Title',
      'tl': '',
    },
    'p5v52glk': {
      'en': 'Home',
      'tl': '',
    },
  },
  // tasks
  {
    'j0q6t8qb': {
      'en': 'North: ',
      'tl': 'Hilaga:',
    },
    'kdar2g2n': {
      'en': 'West: ',
      'tl': 'Kanluran:',
    },
    'b2p4m05y': {
      'en': 'South: ',
      'tl': 'Timog:',
    },
    '8zz0rgpr': {
      'en': 'East: ',
      'tl': 'Silangan:',
    },
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
  // userCard
  {
    'q2srxkm7': {
      'en': 'UserName',
      'tl': 'UserName',
    },
    'e7kvimdo': {
      'en': 'Subtitle',
      'tl': 'Subtitle',
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
    'fts37cq3': {
      'en': 'Clear',
      'tl': 'Maaliwalas',
    },
    '6si6e5tk': {
      'en': 'Cancel',
      'tl': 'Kanselahin',
    },
    'a0f7s2dm': {
      'en': 'Save',
      'tl': 'I-save',
    },
  },
  // Miscellaneous
  {
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
