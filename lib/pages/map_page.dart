import 'package:flutter/material.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/custom_bottom_nav.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/router.dart';
import 'package:pay_track/widgets/google_map.dart';
import 'package:pay_track/widgets/map_list.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  static const String routeName = '/map';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  kiwi.Container container = kiwi.Container();
  ConfigModel config;
  MapPageRouterParams routeParams;

  _MapPageState() {
    config = container.resolve<ConfigModel>();
  }

  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    routeParams = ModalRoute.of(context).settings.arguments;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    bloc.fetchAllKnocks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: null,
      stream: bloc.knocksStream,
      builder: (context, AsyncSnapshot<List<Knock>> snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting && snapshot.hasData) {
          var contacts = snapshot.data;
          Knock navigateToContact;

          if (routeParams != null) {
            navigateToContact = contacts.firstWhere((c) => c.dncContactId == routeParams.dncContactId);
          }
          
          return Scaffold(
            appBar: CustomAppBar(title: Text('${config.appName}')),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GoogleMapWidget(navigateToContact),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}