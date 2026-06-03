class AppConstants {
  AppConstants._();

  // ── Border radii ─────────────────────────────────────────
  static const double rXs = 8.0;
  static const double rSm = 12.0;
  static const double rMd = 16.0;
  static const double rLg = 20.0;
  static const double rXl = 28.0;
  static const double rPill = 999.0;

  // ── Spacing (8px grid) ───────────────────────────────────
  static const double sp1 = 4.0;
  static const double sp2 = 8.0;
  static const double sp3 = 12.0;
  static const double sp4 = 16.0;
  static const double sp5 = 20.0;
  static const double sp6 = 24.0;
  static const double sp8 = 32.0;

  // ── Categories ───────────────────────────────────────────
  static const List<Map<String, String>> categories = [
    {'key': 'id',   'label': 'ID Card',       'icon': 'credit_card'},
    {'key': 'wal',  'label': 'Wallet',        'icon': 'account_balance_wallet'},
    {'key': 'key',  'label': 'Keys',          'icon': 'key'},
    {'key': 'book', 'label': 'Books & Notes', 'icon': 'menu_book'},
    {'key': 'elec', 'label': 'Electronics',   'icon': 'devices'},
    {'key': 'calc', 'label': 'Calculator',    'icon': 'calculate'},
    {'key': 'usb',  'label': 'USB Drive',     'icon': 'usb'},
    {'key': 'bag',  'label': 'Bag',           'icon': 'backpack'},
    {'key': 'sta',  'label': 'Stationery',    'icon': 'edit'},
    {'key': 'clo',  'label': 'Clothing',      'icon': 'checkroom'},
    {'key': 'oth',  'label': 'Other',         'icon': 'label'},
  ];

  // ── Campus locations ─────────────────────────────────────
  static const List<String> locations = [
    'Block A',
    'Block B',
    'Block C-1',
    'Block C-2',
    'NIC',
    'Saigon',
    'Usmania',
    'Blue Chip Lab',
    'Roof Top',
    'Road stoves',
    'Admin Block',
    'Buitems Clinic',
    'Architecture Block',
    'Library',
    'Mid canteen',
    'Tuck Shop',
    'OAG Hall',
    'JICA Hall',
    'Expo',
    'Mosque',
    'Girls Hostel',
    'Quaid e Azam Hall',
    'Iqbal Hall',
    'Sports Complex',
    'Markhor Auditorium',
    'Futsal',
    'Football Ground',
    'Cricket Ground',
  ];

  // ── Item statuses ────────────────────────────────────────
  static const List<String> statuses = ['Active', 'Claimed', 'Returned', 'Closed'];

  // ── Departments ──────────────────────────────────────────
  static const List<Map<String, String>> departments = [
    {'value': 'cs',  'label': 'Computer Science'},
    {'value': 'ee',  'label': 'Electrical Engineering'},
    {'value': 'me',  'label': 'Mechanical Engineering'},
    {'value': 'ce',  'label': 'Civil Engineering'},
    {'value': 'sw',  'label': 'Software Engineering'},
    {'value': 'ba',  'label': 'Business Administration'},
    {'value': 'mg',  'label': 'Management Sciences'},
  ];

  // ── Semesters ────────────────────────────────────────────
  static const List<String> semesters = [
    '1st Semester', '2nd Semester', '3rd Semester', '4th Semester',
    '5th Semester', '6th Semester', '7th Semester', '8th Semester',
  ];

  // ── Date options ─────────────────────────────────────────
  static const List<String> dateOptions = [
    'Today', 'Yesterday', '2 days ago', '3 days ago', 'This week', 'Earlier',
  ];
}
