import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
abstract class DocumentsEvent extends Equatable {
  DocumentsEvent([List props = const []]) : super(props);
}

class LoadDocuments extends DocumentsEvent {}

class LoadMoreDocuments extends DocumentsEvent {}
