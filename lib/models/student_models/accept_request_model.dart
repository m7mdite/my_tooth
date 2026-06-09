class AcceptRequestModel {
  String? date;
  String? hour;
  String? location;

  AcceptRequestModel({
    this.date,
    this.hour,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hour': hour,
      'location': location,
    };
  }
}
