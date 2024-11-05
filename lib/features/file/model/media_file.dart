
import 'dart:convert';

class MediaFile {
  String? url;
  String? type;
  MediaFile({
    this.url,
    this.type,
  });

  MediaFile copyWith({
    String? url,
    String? type,
  }) {
    return MediaFile(
      url: url ?? this.url,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': type,
    };
  }

  factory MediaFile.fromMap(Map<String, dynamic> map) {
    return MediaFile(
      url: map['url'] != null ? map['url'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaFile.fromJson(String source) => MediaFile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MediaFile(url: $url, type: $type)';

  @override
  bool operator ==(covariant MediaFile other) {
    if (identical(this, other)) return true;
  
    return 
      other.url == url &&
      other.type == type;
  }

  @override
  int get hashCode => url.hashCode ^ type.hashCode;
}