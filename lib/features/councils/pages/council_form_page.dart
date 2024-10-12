import 'package:flutter/material.dart';
import 'package:geolocation/features/councils/controller/council_controller.dart';
import 'package:get/get.dart';

class CouncilFormPage extends StatelessWidget {
  final bool isEdit;
  final int? councilId; // If editing, the councilId will be passed
  final _formKey = GlobalKey<FormState>();

  CouncilFormPage({this.isEdit = false, this.councilId});

  final councilController = Get.find<CouncilController>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    if (isEdit && councilId != null) {
      // If editing, load the council data and pre-fill the form
      final council = councilController.councils.firstWhere((c) => c.id == councilId);
      nameController.text = council.name ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Council' : 'Add Council'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Council Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a council name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (isEdit) {
                      // Update council
                      councilController.updateCouncil(councilId!, nameController.text);
                    } else {
                      // Create new council
                      councilController.createCouncil(nameController.text);
                    }
                    Get.back(); // Go back after successful form submission
                  }
                },
                child: Text(isEdit ? 'Update Council' : 'Add Council'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
