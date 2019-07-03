import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart' as g;
import 'package:location/location.dart';
import 'package:pay_track/bloc/map_search_bloc.dart';
import 'package:pay_track/models/secret.dart';
import 'package:rxdart/subjects.dart';

class MapSearch extends StatefulWidget {
  static const routeName = '/map-search';

  @override
  MapSearchState createState() => MapSearchState();
}

class MapSearchState extends State<MapSearch> {
  LatLng center;
  Secret secrets;
  g.GoogleMapsGeocoding places;
  final TextEditingController _controller = TextEditingController(); 
  var _searchText$ = BehaviorSubject<String>();
  void Function(String) get searchTextPush => _searchText$.sink.add;
  Stream<String> get textStream => _searchText$;

  bool isSearching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mapSearchBloc.loadMaps();
  }

  @override
  void initState() {
    super.initState();
    
    _controller.addListener(_searchPlaces);
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Theme(
                data: themeData.copyWith(primaryColor: Colors.white, cursorColor: Colors.white),
                child: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: true,
                  // autocorrect: true,
                  controller: _controller,
                  // cursorRadius: Radius.circular(5.0),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                    ),
                    // labelText: 'Search',
                    // labelStyle: themeData.,
                  ),
                  // showCursor: true,
                  cursorColor: Colors.white,
                ),
              ),
            ),
            StreamBuilder(
              initialData: null,
              stream: textStream,
              builder: (context, AsyncSnapshot<String> snap) {
                if (snap.hasData && snap.data.length > 0) {
                  return Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _clearSearch,
                    ),
                  );
                }

                return Container(width: 1);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: StreamBuilder(
          initialData: null,
          stream: mapSearchBloc.stream,
          builder: (context, AsyncSnapshot<List<g.GeocodingResult>> snap) {
            if (snap.hasData) {
              var data = snap.data;
              return ListView.builder(
                itemCount: data.length,
                padding: EdgeInsets.symmetric(vertical: 5.0),
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text('${data[index].formattedAddress}'),
                    subtitle: Text('${data[index].placeId}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              );
            }

            if (isSearching) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Text('No Results',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              )
            );
          }
        ),
      ),
    );
  }

  void _searchPlaces() async {
    var searchText = _controller.value.text;
    searchTextPush(searchText);
    if (searchText == null) return;

    if (searchText.length > 3) {
      mapSearchBloc.searchPlaces(searchText);
      
      setState(() {
        isSearching = true;
      });
    }
  }

  void _clearSearch() {
    _controller?.clear();
    searchTextPush('');
    mapSearchBloc.push(null);
  }

  Future<LatLng> getUserLocation() async {
    var location = Location();
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      // blackbox this error for now, dang it. 
    }

    if (currentLocation == null) {
      return null;
    }

    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  @override
  void dispose() {
    mapSearchBloc.dispose();
    _searchText$.close();
    super.dispose();
  }

}