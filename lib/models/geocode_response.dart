
class GeocodeResponse {
  List<GeocodeResult> results;
  String status;

  GeocodeResponse({this.results, this.status});

  factory GeocodeResponse.fromJson(Map<String, dynamic> m) {
    return GeocodeResponse(
      results: GeocodeResult.fromJsonList(m['results']),
      status: m['status'],
    );
  }
}

class GeocodeResult {
  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  String placeId;
  List<String> types;

  GeocodeResult({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.types,
  });

  factory GeocodeResult.fromJson(Map<String, dynamic> m) {
    return GeocodeResult(
      addressComponents: AddressComponent.fromJsonList(m['address_components']),
      formattedAddress: m['formatted_address'],
      geometry: Geometry.fromJson(m['geometry']),
      placeId: m['place_id'],
      types: _parseTypes(m['types']),
    );
  }

  static List<GeocodeResult> fromJsonList(List list) {
    return list.map((l) => GeocodeResult.fromJson(l)).toList();
  }

  static List<String> _parseTypes(List list) {
    return list.map((l) => '$l').toList();
  }
}

class AddressComponent {
  String longName;
  String shortName;
  List<String> types;

  AddressComponent({this.longName, this.shortName, this.types});

  factory AddressComponent.fromJson(Map<String, dynamic> m) {
    return AddressComponent(
      longName: m['long_name'],
      shortName: m['short_name'],
      types: _parseTypes(m['types']),
    );
  }

  static List<AddressComponent> fromJsonList(List list) {
    return list.map((l) => AddressComponent.fromJson(l)).toList();
  }

  static List<String> _parseTypes(List list) {
    return list.map((l) => '$l').toList();
  }
}

class Geometry {
  Location location;
  String locationType;
  Viewport viewport;

  Geometry({this.location, this.locationType, this.viewport});

  factory Geometry.fromJson(Map<String, dynamic> m) {
    return Geometry(
      location: Location.fromJson(m['location']),
      locationType: m['location_type'],
      viewport: Viewport.fromJson(m['viewport']),
    );
  }
}

class Location {
  double lat;
  double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map<String, dynamic> m) {
    return Location(m['lat'], m['lng']);
  }
}

class Viewport {
  Location northeast;
  Location southwest;

  Viewport({this.northeast, this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> m) {
    return Viewport(
      northeast: Location.fromJson(m['northeast']),
      southwest: Location.fromJson(m['southwest']),
    );
  }
}