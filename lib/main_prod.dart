import 'package:catcher/core/catcher.dart';
import 'package:catcher/handlers/email_manual_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:pay_track/main.dart';
import 'package:pay_track/models/config.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {

  Catcher(
    ScopedModel(
      model: ConfigModel(
        appName: 'Locale.Marketing',
        flavor: 'Production',
        api: 'https://verostack.dev/api',
      ),
      child: MyApp(),
    ),
    releaseConfig: CatcherOptions(
      DialogReportMode(),
      [EmailManualHandler(['drew@verostack.dev'])],
    ),
  );
}