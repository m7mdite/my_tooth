class ConversationModel {
  String? conversationId;
  OtherPartyProfile? otherPartyProfile;
  int? count;
  List<Map>? messages;
  String? lastMessage;

  ConversationModel(
      {this.conversationId, this.otherPartyProfile, this.count, this.messages,this.lastMessage});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    lastMessage= json['last_message'] ?? "";
    conversationId = json['conversationId'];
    otherPartyProfile = json['otherPartyProfile'] != null
        ? OtherPartyProfile.fromJson(json['otherPartyProfile'])
        : null;
    count = json['count'];
    if (json['messages'] != null) {
      messages = <Map>[];
      json['messages'].forEach((v) {
        messages!.add(v);
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversationId'] = conversationId;
    if (otherPartyProfile != null) {
      data['otherPartyProfile'] = otherPartyProfile!.toJson();
    }
    data['count'] = count;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v).toList();
    }
    return data;
  }
}

class OtherPartyProfile {
  String? userId;
  String? fullName;
  ProfilePhoto? profilePhoto;
  String? role;

  OtherPartyProfile({this.userId, this.fullName, this.profilePhoto, this.role});

  OtherPartyProfile.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['full_name'];
    profilePhoto = json['profile_photo'] != null
        ? ProfilePhoto.fromJson(json['profile_photo'])
        : null;
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['full_name'] = fullName;
    if (profilePhoto != null) {
      data['profile_photo'] = profilePhoto!.toJson();
    }
    data['role'] = role;
    return data;
  }
}

class ProfilePhoto {
  String? url;

  ProfilePhoto({this.url});

  ProfilePhoto.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}