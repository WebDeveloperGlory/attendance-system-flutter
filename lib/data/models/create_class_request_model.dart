import 'package:equatable/equatable.dart';

class CreateClassRequestModel extends Equatable {
  final String courseId;
  final String? lecturerId;
  final String topic;
  final String date;
  final String startTime;
  final String endTime;
  final String venue;
  final List<String> studentIds;

  const CreateClassRequestModel({
    required this.courseId,
    this.lecturerId,
    required this.topic,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.studentIds,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'courseId': courseId,
      'topic': topic,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'studentIds': studentIds,
      'venue': venue
    };

    // Only add lecturerId if provided
    if (lecturerId != null && lecturerId!.isNotEmpty) {
      json['lecturerId'] = lecturerId as Object;
    }

    return json;
  }

  @override
  List<Object?> get props => [
    courseId,
    lecturerId,
    topic,
    date,
    startTime,
    endTime,
    venue,
    studentIds,
  ];
}
