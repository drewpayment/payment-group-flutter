import 'package:catcher/catcher_plugin.dart';
import 'package:pay_track/main.dart';
import 'package:pay_track/models/config.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.white,
  //     systemNavigationBarColor: Colors.white,
  //     systemNavigationBarDividerColor: Colors.black,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //   ),
  // );

  Catcher(
    ScopedModel(
      model: ConfigModel(
        appName: 'Locale.Marketing',
        flavor: 'Development',
        api: 'http://verostack/api',
      ),
      child: MyApp(),
    ),
    debugConfig: CatcherOptions(
      DialogReportMode(), 
      [ConsoleHandler()],
    ),
  );
}