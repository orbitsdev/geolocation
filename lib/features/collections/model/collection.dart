// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/collections/model/collection_item.dart';
import 'package:geolocation/features/councils/model/council.dart';

class Collection {
  int? id;
  String? title;
  String? type;
  String? description;
  double? totalAmount;
  int? itemCount;
  String? lastUpdated;
  Council? council;
  CouncilPosition? councilPosition;
  List<CollectionItem>? items;

  Collection({
    this.id,
    this.title,
    this.type,
    this.description,
    this.totalAmount,
    this.itemCount,
    this.lastUpdated,
    this.council,
    this.councilPosition,
    this.items,
  });

  Collection copyWith({
    int? id,
    String? title,
    String? type,
    String? description,
    double? totalAmount,
    int? itemCount,
    String? lastUpdated,
    Council? council,
    CouncilPosition? councilPosition,
    List<CollectionItem>? items,
  }) {
    return Collection(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      itemCount: itemCount ?? this.itemCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      council: council ?? this.council,
      councilPosition: councilPosition ?? this.councilPosition,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'total_amount': totalAmount,
      'item_count': itemCount,
      'last_updated': lastUpdated,
      'council': council?.toMap(),
      'council_position': councilPosition?.toMap(),
      'items': items?.map((x) => x.toMap()).toList(),
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      totalAmount:
          map['total_amount'] != null ? map['total_amount'] as double : null,
      itemCount: map['item_count'] != null ? map['item_count'] as int : null,
      lastUpdated:
          map['last_updated'] != null ? map['last_updated'] as String : null,
      council:
          map['council'] != null ? Council.fromMap(map['council']) : null,
      councilPosition: map['council_position'] != null
          ? CouncilPosition.fromMap(map['council_position'])
          : null,
      items: map['items'] != null
          ? List<CollectionItem>.from(
              (map['items'] as List).map((x) => CollectionItem.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Collection.fromJson(String source) =>
      Collection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Collection(id: $id, title: $title, type: $type, description: $description, totalAmount: $totalAmount, itemCount: $itemCount, lastUpdated: $lastUpdated, council: $council, councilPosition: $councilPosition, items: $items)';
  }
}
