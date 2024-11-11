import 'dart:convert';

class MediaFile {
  int? id;       // Added to track specific media file IDs
  String? url;   // URL of the media file
  String? type;  // MIME type of the media file
  String? extension; // File extension (e.g., jpg, pdf)

  MediaFile({
    this.id,
    this.url,
    this.type,
    this.extension,
  });

  MediaFile copyWith({
    int? id,
    String? url,
    String? type,
    String? extension,
  }) {
    return MediaFile(
      id: id ?? this.id,
      url: url ?? this.url,
      type: type ?? this.type,
      extension: extension ?? this.extension,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'type': type,
      'extension': extension,
    };
  }

  factory MediaFile.fromMap(Map<String, dynamic> map) {
    return MediaFile(
      id: map['id'] != null ? map['id'] as int : null,
      url: map['url'] != null ? map['url'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      extension: map['extension'] != null ? map['extension'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaFile.fromJson(String source) => MediaFile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MediaFile(id: $id, url: $url, type: $type, extension: $extension)';

  @override
  bool operator ==(covariant MediaFile other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.url == url &&
      other.type == type &&
      other.extension == extension;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ type.hashCode ^ extension.hashCode;
}
