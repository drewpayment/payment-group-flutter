

import 'package:pay_track/models/client.dart';

class User {
  int id;
  String firstName, lastName, username, email;
  bool active;
  List<Client> clients;
  UserDetail detail;
  Role userRole;
  Session session;

  User({
    this.id, this.firstName, this.lastName, this.username, this.email, this.active, 
    this.clients, this.detail, this.userRole, this.session
  });

  factory User.fromJson(Map<String, dynamic> j) {
    return User(
      id: j['id'],
      firstName: j['firstName'],
      lastName: j['lastName'],
      username: j['username'],
      email: j['email'],
      active: j['active'],
      clients: j['clients'] != null ? ClientList.fromJson(j['clients']).clients : null,
      detail: j['detail'] != null ? UserDetail.fromJson(j['detail']) : null,
      userRole: j['role'] != null ? Role.fromJson(j['role']) : null,
      session: j['sessionUser'] != null ? Session.fromJson(j['sessionUser']) : null,
    );
  }
}

class UserDetail {
  String bankAccount, bankRouting, city, state, street, street2, phone;
  int userDetailId, userId, zip;
  DateTime birthDate;

  UserDetail({
    this.userDetailId, 
    this.userId, 
    this.street, 
    this.street2, 
    this.city, 
    this.state, 
    this.zip, 
    this.phone, 
    this.bankAccount, 
    this.bankRouting,
    this.birthDate,
  });

  factory UserDetail.fromJson(Map<String, dynamic> m) {
    return UserDetail(
      userDetailId: m['userDetailId'],
      userId: m['userId'],
      street: m['street'],
      street2: m['street2'],
      city: m['city'],
      state: m['state'],
      zip: m['zip'],
      phone: m['phone'],
      bankAccount: m['bankAccount'],
      bankRouting: m['bankRouting'],
      birthDate: m['birthDate'] != null ? DateTime.tryParse(m['birthDate']) : null,
    );
  }
}

/// USER ROLES
/// user = 1
/// supervisor = 2
/// manager = 3
/// regionalManager = 4
/// humanResources = 5
/// companyAdmin = 6
/// systemAdmin = 7
class Role {
  int role, userId;
  bool isSalesAdmin;

  Role({ this.role, this.userId, this.isSalesAdmin });

  factory Role.fromJson(Map<String, dynamic> m) {
    return Role(
      role: m['role'],
      userId: m['userId'],
      isSalesAdmin: m['isSalesAdmin'] == 'true'
    );
  }
}

class Session {
  int clientId, userId;
  Client client;

  Session({ this.clientId, this.userId, this.client });

  factory Session.fromJson(Map<String, dynamic> m) {
    return Session(
      clientId: m['sessionClient'],
      userId: m['userId'],
      client: m['client'] != null ? Client.fromJson(m['client']) : null,
    );
  }
}