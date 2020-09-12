class User {
  final int id;
  final String displayName;

  User({
    this.id,
    this.displayName,
  });

  User copyWith({int id, String displayName}) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'id': this.id,
      'displayName': this.displayName,
    };
  }

  factory User.rehydrate(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      displayName: json['displayName'],
    );
  }

  @override
  String toString() {
    return '{ $id $displayName }';
  }
}
