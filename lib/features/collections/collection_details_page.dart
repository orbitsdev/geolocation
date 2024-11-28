import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/collections/model/collection_item.dart';
import 'package:geolocation/features/collections/widgets/reusable_chart.dart';


class CollectionDetailsPage extends StatelessWidget {
  final Collection collection;

  const CollectionDetailsPage({
    Key? key,
    required this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.title ?? 'Collection Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Summary
            Text(
              collection.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              'Last Updated: ${collection.lastUpdated ?? 'No Date'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const Gap(8),
            Text(
              'Total Amount: ₱${collection.formattedTotalAmount()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Gap(16),

            // Description
            if (collection.description != null) ...[
              Text(
                'Description',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                collection.description!,
                style: const TextStyle(fontSize: 16),
              ),
              const Gap(16),
            ],

            // Chart
            Text(
              'Chart Overview',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            SizedBox(
              height: 250,
              child: ReusableChart(
                chartType: collection.type ?? 'Pie Chart', // Chart type from the collection
                items: collection.items,
              ),
            ),
            const Gap(16),

            // Collection Items
            if (collection.items != null && collection.items!.isNotEmpty) ...[
              Text(
                'Items',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              ...collection.items!.map((item) => _buildCollectionItem(item)),
            ] else
              const Center(
                child: Text('No items available for this collection.'),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a card for each collection item.
  Widget _buildCollectionItem(CollectionItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.label ?? 'No Label',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '₱${item.amount?.toStringAsFixed(2) ?? '0.00'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
