import 'dart:convert';

import 'package:docs_clone_flutter/constants.dart';
import 'package:docs_clone_flutter/models/document_model.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: http.Client()));

class DocumentRepository {
  DocumentRepository({required http.Client client});

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(error: 'Some Error Occurred', data: null);

    try {
      http.Response res = await http.post(Uri.parse('$host/doc/create'),
          headers: {
            'content-type': 'Application/json; charset=UTF-8',
            '-x-auth-token': token
          },
          body:
              jsonEncode({'createdAt': DateTime.now().millisecondsSinceEpoch}));

      switch (res.statusCode) {
        case 200:
          error =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }

    return error;
  }
}
