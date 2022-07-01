class User {
  int? id;
  String? name;
  String? createAt;
  String? updateAt;

  User({this.id, this.name, this.createAt, this.updateAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
