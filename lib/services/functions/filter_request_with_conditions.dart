import '../../models/request_model.dart';

List<RequestReceiveModel> filterRequestWithConditions(
  List<RequestReceiveModel> requests,
  List<bool Function(RequestReceiveModel)> conditions,
) {
  return requests.where((request) {
    for (var condition in conditions) {
      if (!condition(request)) return false;
    }
    return true;
  }).toList();
}
