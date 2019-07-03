import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/add_contact.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/router.dart';
import 'package:pay_track/widgets/add_contact_form.dart';

import 'map_page.dart';

class ManageContacts extends StatefulWidget {
  static const routeName = '/manage-contacts';

  @override
  ManageContactsState createState() => ManageContactsState();
}

class ManageContactsState extends State<ManageContacts> with TickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
  AnimationController _controller;
  Animation<double> _iconTurns;

  static var container = kiwi.Container();
  ConfigModel config = container.resolve<ConfigModel>();

  @override
  BuildContext get context => super.context;

  @override
  void initState() {
    const Duration _kExpand = Duration(milliseconds: 200);
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.45),
      appBar: CustomAppBar(title: Text('POSITS')),
      body: StreamBuilder(
        builder: (context, AsyncSnapshot<List<Knock>> snap) {
          if (snap.hasData) {
            return _getListView(snap);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        initialData: null,
        stream: bloc.knocksStream,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_circle),
        label: Text('Restriction'),
        onPressed: () {
          Navigator.pushNamed(context, AddContactPage.routeName);
        },
      ),
    );
  }

  TextStyle _cardTitleTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontFamily: 'Raleway',
      fontSize: 19.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
    );
  }

  TextStyle _cardSubtitleTextStyle() {
    return _cardTitleTextStyle().copyWith(
      color: Colors.white,
      fontFamily: 'Helvectica',
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
      letterSpacing: 1.0,
    );
  }

  Widget _getListView(AsyncSnapshot<List<Knock>> snap) {
    var contacts = snap.data;
    return ListView.builder(
      itemCount: snap.data.length,
      itemBuilder: (context, index) {
        var controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
        var animation = controller.drive(_halfTween.chain(_easeInTween));
        return Card(
          child: ListTileTheme(
            iconColor: Colors.white,
            selectedColor: Colors.grey,
            child: ExpansionTile(
              key: PageStorageKey(index),
              leading: CircleAvatar(
                child: Icon(Icons.home),
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
              ),
              title: contacts[index].description != null 
                ? Text(contacts[index].description, style: _cardTitleTextStyle())
                : Text('${contacts[index].firstName} ${contacts[index].lastName}', style: _cardTitleTextStyle()),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(width: 45.0),
                      Text(
                        '${contacts[index].address} ${contacts[index].addressCont ?? ''}\n${contacts[index].city} ${contacts[index].state} ${contacts[index].zip}',
                        style: _cardSubtitleTextStyle(),
                      ),
                      Spacer(),
                      _getEditButton(contacts[index]),
                    ],
                  ),
                ),
              ],
              trailing: RotationTransition(
                turns: animation,
                child: const Icon(Icons.expand_more,
                  color: Colors.white,
                ),
              ),
              onExpansionChanged: (value) {
                if (value) {
                  controller.forward(from: 0.0);
                } else {
                  controller.reverse(from: 0.5);
                }
              },
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Theme.of(context).primaryColor,
          elevation: 7,
          margin: EdgeInsets.symmetric(vertical: 10.0),
        );
      },
      padding: EdgeInsets.all(16.0),
    );
  }

  Widget _getEditButton(Knock contact) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.edit),
          onPressed: () {
            showModalBottomSheet(
              // isScrollControlled: true,
              context: context,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(10.0),
              // ),
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: MediaQuery.of(context).size.height * 0.90,
                  // width: MediaQuery.of(context).size.width * 0.95,
                  child: SingleChildScrollView(
                    primary: true,
                    child: AddContactForm(contact: contact),
                  ),
                );
              }
            );
          },
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.map),
          onPressed: () {
            Navigator.pushReplacementNamed(context, MapPage.routeName,
              arguments: MapPageRouterParams(
                contact.dncContactId,
                contact.lat,
                contact.long,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}