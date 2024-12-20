class AppConfig {
  static const Map<String, int> schoolStart = {
    'hour': 7,
    'minute': 0
  };

  static const Map<String, int> presenceStart = {
    'hour': 6,
    'minute': 0
  };

  // static const List<String> schTime = [
  //   '07:30-09:10',
  //   '09:10-10:30',
  //   '10:30-12:00',
  //   '12:00-13:40',
  //   '13:40-14:30'
  // ];

  static const List<String> permissionCategory = [
    'Izin',
    'Sakit'
  ];

  static const List<String> division = [
    'Lapangan'
  ];

  static const Map<String, double> validLoc = {
    'lat': -6.1750,
    'lng': 106.8275
  };

  static const double presenceRadius = 100000;
}