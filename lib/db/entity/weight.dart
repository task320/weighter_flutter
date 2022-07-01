class Weight {
  int? userId;
  int? year;
  int? month;
  int? day;
  double? weight;
  String? createAt;
  String? updateAt;

  Weight(
      {this.userId,
      this.year,
      this.month,
      this.day,
      this.weight,
      this.createAt,
      this.updateAt});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'year': year,
      'month': month,
      'day': day,
      'weight': weight,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }

  bool equalInputDate(DateTime d) {
    if (year == d.year && month == d.month && day == d.day) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return 'Weight{userId: $userId, year: $year, month: $month, day: $day, weight: $weight, createAt: $createAt, updateAt: $updateAt}';
  }
}
