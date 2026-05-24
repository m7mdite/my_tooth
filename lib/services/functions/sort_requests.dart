import 'package:gr_flutter/models/pending_request_model.dart';


List<PendingRequestModel> sortRequest<T extends Comparable>(
  List<PendingRequestModel> request,
  Comparable Function(PendingRequestModel) getField, {
  bool asc = true,
}) {
  return List.from(request)
    ..sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return asc ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
}
