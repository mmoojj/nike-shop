part of 'comment_list_bloc_bloc.dart';

sealed class CommentListState extends Equatable {
  const CommentListState();

  @override
  List<Object> get props => [];
}

final class CommentListLoading extends CommentListState {}



class CommentListSucess extends CommentListState {
  final List<CommentEntity> comments;

  CommentListSucess({required this.comments});

  @override
  // TODO: implement props
  List<Object> get props => [comments];
}

class CommentListError extends CommentListState {
  final AppException exception;

  CommentListError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}
