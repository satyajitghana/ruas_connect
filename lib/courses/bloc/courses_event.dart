import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CoursesEvent extends Equatable {
  CoursesEvent([List props = const []]) : super(props);
}

class LoadCourses extends CoursesEvent {
  final String branch;
  final String semester;

  LoadCourses(this.branch, this.semester) : super([branch, semester]);

  @override
  String toString() => 'Event : { LoadCourses $branch => $semester }';
}
