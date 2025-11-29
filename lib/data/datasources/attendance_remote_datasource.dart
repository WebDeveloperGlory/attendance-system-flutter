import 'package:smart_attendance_system/application/core/config/app_config.dart';
import 'package:smart_attendance_system/application/core/network/dio_client.dart';
import 'package:smart_attendance_system/data/models/attendance_model.dart';
import 'package:smart_attendance_system/domain/entities/attendance_entity.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceSummaryEntity> getAttendanceRecordsSummary();
  Future<ClassAttendanceDetailEntity> getClassAttendance(String classId);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final DioClient dioClient;

  AttendanceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AttendanceSummaryEntity> getAttendanceRecordsSummary() async {
    final response = await dioClient.dio.get(
      AppConfig.getAttendanceRecordsSummaryEndpoint,
    );

    if (response.data['code'] == AppConfig.successCode) {
      return AttendanceSummaryModel.fromJson(response.data['data']);
    } else {
      throw Exception(
        response.data['message'] ?? 'Failed to load attendance records',
      );
    }
  }

  @override
  Future<ClassAttendanceDetailEntity> getClassAttendance(String classId) async {
    final response = await dioClient.dio.get(
      AppConfig.getClassAttendanceEndpoint,
      queryParameters: {'classId': classId},
    );

    if (response.data['code'] == AppConfig.successCode) {
      return ClassAttendanceDetailModel.fromJson(response.data['data']);
    } else {
      throw Exception(
        response.data['message'] ?? 'Failed to load class attendance',
      );
    }
  }
}
