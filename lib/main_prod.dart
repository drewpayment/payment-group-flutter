import 'package:catcher/core/catcher.dart';
import 'package:catcher/handlers/email_manual_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:pay_track/main.dart';
import 'package:pay_track/models/config.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

void main() {
  final config = ConfigModel(
    appName: 'POSITS',
    flavor: 'Production',
    api: 'https://verostack.dev/api',
  );
  var container = kiwi.Container();
  container.registerInstance(config);

  Catcher(
    ScopedModel(
      model: config,
      child: MyApp(),
    ),
    releaseConfig: CatcherOptions(
      DialogReportMode(),
      [EmailManualHandler(['support@verostack.dev'])],
    ),
  );
}