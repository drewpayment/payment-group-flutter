import 'package:scoped_model/scoped_model.dart';

class ConfigModel extends  Model {

  final String appName;
  final String flavor;
  final String api;

  ConfigModel({ this.appName, this.flavor, this.api });

}