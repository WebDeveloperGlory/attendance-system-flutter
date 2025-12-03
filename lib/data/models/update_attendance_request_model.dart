import 'package:equatable/equatable.dart';

class UpdateAttendanceRequestModel extends Equatable {
  final String attendanceRecordId;
  final String status;
  final bool verifiedByFingerprint;

  const UpdateAttendanceRequestModel({
    required this.attendanceRecordId,
    required this.status,
    required this.verifiedByFingerprint,
  });

  Map<String, dynamic> toJson() {
    return {
      'attendanceRecordId': attendanceRecordId,
      'status': status,
      'verifiedByFingerprint': verifiedByFingerprint,
    };
  }

  @override
  List<Object?> get props => [
    attendanceRecordId,
    status,
    verifiedByFingerprint,
  ];
}
