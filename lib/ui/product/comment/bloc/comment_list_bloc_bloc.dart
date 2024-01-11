import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/repo/comment_repository.dart';

part 'comment_list_bloc_event.dart';
part 'comment_list_bloc_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository commentRepository;
  final int productId;
  CommentListBloc({required this.commentRepository, required this.productId})
      : super(CommentListLoading()) {
    on<CommentListEvent>((event, emit) async {
      if (event is CommentListStarted) {
        emit(CommentListLoading());
        
        try {
          final comments = await commentRepository.getAll(productId: productId);
          emit(CommentListSucess(comments: comments));
        } catch (e) {
          emit(CommentListError(e is AppException?e:AppException()));
        }
      }
    });
  }
}
