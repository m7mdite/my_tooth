import 'package:gr_flutter/models/pending_request_model.dart';


List<PendingRequestModel> filterRequestWithConditions(
  List<PendingRequestModel> requests,
  List<bool Function(PendingRequestModel)> conditions,
) {
  return requests.where((request) {
    for (var condition in conditions) {
      if (!condition(request)) return false;
    }
    return true;
  }).toList();
}
