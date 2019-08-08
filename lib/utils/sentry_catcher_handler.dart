import 'package:catcher/catcher_plugin.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:sentry/sentry.dart' as s;

class SentryCatcherHandler implements ReportHandler {
  final container = kiwi.Container();

  @override
  Future<bool> handle(Report error) async {
    final sentry = container<s.SentryClient>();
    await sentry.captureException(
      exception: error.error,
      stackTrace: error.stackTrace,
    );

    return true;
  }

}