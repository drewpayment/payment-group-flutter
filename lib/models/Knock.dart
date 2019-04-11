
import 'package:meta/meta.dart';

class Knock {
  static final dbId = "id";
  static final dbAddress = "address";
  static final dbLatitude = "latitude";
  static final dbLongitude = "longitude";
  static final dbIsEnabled = "isEnabled";

  String address;
  double latitude, longitude;
  int id;
  bool isEnabled;

  Knock({
    @required this.address,
    @required this.latitude,
    @required this.longitude,
    @required this.isEnabled,
    this.id
  });

  Knock.fromMap(Map<String, dynamic> map): this(
    address: map[dbAddress],
    latitude: map[dbLatitude],
    longitude: map[dbLongitude],
    isEnabled: map[dbIsEnabled] == 1,
    id: map[dbId]
  );

  Map<String, dynamic> toMap() {
    return {
      dbAddress: address,
      dbLatitude: latitude,
      dbLongitude: longitude,
      dbIsEnabled: isEnabled ? 1 : 0,
      dbId: id
    };
  }
}