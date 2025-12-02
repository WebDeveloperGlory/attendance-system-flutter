import 'package:equatable/equatable.dart';

class CreateClassResponseModel extends Equatable {
  final String code;
  final String message;
  final CreateClassResponseData? data;

  const CreateClassResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory CreateClassResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateClassResponseModel(
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? CreateClassResponseData.fromJson(json['data'])
          : null,
    );
  }

  bool get isSuccess => code == '00';

  @override
  List<Object?> get props => [code, message, data];
}

class CreateClassResponseData extends Equatable {
  final String date;
  final String lecturer;
  final String course;
  final List<String> attendanceRecords;
  final String? startTime;
  final String? endTime;
  final String? topic;

  const CreateClassResponseData({
    required this.date,
    required this.lecturer,
    required this.course,
    required this.attendanceRecords,
    this.startTime,
    this.endTime,
    this.topic,
  });

  factory CreateClassResponseData.fromJson(Map<String, dynamic> json) {
    return CreateClassResponseData(
      date: json['date']?.toString() ?? '',
      lecturer: json['lecturer']?.toString() ?? '',
      course: json['course']?.toString() ?? '',
      attendanceRecords:
          (json['attendanceRecords'] as List<dynamic>?)
              ?.map((record) => record.toString())
              .toList() ??
          const [],
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
      topic: json['topic']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
    date,
    lecturer,
    course,
    attendanceRecords,
    startTime,
    endTime,
    topic,
  ];
}
