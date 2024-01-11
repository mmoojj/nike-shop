part of 'comment_list_bloc_bloc.dart';

sealed class CommentListEvent extends Equatable {
  const CommentListEvent();

  @override
  List<Object> get props => [];
}


class CommentListStarted extends CommentListEvent{}


