class CachedImage {
  final String id;
  final String url;
  final String localPath;
  final DateTime cachedAt;
  final int size;
  final String? etag;
  final DateTime? lastModified;

  CachedImage({
    required this.id,
    required this.url,
    required this.localPath,
    required this.cachedAt,
    required this.size,
    this.etag,
    this.lastModified,
  });

  factory CachedImage.fromJson(Map<String, dynamic> json) {
    return CachedImage(
      id: json['id'],
      url: json['url'],
      localPath: json['localPath'],
      cachedAt: DateTime.parse(json['cachedAt']),
      size: json['size'],
      etag: json['etag'],
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'localPath': localPath,
      'cachedAt': cachedAt.toIso8601String(),
      'size': size,
      'etag': etag,
      'lastModified': lastModified?.toIso8601String(),
    };
  }
}