import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CoursesState extends Equatable {
  CoursesState([List props = const []]) : super(props);
}

class Uninitialized extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<DocumentSnapshot> coursesList;

  CoursesLoaded({@required List<DocumentSnapshot> coursesList})
      : assert(coursesList != null),
        coursesList = coursesList,
        super([coursesList]);
}

class CoursesLoadError extends CoursesState {}
