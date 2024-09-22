import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetMessagesCall {
  static Future<ApiCallResponse> call() async {
    const ffApiRequestBody = '''
{
  "p_chat_id": "1fb54812-441a-4908-83ce-6d0f1ab03c36"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Messages',
      apiUrl:
          'https://vnsnxkhiyguywgggwdau.supabase.co/rest/v1/rpc/get_chat_messages',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMTEzMzkwMCwiZXhwIjoyMDM2NzA5OTAwfQ.2bhfGH3Mtr0SU7_cekh_1WZljNdrygTAjQNV4eT_DLQ',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMTEzMzkwMCwiZXhwIjoyMDM2NzA5OTAwfQ.2bhfGH3Mtr0SU7_cekh_1WZljNdrygTAjQNV4eT_DLQ',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
