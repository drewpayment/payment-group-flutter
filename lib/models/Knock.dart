
import 'package:meta/meta.dart';
import 'package:pay_track/utils/helpers.dart';

class Knock {
  static final dbDncContactId = "dncContactId";
  static final dbClientId = "clientId";
  static final dbFirstName = "firstName";
  static final dbLastName = "lastName";
  static final dbDescription = "description";
  static final dbAddress = "address";
  static final dbAddressCont = "addressCont";
  static final dbCity = "city";
  static final dbState = "state";
  static final dbZip = "zip";
  static final dbLat = "lat";
  static final dbLong = "long";

  int dncContactId;
  int clientId;
  String firstName;
  String lastName;
  String description;
  String address;
  String addressCont;
  String city;
  String state;
  String zip;
  double lat;
  double long;

  Knock({
    @required this.clientId,
    @required this.address,
    @required this.city,
    @required this.state,
    @required this.zip,
    this.lat,
    this.long,

    this.firstName,
    this.lastName,
    this.description,
    this.addressCont,
    this.dncContactId
  });

  factory Knock.fromJson(Map<String, dynamic> jsonKnock) {
    double latitude = jsonKnock['lat'] is String && Helpers.isNumeric(jsonKnock['lat']) 
      ? double.tryParse(jsonKnock['lat'])
      : jsonKnock['lat'];
    double longitude = jsonKnock['long'] is String && Helpers.isNumeric(jsonKnock['long'])
      ? double.tryParse(jsonKnock['long'])
      : jsonKnock['long'];

    return Knock(
      dncContactId: jsonKnock['dncContactId'],
      clientId: jsonKnock['clientId'],
      firstName: jsonKnock['firstName'],
      lastName: jsonKnock['lastName'],
      description: jsonKnock['description'],
      address: jsonKnock['address'],
      addressCont: jsonKnock['addressCont'],
      city: jsonKnock['city'],
      state: jsonKnock['state'],
      zip: jsonKnock['zip'],
      lat: latitude,
      long: longitude
    );
  }

  Knock.fromMap(Map<String, dynamic> map): this(
    dncContactId: map[dbDncContactId],
    clientId: map[dbClientId],
    firstName: map[dbFirstName],
    lastName: map[dbLastName],
    description: map[dbDescription],
    address: map[dbAddress],
    addressCont: map[dbAddressCont],
    city: map[dbCity],
    state: map[dbState],
    zip: map[dbZip],
    lat: map[dbLat],
    long: map[dbLong]
  );

  Map<String, dynamic> toMap() {
    return {
      dbDncContactId: dncContactId,
      dbClientId: clientId,
      dbFirstName: firstName,
      dbLastName: lastName,
      dbDescription: description,
      dbAddress: address,
      dbAddressCont: addressCont,
      dbCity: city,
      dbState: state,
      dbZip: zip,
      dbLat: lat,
      dbLong: long
    };
  }
}

class KnockList {
  final List<Knock> knocks;

  KnockList({ this.knocks });

  factory KnockList.fromJson(List<dynamic> j) {
    return KnockList(
      knocks: j.map((i) => Knock.fromJson(i)).toList(),
    );
  }
}