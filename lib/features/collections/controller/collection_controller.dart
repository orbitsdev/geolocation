import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/collections/create_or_edit_collection_page.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/collections/model/collection_item.dart';
import 'package:get/get.dart';

class CollectionController extends GetxController {
  static CollectionController controller = Get.find();
  final formKey = GlobalKey<FormBuilderState>();

  // Static chart options
  final List<String> chartOptions = [
    'Pie Chart',
    'Bar Chart',
    'Line Chart',
    // 'Scatter Chart',
    // 'Radar Chart'
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

  var isPublish = true.obs; // Default to true

  /// Fetch collections for a council
  Future<void> loadData() async {
        print(' post stage');

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
        var data = success.data;
      
        collections.value = List<Collection>.from((data['data'] as List<dynamic>).map((e) => Collection.fromMap(e)));
        lastTotalValue.value = success.data['pagination']['total'];
        hasData.value = collections.length < lastTotalValue.value;
        isPageLoading(false);
        update();
      },
    );
  }
  Future<void> loadDataOnScroll() async {
  if (isScrollLoading.value) return;

  isScrollLoading(true);
  update();

  var response = await ApiService.getAuthenticatedResource(
    '/collections/council',
    queryParameters: {'page': page.value, 'perPage': perPage.value},
  );

  response.fold(
    (failure) {
      isScrollLoading(false); // Ensure it's reset even on failure
      update();
      Modal.errorDialog(failure: failure);
    },
    (success) {
      var data = success.data;

        print('SCROLL----------------');
        print(data);
        print('COLECIOn----------------');

      // Check if the total count has changed; refresh the data if necessary
      if (lastTotalValue.value != data['pagination']['total']) {
        isScrollLoading(false); // Reset loading state
        loadData();
        return;
      }

      // Prevent additional calls if we've reached the total number of items
      if (collections.length == data['pagination']['total']) {
        isScrollLoading(false); // Reset loading state
        return;
      }

      // Add the new data to the collection
      List<Collection> newData = (data['data'] as List<dynamic>)
          .map((task) => Collection.fromMap(task))
          .toList();
      collections.addAll(newData);

      // Update pagination values
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = collections.length < lastTotalValue.value;

      // Reset loading state
      isScrollLoading(false);
      update();
        
  print('----------------');
  print(isScrollLoading);
  print('------------------');
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
    Modal.loading();

    final formData = formKey.currentState!.value;

     isLoading(true);
    update();

    var requestData = {
      'title': formData['title'],
      'type': formData['chart_type'],
      'description': formData['description'],
       'is_publish': formData['is_publish'] ?? true, // Include is_publish with default true
      'items': collectionItems.map((item) => {'label': item.label, 'amount': item.amount}).toList(),
    };

   
  print('----------------');
  print(requestData);
  print('------------------');
   
    var response = await ApiService.postAuthenticatedResource('/collections', requestData);

    response.fold(
      (failure) {
        Get.back();
        isLoading(false);
        update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
         Get.back();
        isLoading(false);
        update();
              loadData();
                    clearForm();
        Get.offNamedUntil('/collections', (route) => route.isFirst);
        Modal.success(message: 'Collection created successfully');
            
      },
    );
  }

  /// Update an existing collection
 Future<void> updateCollection() async {
  if (!formKey.currentState!.saveAndValidate()) {
    
    return;
  }

  if (collectionItems.isEmpty) {
    Modal.warning(message: 'Please add at least one item to the collection.');
    return;
  }

  Modal.loading();

  final formData = formKey.currentState!.value;
  final collectionId = selectedItem.value.id;

  isLoading(true);
  update();

  var requestData = {
    'title': formData['title'],
    'type': formData['chart_type'],
    'description': formData['description'],
    'is_publish': formData['is_publish'],
    'items': collectionItems.map((item) {
      return {
        'id': item.id, // Optional, can be null for new items
        'label': item.label,
        'amount': item.amount,
      };
    }).toList(),
  };

  print('--- Update Collection Request ---');
  print(requestData);
  print('--------------------------------');

  var response = await ApiService.putAuthenticatedResource(
    '/collections/$collectionId',
    requestData,
  );

  response.fold(
    (failure) {
      Get.back(); // Close the loading dialog
      isLoading(false);
      update();
      Modal.errorDialog(failure: failure);
    },
    (success) {
      Get.back(); // Close the loading dialog
      isLoading(false);
      update();
      clearForm();
      loadData();
      Get.offNamedUntil('/collections', (route) => route.isFirst);
      
      Modal.success(message: 'Collection updated successfully');
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
    collectionItems.add(CollectionItem(label: '', amount: 0));
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
    if (selectedItem.value.id == null) return;

    print('FILl----------------------');
    print(selectedItem.value.isPublish);
    final formData = {
      'title': selectedItem.value.title ?? '',
      'chart_type': selectedItem.value.type ?? '',
      'description': selectedItem.value.description ?? '',
      'is_publish': selectedItem.value.isPublish ?? false,
    };
    
     WidgetsBinding.instance.addPostFrameCallback((_) {
      formKey.currentState?.patchValue(formData); // Populate the form with values
    collectionItems.value = selectedItem.value.items ?? [];
     isPublish.value = selectedItem.value.isPublish ?? true; // Populate publish state
      update(); // Ensure GetX reflects state
    });
    
  }

   Future<void> deleteCollection(int collectionId) async {
    Modal.confirmation(
      titleText: 'Delete Collection',
      contentText: 'Are you sure you want to delete this collection?',
      onConfirm: () async {
        isLoading(true);
        update();

        var response = await ApiService.deleteAuthenticatedResource(
          '/collections/$collectionId',
        );

        response.fold(
          (failure) {
            isLoading(false);
            update();
            Modal.errorDialog(failure: failure);
          },
          (success) {
            collections.removeWhere((collection) => collection.id == collectionId);
            isLoading(false);
            update();
            Modal.success(message: 'Collection deleted successfully');
          },
        );
      },
    );
  }
void selectItemAndNavigateToUpdatePage(Collection collection) {
  Get.to(
    () => CreateOrEditCollectionPage(isEditMode: true),
    arguments: collection, // Pass the collection as an argument
  );
}

  void setSelectedItemAndFilForm(Collection item){
    WidgetsBinding.instance.addPostFrameCallback((_) {
    selectedItem(item);
    update();
    fillForm();

    });
  }


   void clearForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    selectedItem(Collection());
    collectionItems.clear();
    formKey.currentState?.reset(); // Reset the form fields
    update();
    });
   
  }


  
}
