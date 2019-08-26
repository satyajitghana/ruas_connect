import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CoursesState extends Equatable {
  CoursesState([List props = const []]) : super(props);
}

class Uninitialized extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final Map<String, String> coursesList;

  CoursesLoaded({@required Map<String, String> coursesList})
      : assert(coursesList != null),
        coursesList = coursesList,
        super([coursesList]);
}

class CoursesLoadError extends CoursesState {}
