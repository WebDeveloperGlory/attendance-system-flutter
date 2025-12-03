part of 'lecturer_course_details_cubit.dart';

enum LecturerCourseDetailsStatus { initial, loading, loaded, error }

class LecturerCourseDetailsState extends Equatable {
  final LecturerCourseDetailsStatus status;
  final LecturerCourseDetailsEntity? courseDetails;
  final String searchQuery;
  final bool showMenu;
  final Failure? failure;

  const LecturerCourseDetailsState({
    this.status = LecturerCourseDetailsStatus.initial,
    this.courseDetails,
    this.searchQuery = '',
    this.showMenu = false,
    this.failure,
  });

  LecturerCourseDetailsState copyWith({
    LecturerCourseDetailsStatus? status,
    LecturerCourseDetailsEntity? courseDetails,
    String? searchQuery,
    bool? showMenu,
    Failure? failure,
  }) {
    return LecturerCourseDetailsState(
      status: status ?? this.status,
      courseDetails: courseDetails ?? this.courseDetails,
      searchQuery: searchQuery ?? this.searchQuery,
      showMenu: showMenu ?? this.showMenu,
      failure: failure ?? this.failure,
    );
  }

  List<StudentEntity> get filteredStudents {
    if (courseDetails == null) return [];
    if (searchQuery.isEmpty) return courseDetails!.students;

    return courseDetails!.students.where((student) {
      return student.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          student.matricNumber!.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
    }).toList();
  }

  int get enrolledStudentsCount {
    return courseDetails?.students.length ?? 0;
  }

  double get averageAttendancePercentage {
    return courseDetails?.averageAttendance.presentPercentage ?? 0;
  }

  @override
  List<Object?> get props => [
    status,
    courseDetails,
    searchQuery,
    showMenu,
    failure,
  ];
}
