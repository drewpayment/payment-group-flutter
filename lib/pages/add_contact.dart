

import 'package:flutter/material.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/widgets/add_contact_form.dart';
import 'package:scoped_model/scoped_model.dart';

class AddContactPage extends StatefulWidget {

  static const routeName = '/add-contact';

  @override
  AddContactPageState createState() => AddContactPageState();
}

class AddContactPageState extends State<AddContactPage> {

  
  @override
  void initState() {
    super.initState();

    /// do some stuff
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConfigModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: CustomAppBar(title: Text('${model.appName}')),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('NEW RESTRICTION',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Create a new location on the map that can be referenced in real-time by users.',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              Divider(
                color: Colors.black45,
                indent: 8.0,
                endIndent: 8.0,
              ),
              AddContactForm()
            ],
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    super.dispose();

    /// dispose of blocs
  }
}