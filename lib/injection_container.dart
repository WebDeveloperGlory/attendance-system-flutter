import 'package:get_it/get_it.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/auth_state_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/login_cubit.dart';
import 'package:smart_attendance_system/data/datasources/auth_remote_datasource.dart';
import 'package:smart_attendance_system/data/repositories/auth_repo_impl.dart';
import 'package:smart_attendance_system/domain/usecases/login_usecase.dart';

final getIt = GetIt.instance;

void init() {
  getIt.registerLazySingleton(() => AuthStateCubit());
  getIt.registerFactory(() => LoginCubit(
        authStateCubit: getIt(),
        loginUseCase: getIt(),
      ));

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(dioClient: getIt()),
  );

  // External
  getIt.registerLazySingleton(() => DioClient());
}