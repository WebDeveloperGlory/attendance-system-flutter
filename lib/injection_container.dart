import 'package:get_it/get_it.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/application/pages/admin/dashboard/cubit/admin_dashboard_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/auth_state_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/login_cubit.dart';
import 'package:smart_attendance_system/data/datasources/admin_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/auth_remote_datasource.dart';
import 'package:smart_attendance_system/data/repositories/admin_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/auth_repo_impl.dart';
import 'package:smart_attendance_system/domain/repositories/admin_repo.dart';
import 'package:smart_attendance_system/domain/usecases/login_usecase.dart';

final getIt = GetIt.instance;

void init() {
  // Cubits/Blocs
  getIt.registerLazySingleton(() => AuthStateCubit());
  getIt.registerFactory(() => LoginCubit(
        authStateCubit: getIt(),
        loginUseCase: getIt(),
      ));
  getIt.registerFactory(() => AdminDashboardCubit(
        adminRepository: getIt(),
      ));

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<AdminRepo>(
    () => AdminRepoImpl(remoteDataSource: getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(dioClient: getIt()),
  );
  getIt.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dioClient: getIt()),
  );

  // External
  getIt.registerLazySingleton(() => DioClient());
}