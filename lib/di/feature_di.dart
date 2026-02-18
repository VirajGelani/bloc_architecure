import 'package:bloc_architecure/core/auth/auth_session_manager.dart';
import 'package:bloc_architecure/services/api_service.dart';
import 'package:bloc_architecure/services/get_storage_service.dart';
import 'package:bloc_architecure/services/hive_storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

void registerFeatures(GetIt getIt) {
  getIt.registerLazySingleton<AuthSessionManager>(() => AuthSessionManager());
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<HiveStorageService>(() => HiveStorageService());
  getIt.registerLazySingleton<GetStorage>(() => GetStorage());
  getIt.registerLazySingleton<GetStorageService>(
    () => GetStorageService(getIt()),
  );

  // registerLoginFeature(getIt);
}
