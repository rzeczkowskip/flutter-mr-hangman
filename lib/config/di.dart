import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/highscores.dart';

GetIt getIt = GetIt.instance;

void registerServices(GetIt getIt) async {
  getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  getIt.registerSingletonWithDependencies(
    () => Highscores(
      getIt<SharedPreferences>(),
    ),
    dependsOn: [SharedPreferences],
  );
}
