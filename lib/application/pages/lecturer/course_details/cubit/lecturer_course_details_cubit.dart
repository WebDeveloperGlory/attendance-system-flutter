import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_system/domain/entities/lecturer_course_details_entity.dart';
import 'package:smart_attendance_system/domain/entities/student_entity.dart';
import 'package:smart_attendance_system/domain/failiures/failures.dart';
import 'package:smart_attendance_system/domain/usecases/get_lecturer_course_details_usecase.dart';

part 'lecturer_course_details_state.dart';

class LecturerCourseDetailsCubit extends Cubit<LecturerCourseDetailsState> {
  final GetLecturerCourseDetailsUseCase getCourseDetailsUseCase;
  final String courseId;

  LecturerCourseDetailsCubit({
    required this.getCourseDetailsUseCase,
    required this.courseId,
  }) : super(const LecturerCourseDetailsState()) {
    loadCourseDetails();
  }

  Future<void> loadCourseDetails() async {
    emit(state.copyWith(status: LecturerCourseDetailsStatus.loading));

    final result = await getCourseDetailsUseCase(courseId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LecturerCourseDetailsStatus.error,
            failure: failure,
          ),
        );
      },
      (courseDetails) {
        emit(
          state.copyWith(
            status: LecturerCourseDetailsStatus.loaded,
            courseDetails: courseDetails,
          ),
        );
      },
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void toggleMenu(bool showMenu) {
    emit(state.copyWith(showMenu: showMenu));
  }

  void refresh() {
    loadCourseDetails();
  }
}
