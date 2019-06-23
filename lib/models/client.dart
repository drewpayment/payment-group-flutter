
class Client {
  int clientId, taxid, zip, phone;
  String name, city, state, street;
  bool active;

  Client({this.clientId, this.taxid, this.name, this.city, this.street, this.state, this.zip, this.active, this.phone});

  factory Client.fromJson(Map<String, dynamic> j) {
    return Client(
      clientId: j['clientId'],
      name: j['name'],
      street: j['street'],
      city: j['city'],
      state: j['state'],
      zip: j['zip'],
      taxid: j['taxid'],
      active: j['active'] == 'true',
      phone: j['phone'],
    );
  }
}

class ClientList {
  List<Client> clients;

  ClientList({this.clients});

  factory ClientList.fromJson(List<dynamic> l) {
    return ClientList(
      clients: l.map((c) => Client.fromJson(c)).toList(),
    );
  }
}
