// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';




class Member {

  int? id;
  String? name;
  String? email;
  String? position;
  String? image;
  Member({
    this.id,
    this.name,
    this.email,
    this.position,
    this.image,
  });



  Member copyWith({
    int? id,
    String? name,
    String? email,
    String? position,
    String? image,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      position: position ?? this.position,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'position': position,
      'image': image,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      position: map['position'] != null ? map['position'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Member(id: $id, name: $name, email: $email, position: $position, image: $image)';
  }

}



List<Member> members = [
  Member(
    id: 1,
    name: 'John Doe',
    email: 'john.doe@example.com',
    position: 'Mayor',
    image: 'https://example.com/images/john_doe.jpg',
  ),
  Member(
    id: 2,
    name: 'Jane Smith',
    email: 'jane.smith@example.com',
    position: 'Vice Mayor',
    image: 'https://example.com/images/jane_smith.jpg',
  ),
  Member(
    id: 3,
    name: 'Alex Johnson',
    email: 'alex.johnson@example.com',
    position: 'Secretary',
    image: 'https://example.com/images/alex_johnson.jpg',
  ),
  Member(
    id: 4,
    name: 'Emily Davis',
    email: 'emily.davis@example.com',
    position: 'Treasurer',
    image: 'https://example.com/images/emily_davis.jpg',
  ),
  Member(
    id: 5,
    name: 'Michael Brown',
    email: 'michael.brown@example.com',
    position: 'Public Relations Officer',
    image: 'https://example.com/images/michael_brown.jpg',
  ),
  Member(
    id: 6,
    name: 'Sophia Wilson',
    email: 'sophia.wilson@example.com',
    position: 'Auditor',
    image: 'https://example.com/images/sophia_wilson.jpg',
  ),
];
