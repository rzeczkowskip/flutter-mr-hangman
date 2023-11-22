import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/highscores.dart';

GetIt getIt = GetIt.instance;

void registerServices(GetIt _getIt) async {
  _getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  _getIt.registerSingletonWithDependencies(
    () => Highscores(
      _getIt<SharedPreferences>(),
    ),
    dependsOn: [SharedPreferences],
  );
}
