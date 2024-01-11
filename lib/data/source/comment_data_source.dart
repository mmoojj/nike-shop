import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/common/http_respone_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
  Future<CommentEntity> insert(String title, String content, int productId);
}

class CommentRemotDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemotDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get("comment/list?product_id=$productId");
    validateResponse(response);
    final comments = <CommentEntity>[];

    (response.data as List).forEach((element) {
      comments.add(CommentEntity.fromjson(element));
    });
    return comments;
  }

  @override
  Future<CommentEntity> insert(
      String title, String content, int productId) async {
    final response = await httpClient.post("comment/add", data: {
      "title": title,
      "content": content,
      "product_id": productId
    }).catchError((e) {
      validateResponse((e as DioException).response as Response);
    });

    return CommentEntity.fromjson(response.data);
  }
}
