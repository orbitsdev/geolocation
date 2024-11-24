import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/collections/model/collection_item.dart';
import 'package:get/get.dart';

class CollectionController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();

  // Static chart options
  final List<String> chartOptions = [
    'Pie Chart',
    'Bar Chart',
    'Line Chart',
    'Scatter Chart',
    'Radar Chart'
  ];

  var isPageLoading = false.obs;
  var isScrollLoading = false.obs;
  var isLoading = false.obs;
  var page = 1.obs;
  var perPage = 10.obs;
  var lastTotalValue = 0.obs;
  var hasData = false.obs;
  var collections = <Collection>[].obs;
  var collectionItems = <CollectionItem>[].obs; // Dynamic item addition/removal
  var selectedItem = Collection().obs;

  /// Fetch collections for a council
  Future<void> fetchByCouncil() async {
    isPageLoading(true);
    update();

    var response = await ApiService.getAuthenticatedResource(
      '/collections/council',
      queryParameters: {'page': page.value, 'perPage': perPage.value},
    );

    response.fold(
      (failure) {
        isPageLoading(false);
        update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
        var data = success.data['data'];
        collections.value = List<Collection>.from(data.map((e) => Collection.fromMap(e)));
        lastTotalValue.value = success.data['pagination']['total'];
        hasData.value = collections.length < lastTotalValue.value;
        isPageLoading(false);
        update();
      },
    );
  }

  /// Create a new collection
  Future<void> createCollection() async {
    if (!formKey.currentState!.saveAndValidate()) {
      // Modal.warning(message: 'Please correct the errors in the form.');
      return;
    } 

    if (collectionItems.isEmpty) {
    Modal.warning(message: 'Please add at least one item to the collection.');
    return;
  }

    final formData = formKey.currentState!.value;

    // isLoading(true);
    update();

    var requestData = {
      'title': formData['title'],
      'type': formData['chart_type'],
      'description': formData['description'],
      'items': collectionItems.map((item) => {'label': item.label, 'amount': item.amount}).toList(),
    };

    print('-----------------------');
    print(requestData);
    print('-----------------------');
    return;
    var response = await ApiService.postAuthenticatedResource('/collections', requestData);

    response.fold(
      (failure) {
        isLoading(false);
        update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
        isLoading(false);
        update();
        Modal.success(message: 'Collection created successfully');
        Get.back(); // Navigate back to the previous page
      },
    );
  }

  /// Update an existing collection
  Future<void> updateCollection() async {
    if (!formKey.currentState!.saveAndValidate()) {
      Modal.warning(message: 'Please correct the errors in the form.');
      return;
    }

    final formData = formKey.currentState!.value;
    final collectionId = selectedItem.value.id;

    isLoading(true);
    update();

    var requestData = {
      'title': formData['title'],
      'type': formData['chart_type'],
      'description': formData['description'],
      'items': collectionItems.map((item) {
        return {'id': item.id, 'label': item.label, 'amount': item.amount};
      }).toList(),
    };

    var response = await ApiService.putAuthenticatedResource('/collections/$collectionId', requestData);

    response.fold(
      (failure) {
        isLoading(false);
        update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
        isLoading(false);
        update();
        Modal.success(message: 'Collection updated successfully');
        Get.back();
      },
    );
  }

  /// Remove an item from the database
  Future<void> removeItemFromDatabase(int collectionId, int itemId) async {
    isLoading(true);
    update();

    var response = await ApiService.deleteAuthenticatedResource('/collections/$collectionId/items/$itemId');

    response.fold(
      (failure) {
        isLoading(false);
        update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
        isLoading(false);
        removeItemLocally(itemId);
        update();
        Modal.success(message: 'Item removed successfully');
      },
    );
  }

  /// Add a new item locally
  void addItem() {
    if (collectionItems.length >= 10) {
        Modal.warning(message: 'You can only add up to 10 items.');
        return;
    }
    collectionItems.add(CollectionItem(label: '', amount: 0.0));
    update();
}

  /// Remove an item locally
  void removeItem(int index) {
    collectionItems.removeAt(index);
    update();
  }

  /// Remove an item locally by ID
  void removeItemLocally(int itemId) {
    collectionItems.removeWhere((item) => item.id == itemId);
    update();
  }

  /// Fill the form for editing
  void fillForm() {
    final formData = {
      'title': selectedItem.value.title,
      'chart_type': selectedItem.value.type,
      'description': selectedItem.value.description,
    };

    formKey.currentState?.patchValue(formData);
    collectionItems.value = selectedItem.value.items ?? [];
  }
}
