import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exception.dart';
import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/repo/comment_repository.dart';

part 'insert_comment_event.dart';
part 'insert_comment_state.dart';

class InsertCommentBloc extends Bloc<InsertCommentEvent, InsertCommentState> {
  final ICommentRepository repository;
  final int productId;
  InsertCommentBloc(this.repository, this.productId)
      : super(InsertCommentInitial()) {
    on<InsertCommentEvent>((event, emit) async {
      if (event is InsertCommentFormSubmit) {
        if (event.title.isNotEmpty && event.content.isNotEmpty) {
          try {
            emit(InsertCommentLoading());
            final comment =
                await repository.insert(event.title, event.content, productId);
            emit(InsertCommentSuccess(comment));
          } catch (e) {
            emit(
              InsertCommentError(e is AppException ? e : AppException()),
            );
          }
        } else {
          emit(
            InsertCommentError(
              AppException(message: "عنوان و محتوای نظر خود را مشخص کنید"),
            ),
          );
        }
      }
    });
  }
}
