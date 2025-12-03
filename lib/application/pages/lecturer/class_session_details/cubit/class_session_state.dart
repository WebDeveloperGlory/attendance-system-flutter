part of 'class_session_cubit.dart';

enum ClassSessionStatus { initial, loading, loaded, updating, error }

class ClassSessionState extends Equatable {
  final ClassSessionStatus status;
  final ClassSessionEntity? classSession;
  final String searchQuery;
  final bool isAttendanceActive;
  final bool showMenu;
  final bool showAddStudentDialog;
  final Failure? failure;

  const ClassSessionState({
    this.status = ClassSessionStatus.initial,
    this.classSession,
    this.searchQuery = '',
    this.isAttendanceActive = false,
    this.showMenu = false,
    this.showAddStudentDialog = false,
    this.failure,
  });

  ClassSessionState copyWith({
    ClassSessionStatus? status,
    ClassSessionEntity? classSession,
    String? searchQuery,
    bool? isAttendanceActive,
    bool? showMenu,
    bool? showAddStudentDialog,
    Failure? failure,
  }) {
    return ClassSessionState(
      status: status ?? this.status,
      classSession: classSession ?? this.classSession,
      searchQuery: searchQuery ?? this.searchQuery,
      isAttendanceActive: isAttendanceActive ?? this.isAttendanceActive,
      showMenu: showMenu ?? this.showMenu,
      showAddStudentDialog: showAddStudentDialog ?? this.showAddStudentDialog,
      failure: failure ?? this.failure,
    );
  }

  List<AttendanceRecord> get filteredAttendanceRecords {
    if (classSession == null) return [];
    if (searchQuery.isEmpty) return classSession!.attendanceRecords;

    return classSession!.attendanceRecords.where((record) {
      return record.student.name.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          record.student.matricNumber.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
    }).toList();
  }

  int get presentCount {
    return classSession?.stats.present ?? 0;
  }

  int get absentCount {
    return classSession?.stats.absent ?? 0;
  }

  int get fingerprintVerifiedCount {
    if (classSession == null) return 0;
    return classSession!.attendanceRecords
        .where((record) => record.verifiedByFingerprint)
        .length;
  }

  @override
  List<Object?> get props => [
    status,
    classSession,
    searchQuery,
    isAttendanceActive,
    showMenu,
    showAddStudentDialog,
    failure,
  ];
}
