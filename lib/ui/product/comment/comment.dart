import 'package:flutter/material.dart';
import 'package:nike_shop/common/extestion.dart';
import 'package:nike_shop/data/comment.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comments;
  const CommentItem({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comments.title),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    comments.email,
                    style: context.themedata.bodySmall,
                  ),
                ],
              ),
              Text(comments.date, style: context.themedata.bodySmall)
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(comments.content)
        ],
      ),
    );
  }
}

