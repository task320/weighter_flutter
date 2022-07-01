import 'package:intl/intl.dart';

class ItemYearMonth {
  int _year = 0;
  int _month = 0;

  NumberFormat nf2digit = NumberFormat("00");

  ItemYearMonth(int year, int month) {
    _year = year;
    _month = month;
  }

  int get year => _year;
  int get month => _month;

  String getYearSlashMonth() {
    return _year.toString() + '/' + nf2digit.format(_month);
  }
}
