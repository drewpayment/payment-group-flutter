

class User {
  int id;
  String firstName, lastName, username, email;
  bool active;

  User({
    this.id, this.firstName, this.lastName, this.username, this.email, this.active
  });

  factory User.fromJson(Map<String, dynamic> j) {
    return User(
      id: j['id'],
      firstName: j['firstName'],
      lastName: j['lastName'],
      username: j['username'],
      email: j['email'],
      active: j['active']
    );
  }
}