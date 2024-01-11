import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/repo/comment_repository.dart';
import 'package:nike_shop/ui/product/comment/insert/bloc/insert_comment_bloc.dart';

class InserCommentDialog extends StatefulWidget {
  const InserCommentDialog(
      {super.key, required this.productId, this.scaffoldMessenger});
  final int productId;
  final ScaffoldMessengerState? scaffoldMessenger;

  @override
  State<InserCommentDialog> createState() => _InserCommentDialogState();
}

class _InserCommentDialogState extends State<InserCommentDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  StreamSubscription<InsertCommentState>? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InsertCommentBloc>(
      create: (context) {
        final bloc = InsertCommentBloc(commentRepository, widget.productId);
        streamSubscription = bloc.stream.listen((state) {
          if (state is InsertCommentSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
          } else if (state is InsertCommentError) {
            Navigator.of(context, rootNavigator: true).pop();
            widget.scaffoldMessenger!
                .showSnackBar(SnackBar(content: Text(state.exception.message)));
          }
        });
        return bloc;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(24),
          child: BlocBuilder<InsertCommentBloc, InsertCommentState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ثبت نظر",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(label: Text("عنوان ")),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                        label: Text("متن نظر خود را وارد کنید... ")),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStatePropertyAll(Size.fromHeight(56))),
                      onPressed: () {
                        context.read<InsertCommentBloc>().add(
                            InsertCommentFormSubmit(
                                titleController.text, contentController.text));
                      },
                      child: state is InsertCommentLoading
                          ? CupertinoActivityIndicator()
                          : Text("ذخیره"))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
