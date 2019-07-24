import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/router.dart';
import 'package:pay_track/widgets/contact_form.dart';
import 'package:pay_track/widgets/contact_form_provider.dart';
import 'package:pay_track/widgets/edit_contact_form.dart';

import 'map_page.dart';

class ManageContacts extends StatefulWidget {
  static const routeName = '/manage-contacts';
  static final scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: ManageContacts.scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.45),
      appBar: CustomAppBar(title: Text('')),
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
        label: Text('Contact'),
        onPressed: () => _handleAdd(),
        // onPressed: () {
        //   Navigator.pushNamed(context, AddContactPage.routeName);
        // },
      ),
    );
  }

  TextStyle _cardTitleTextStyle() {
    return const TextStyle(
      color: Colors.white,
      // fontFamily: 'Raleway',
      // fontSize: 19.0,
      fontWeight: FontWeight.normal,
      // letterSpacing: 1.2,
    );
  }

  TextStyle _cardSubtitleTextStyle() {
    return _cardTitleTextStyle().copyWith(
      color: Colors.black,
      fontFamily: 'Raleway',
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
      // letterSpacing: 1.0,
    );
  }

  Widget _getListView(AsyncSnapshot<List<Knock>> snap) {
    var contacts = snap.data;
    return ListView.builder(
      itemCount: snap.data.length,
      itemBuilder: (context, index) {
        final desc = contacts[index].description != null 
          ? '${contacts[index].description}'
          : '${contacts[index].firstName} ${contacts[index].lastName}';

        final cardAddr = Text(
          '$desc\n${contacts[index].address} ${contacts[index].addressCont ?? ''}\n${contacts[index].city} ${contacts[index].state} ${contacts[index].zip}',
          style: _cardSubtitleTextStyle(),
          textAlign: TextAlign.left,
        );

        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), 
          ),
          child: Container(
            height: 70,
            margin: EdgeInsets.all(16),
            child: InkWell(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: 45, 
                      height: 45,
                      child: Center(
                        child: Icon(Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onTap: () => _handleEdit(contacts[index]),
                  ),
                  
                  // VerticalDivider(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // cardDesc,
                        cardAddr,
                      ],
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 75,
                      width: 40,
                      child: Icon(Icons.arrow_forward_ios,
                        color: Colors.black45,
                        // size: 50,
                      ),
                      // decoration: BoxDecoration(
                      //   color: Theme.of(context).accentColor,
                      //   borderRadius: BorderRadius.circular(50),
                      // ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, MapPage.routeName,
                        arguments: MapPageRouterParams(
                          contacts[index].dncContactId,
                          contacts[index].lat,
                          contacts[index].long,
                        ),
                      );
                    }
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, MapPage.routeName,
                  arguments: MapPageRouterParams(
                    contacts[index].dncContactId,
                    contacts[index].lat,
                    contacts[index].long,
                  ),
                );
              }
            ),
          ),
        );
      },
      padding: EdgeInsets.all(16.0),
    );
  }

  void _handleAdd() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: MediaQuery.of(context).size.height * 0.93,
          // width: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                padding: EdgeInsets.only(left: 16, top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Contact Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  // children: <Widget>[AddContactForm()],
                  children: <Widget>[
                    ContactFormProvider(child: ContactForm()),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _handleEdit(Knock contact) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: MediaQuery.of(context).size.height * 0.93,
          // width: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                padding: EdgeInsets.only(left: 16, top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Contact Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[EditContactForm(contact: contact)],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}