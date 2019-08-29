import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruas_connect/repository/respository.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesRepository _coursesRepository;

  CoursesBloc({@required CoursesRepository coursesRepository})
      : assert(coursesRepository != null),
        _coursesRepository = coursesRepository;

  @override
  CoursesState get initialState => Uninitialized();

  @override
  Stream<CoursesState> mapEventToState(
    CoursesEvent event,
  ) async* {
    if (event is LoadCourses) {
      yield CoursesLoading();
      try {
        String branch = event.branch;
        String semester = event.semester;
        List<DocumentSnapshot> coursesList =
            await _coursesRepository.getCoursesOf(branch, semester);
        yield CoursesLoaded(coursesList: coursesList);
      } catch (_) {
        print(_.toString());
        yield CoursesLoadError();
      }
    }
  }
}
