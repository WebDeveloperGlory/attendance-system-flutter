import 'package:get_it/get_it.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/application/pages/admin/dashboard/cubit/admin_dashboard_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/lecturer/cubit/lecturer_management_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/faculty/cubit/faculty_management_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/faculty/id/cubit/faculty_details_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/auth_state_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/login_cubit.dart';
import 'package:smart_attendance_system/data/datasources/admin_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/auth_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/fnd_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/lecturer_remote_datasource.dart';
import 'package:smart_attendance_system/data/repositories/admin_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/auth_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/fnd_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/lecturer_repo_impl.dart';
import 'package:smart_attendance_system/domain/repositories/admin_repo.dart';
import 'package:smart_attendance_system/domain/repositories/fnd_repo.dart';
import 'package:smart_attendance_system/domain/repositories/lecturer_repo.dart';
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
  getIt.registerFactory(() => LecturerManagementCubit(
        lecturerRepository: getIt(),
        fndRepository: getIt(),
      ));
  getIt.registerFactory(() => FacultyManagementCubit(
        fndRepo: getIt(),
      ));
  getIt.registerFactory(() => FacultyDetailsCubit(
        fndRepo: getIt(),
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
  getIt.registerLazySingleton<FndRepo>(
    () => FndRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<LecturerRepo>(
    () => LecturerRepoImpl(remoteDataSource: getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(dioClient: getIt()),
  );
  getIt.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<FndRemoteDataSource>(
    () => FndRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<LecturerRemoteDataSource>(
    () => LecturerRemoteDataSourceImpl(dioClient: getIt()),
  );

  // External
  getIt.registerLazySingleton(() => DioClient());
}