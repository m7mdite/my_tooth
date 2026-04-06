import '../../models/request_model.dart';

List<RequestReceiveModel> sortRequest<T extends Comparable>(
  List<RequestReceiveModel> request,
  Comparable Function(RequestReceiveModel) getField, {
  bool asc = true,
}) {
  return List.from(request)
    ..sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return asc ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
}
