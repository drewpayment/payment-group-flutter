import 'package:catcher/catcher_plugin.dart';
import 'package:pay_track/main.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/utils/sentry_catcher_handler.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:sentry/sentry.dart' as s;

void main() {
  final config = ConfigModel(
    appName: 'TrackSite',
    flavor: 'Development',
    api: 'http://verostack/api',
    website: 'http://verostack/',
    sentryDsn: 'https://d0fa92440a474042b0f764419e06a896@sentry.io/1524723',
  );
  var container = kiwi.Container();
  container.registerInstance(config);
  container.silent = true;

  final sentry = s.SentryClient(dsn: config.sentryDsn);
  container.registerInstance(sentry);

  Catcher(
    MyApp(),
    debugConfig: CatcherOptions(
      SilentReportMode(), 
      [
        SentryCatcherHandler(),
        ConsoleHandler(),
      ],
    ),
  );
}