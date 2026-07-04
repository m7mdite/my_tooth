class AdvertisementModel {
  String? content;
  Image? image;
  String? createdBy;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AdvertisementModel(
      {this.content,
      this.image,
      this.createdBy,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AdvertisementModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    createdBy = json['created_by'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['created_by'] = createdBy;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Image {
  String? url;

  Image({this.url});

  Image.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}