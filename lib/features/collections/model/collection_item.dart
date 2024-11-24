// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CollectionItem {
  int? id;
  String? label;
  double? amount;

  CollectionItem({
    this.id,
    this.label,
    this.amount,
  });

  CollectionItem copyWith({
    int? id,
    String? label,
    double? amount,
  }) {
    return CollectionItem(
      id: id ?? this.id,
      label: label ?? this.label,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'amount': amount,
    };
  }

  factory CollectionItem.fromMap(Map<String, dynamic> map) {
    return CollectionItem(
      id: map['id'] != null ? map['id'] as int : null,
      label: map['label'] != null ? map['label'] as String : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionItem.fromJson(String source) =>
      CollectionItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CollectionItem(id: $id, label: $label, amount: $amount)';
}
