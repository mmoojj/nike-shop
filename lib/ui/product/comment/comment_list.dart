import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/repo/comment_repository.dart';
import 'package:nike_shop/ui/product/comment/bloc/comment_list_bloc_bloc.dart';
import 'package:nike_shop/ui/product/comment/comment.dart';
import 'package:nike_shop/ui/widget/error.dart';

class CommentList extends StatelessWidget {
  final int productId;

  const CommentList(
      {super.key, required this.productId});

  

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) {
        final CommentListBloc bloc = CommentListBloc(
            commentRepository: commentRepository, productId: productId);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
          builder: (context, state) {
        if (state is CommentListSucess ) {
          return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: state.comments.length, (context, index) {
                    return CommentItem(
                      comments: state.comments[index],
                    );
                  }));
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CommentListError) {
          return SliverToBoxAdapter(
            child: AppErrorWidget(
                exception: state.exception,
                ontap: () {
                  BlocProvider.of<CommentListBloc>(context)
                      .add(CommentListStarted());
                }),
          );
        } else {
          throw Exception("state not found");
        }
      }),
    );
  }
}

