class UserContact {
  final String name;
  final String mobile;
  final String contactId;

  UserContact(this.name, this.mobile, this.contactId);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'contactId': contactId,
    };
  }

  @override
  String toString() {
    return 'Contact(name: $name, mobile: $mobile,contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserContact &&
        other.name == name &&
        other.mobile == mobile &&
        other.contactId == contactId;
  }

  @override
  int get hashCode {
    return name.hashCode ^ mobile.hashCode ^ contactId.hashCode;
  }
}
