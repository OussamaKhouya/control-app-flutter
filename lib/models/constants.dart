class AppConfig {
  static const String appName = 'MyApp';
  static const String apiUrl = 'https://api.example.com';
}

class UIConstants {
  static const double defaultFontSize = 16.0;
  static const int maxAttempts = 5;
}

class RoleConstants {
  static const String control1 = 'CONTROL1';
  static const String control2 = 'CONTROL2';
  static const String commercial = 'COMMERCIAL';
  static const String saisie = 'SAISIE';
  static const String admin = 'ADMIN';
}

class PermConstants {
  static const String SHOW_TXT_Q1 = "SHOW_TXT_Q1";
  static const String SHOW_TXT_Q2 = "SHOW_TXT_Q2";
  static const String SHOW_TXT_OBS1 = "SHOW_TXT_OBS1";
  static const String SHOW_TXT_OBS2 = "SHOW_TXT_OBS2";
  static const String ENABLE_TXT_Q1 = "ENABLE_TXT_Q1";
  static const String ENABLE_TXT_Q2 = "ENABLE_TXT_Q2";
  static const String ENABLE_TXT_OBS1 = "ENABLE_TXT_OBS1";
  static const String ENABLE_TXT_OBS2 = "ENABLE_TXT_OBS2";
  static const String SHOW_BTN_MODIF = "SHOW_BTN_MODIF";
  static const String SHOW_BTN_GALLERY = "SHOW_BTN_GALLERY";
  static const String SHOW_BTN_CAMERA = "SHOW_BTN_CAMERA";
  static const String SHOW_BTN_UPLOAD = "SHOW_BTN_UPLOAD";
  static const String SHOW_BTN_SAVE = "SHOW_BTN_SAVE";
  static const String SHOW_BTN_VER = "SHOW_BTN_VER";
  static const String UPLOAD_IMG_INITIALS = "UPLOAD_IMG_INITIALS";
}

class Permissions {
  static const Map<String, Map<String, dynamic>> p = {
    RoleConstants.admin: {
      PermConstants.SHOW_TXT_Q1: true,
      PermConstants.SHOW_TXT_Q2: true,
      PermConstants.SHOW_TXT_OBS1: true,
      PermConstants.SHOW_TXT_OBS2: true,
      PermConstants.ENABLE_TXT_Q1: true,
      PermConstants.ENABLE_TXT_Q2: true,
      PermConstants.ENABLE_TXT_OBS1: true,
      PermConstants.ENABLE_TXT_OBS2: true,
      PermConstants.SHOW_BTN_MODIF: true,
      PermConstants.SHOW_BTN_GALLERY: true,
      PermConstants.SHOW_BTN_CAMERA: true,
      PermConstants.SHOW_BTN_UPLOAD: true,
      PermConstants.SHOW_BTN_SAVE: true,
      PermConstants.SHOW_BTN_VER: true,
      PermConstants.UPLOAD_IMG_INITIALS: "c",
    },
    RoleConstants.control1: {
      PermConstants.SHOW_TXT_Q1: true,
      PermConstants.SHOW_TXT_Q2: false,
      PermConstants.SHOW_TXT_OBS1: true,
      PermConstants.SHOW_TXT_OBS2: false,
      PermConstants.ENABLE_TXT_Q1: true,
      PermConstants.ENABLE_TXT_Q2: false,
      PermConstants.ENABLE_TXT_OBS1: true,
      PermConstants.ENABLE_TXT_OBS2: false,
      PermConstants.SHOW_BTN_MODIF: true,
      PermConstants.SHOW_BTN_GALLERY: false,
      PermConstants.SHOW_BTN_CAMERA: true,
      PermConstants.SHOW_BTN_UPLOAD: true,
      PermConstants.SHOW_BTN_SAVE: false,
      PermConstants.SHOW_BTN_VER: false,
      PermConstants.UPLOAD_IMG_INITIALS: "c1",
    },
    RoleConstants.control2: {
      PermConstants.SHOW_TXT_Q1: false,
      PermConstants.SHOW_TXT_Q2: true,
      PermConstants.SHOW_TXT_OBS1: false,
      PermConstants.SHOW_TXT_OBS2: true,
      PermConstants.ENABLE_TXT_Q1: false,
      PermConstants.ENABLE_TXT_Q2: true,
      PermConstants.ENABLE_TXT_OBS1: false,
      PermConstants.ENABLE_TXT_OBS2: true,
      PermConstants.SHOW_BTN_MODIF: true,
      PermConstants.SHOW_BTN_GALLERY: false,
      PermConstants.SHOW_BTN_CAMERA: true,
      PermConstants.SHOW_BTN_UPLOAD: true,
      PermConstants.SHOW_BTN_SAVE: false,
      PermConstants.SHOW_BTN_VER: true,
      PermConstants.UPLOAD_IMG_INITIALS: "c2",
    },
    RoleConstants.commercial: {
      PermConstants.SHOW_TXT_Q1: true,
      PermConstants.SHOW_TXT_Q2: true,
      PermConstants.SHOW_TXT_OBS1: true,
      PermConstants.SHOW_TXT_OBS2: true,
      PermConstants.ENABLE_TXT_Q1: false,
      PermConstants.ENABLE_TXT_Q2: false,
      PermConstants.ENABLE_TXT_OBS1: false,
      PermConstants.ENABLE_TXT_OBS2: false,
      PermConstants.SHOW_BTN_MODIF: false,
      PermConstants.SHOW_BTN_GALLERY: false,
      PermConstants.SHOW_BTN_CAMERA: false,
      PermConstants.SHOW_BTN_UPLOAD: false,
      PermConstants.SHOW_BTN_SAVE: false,
      PermConstants.SHOW_BTN_VER: false,
      PermConstants.UPLOAD_IMG_INITIALS: "c",

    },
  };
}
