part of 'insert_comment_bloc.dart';

sealed class InsertCommentState extends Equatable {
  const InsertCommentState();
  
  @override
  List<Object> get props => [];
}

final class InsertCommentInitial extends InsertCommentState {}


class InsertCommentError extends InsertCommentState{
  final AppException exception;

  const InsertCommentError(this.exception);

  @override
  // TODO: implement props
  List<Object> get props => [exception];
}


class InsertCommentLoading extends InsertCommentState{}

class InsertCommentSuccess extends InsertCommentState{
  final CommentEntity commentEntity;

  const InsertCommentSuccess(this.commentEntity);

  
}