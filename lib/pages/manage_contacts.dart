import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';

class ManageContacts extends StatefulWidget {
  static const routeName = '/manage-contacts';

  @override
  ManageContactsState createState() => ManageContactsState();
}

class ManageContactsState extends State<ManageContacts> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
  AnimationController _controller;
  
  @override
  Widget build(BuildContext context) {
    const Duration _kExpand = Duration(milliseconds: 200);
    var config = kiwi.Container().resolve<ConfigModel>();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    var _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    return Scaffold(
      appBar: CustomAppBar(title: Text('${config.appName}')),
      body: StreamBuilder(
        builder: (context, AsyncSnapshot<List<Knock>> snap) {
          if (snap.hasData) {
            var contacts = snap.data;
            return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (context, index) {
                var isExpanded = (index == 0);
                return Card(
                  child: ListTileTheme(
                    iconColor: Colors.white,
                    selectedColor: Colors.white60,
                    child: ExpansionTile(
                      key: PageStorageKey(index),
                      initiallyExpanded: isExpanded,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Address: ',
                                style: _cardSubtitleTextStyle(),
                              ),
                              Text(
                                '${contacts[index].address} ${contacts[index].addressCont}\n${contacts[index].city} ${contacts[index].state} ${contacts[index].zip}',
                                style: _cardSubtitleTextStyle(),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                                    textColor: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text('Edit',
                                          style: _cardSubtitleTextStyle(),
                                        ),
                                        Icon(Icons.edit,
                                          size: 16.0,
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      print('Pressed Edit!');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      trailing: isExpanded ? const Icon(Icons.expand_less, color: Colors.white) 
                        : RotationTransition(
                          turns: _iconTurns,
                          child: const Icon(Icons.expand_more,
                            color: Colors.white,
                          ),
                        ),
                      onExpansionChanged: (value) {
                        isExpanded = !isExpanded;
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
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        initialData: null,
        stream: bloc.knocksStream,
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
      fontFamily: 'Helvectica',
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
      letterSpacing: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}