import 'package:catcher/catcher_plugin.dart';
import 'package:pay_track/main.dart';
import 'package:pay_track/models/config.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

void main() {
  final config = ConfigModel(
    appName: 'POSITS',
    flavor: 'Development',
    api: 'http://verostack/api',
  );
  var container = kiwi.Container();
  container.registerInstance(config);

  Catcher(
    ScopedModel(
      model: config,
      child: MyApp(),
    ),
    debugConfig: CatcherOptions(
      DialogReportMode(), 
      [ConsoleHandler()],
    ),
  );
}