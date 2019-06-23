

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('New Contact'),
              SingleChildScrollView(
                child: AddContactForm(),
              ),
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