import 'package:get_it/get_it.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/application/pages/admin/dashboard/cubit/admin_dashboard_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/lecturer/cubit/lecturer_management_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/faculty/cubit/faculty_management_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/faculty/id/cubit/faculty_details_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/student/cubit/student_management_cubit.dart';
import 'package:smart_attendance_system/application/pages/admin/student/id/cubit/student_detail_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/auth_state_cubit.dart';
import 'package:smart_attendance_system/application/pages/auth/cubit/login_cubit.dart';
import 'package:smart_attendance_system/application/pages/lecturer/create_class/cubit/create_class_cubit.dart';
import 'package:smart_attendance_system/application/pages/lecturer/dashboard/cubit/lecturer_dashboard_cubit.dart';
import 'package:smart_attendance_system/application/pages/lecturer/records/cubit/attendance_records_cubit.dart';
import 'package:smart_attendance_system/data/datasources/admin_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/attendance_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/auth_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/class_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/class_session_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/course_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/fnd_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/lecturer_remote_datasource.dart';
import 'package:smart_attendance_system/data/datasources/student_remote_datasource.dart';
import 'package:smart_attendance_system/data/repositories/admin_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/attendance_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/auth_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/class_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/class_session_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/course_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/fnd_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/lecturer_repo_impl.dart';
import 'package:smart_attendance_system/data/repositories/student_repo_impl.dart';
import 'package:smart_attendance_system/domain/repositories/admin_repo.dart';
import 'package:smart_attendance_system/domain/repositories/attendance_repo.dart';
import 'package:smart_attendance_system/domain/repositories/class_repo.dart';
import 'package:smart_attendance_system/domain/repositories/class_session_repo.dart';
import 'package:smart_attendance_system/domain/repositories/course_repo.dart';
import 'package:smart_attendance_system/domain/repositories/fnd_repo.dart';
import 'package:smart_attendance_system/domain/repositories/lecturer_repo.dart';
import 'package:smart_attendance_system/domain/repositories/student_repo.dart';
import 'package:smart_attendance_system/domain/usecases/create_class_session_usecase.dart';
import 'package:smart_attendance_system/domain/usecases/get_carryover_students_usecase.dart';
import 'package:smart_attendance_system/domain/usecases/get_class_session_usecase.dart';
import 'package:smart_attendance_system/domain/usecases/get_lecturer_courses_usecase.dart';
import 'package:smart_attendance_system/domain/usecases/login_usecase.dart';
import 'package:smart_attendance_system/domain/usecases/update_attendance_status_usecase.dart';

final getIt = GetIt.instance;

void init() {
  // Cubits/Blocs
  getIt.registerLazySingleton(() => AuthStateCubit());
  getIt.registerFactory(
    () => LoginCubit(authStateCubit: getIt(), loginUseCase: getIt()),
  );
  getIt.registerFactory(() => AdminDashboardCubit(adminRepository: getIt()));
  getIt.registerFactory(
    () => LecturerManagementCubit(
      lecturerRepository: getIt(),
      fndRepository: getIt(),
    ),
  );
  getIt.registerFactory(() => FacultyManagementCubit(fndRepo: getIt()));
  getIt.registerFactory(() => FacultyDetailsCubit(fndRepo: getIt()));
  getIt.registerFactory(() => AttendanceRecordsCubit(attendanceRepo: getIt()));
  getIt.registerFactory(() => StudentManagementCubit(studentRepo: getIt()));
  getIt.registerFactoryParam<StudentDetailCubit, String, void>(
    (studentId, _) =>
        StudentDetailCubit(studentRepo: getIt(), studentId: studentId),
  );
  getIt.registerFactory(
    () => CreateClassCubit(
      getLecturerCoursesUseCase: getIt(),
      getCarryoverStudentsUseCase: getIt(),
      createClassSessionUseCase: getIt(),
    ),
  );
  getIt.registerFactory(() => LecturerDashboardCubit(lecturerRepo: getIt()));

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(
    () => GetLecturerCoursesUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetCarryoverStudentsUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => CreateClassSessionUseCase(repository: getIt()),
  );
  getIt.registerFactory(() => GetClassSessionUseCase(repository: getIt()));
  getIt.registerFactory(
    () => UpdateAttendanceStatusUseCase(repository: getIt()),
  );

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
  getIt.registerLazySingleton<AttendanceRepo>(
    () => AttendanceRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<StudentRepo>(
    () => StudentRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<CourseRepo>(
    () => CourseRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ClassRepo>(
    () => ClassRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ClassSessionRepo>(
    () => ClassSessionRepoImpl(remoteDataSource: getIt()),
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
  getIt.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<ClassRemoteDataSource>(
    () => ClassRemoteDataSourceImpl(dioClient: getIt()),
  );
  getIt.registerLazySingleton<ClassSessionRemoteDataSource>(
    () => ClassSessionRemoteDataSourceImpl(dioClient: getIt()),
  );

  // External
  getIt.registerLazySingleton(() => DioClient());
}
