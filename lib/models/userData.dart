class UserData {
  final Map<String, dynamic> doc;
  final String id;

  UserData({
    this.doc,
    this.id,
  });

  factory UserData.empty() => UserData();

  bool get isEmpty => (doc == null && id == null);
}
