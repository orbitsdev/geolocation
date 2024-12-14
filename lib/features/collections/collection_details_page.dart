// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:geolocation/features/collections/model/collection.dart';
// import 'package:geolocation/features/collections/model/collection_item.dart';
// import 'package:geolocation/features/collections/widgets/reusable_chart.dart';


// class CollectionDetailsPage extends StatelessWidget {
//   final Collection collection;

//   const CollectionDetailsPage({
//     Key? key,
//     required this.collection,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(collection.title ?? 'Collection Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title and Summary
//             Text(
//               collection.title ?? 'No Title',
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Gap(8),
//             Text(
//               'Last Updated: ${collection.lastUpdated ?? 'No Date'}',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const Gap(8),
//             Text(
//               'Total Amount: ₱${collection.formattedTotalAmount()}',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const Gap(16),

//             // Description
//             if (collection.description != null) ...[
//               Text(
//                 'Description',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Gap(8),
//               Text(
//                 collection.description!,
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const Gap(16),
//             ],

//             // Chart
//             Text(
//               'Chart Overview',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Gap(8),
//             SizedBox(
//               height: 250,
//               child: ReusableChart(
//                 chartType: collection.type ?? 'Pie Chart', // Chart type from the collection
//                 items: collection.items,
//               ),
//             ),
//             const Gap(16),

//             // Collection Items
//             if (collection.items != null && collection.items!.isNotEmpty) ...[
//               Text(
//                 'Items',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Gap(8),
//               ...collection.items!.map((item) => _buildCollectionItem(item)),
//             ] else
//               const Center(
//                 child: Text('No items available for this collection.'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Builds a card for each collection item.
//   Widget _buildCollectionItem(CollectionItem item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             item.label ?? 'No Label',
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             '₱${item.amount?.toStringAsFixed(2) ?? '0.00'}',
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/collections/model/collection_item.dart';
import 'package:geolocation/features/collections/widgets/reusable_chart.dart';
import 'package:get/get.dart';

class CollectionDetailsPage extends StatelessWidget {
  final Collection collection;

  const CollectionDetailsPage({
    Key? key,
    required this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Palette.FBG,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
        'Collection Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),

            const Gap(24),

            // Chart Section
            _buildChartSection(),

            const Gap(24),

            // Items Section
            _buildItemsSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the header section with title, summary, and description.
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: Get.size.width,),
          Text(
            collection.title ?? 'No Title',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Gap(8),
          Text(
            'Last Updated: ${collection.lastUpdated ?? 'No Date'}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const Gap(8),
          Text(
            'Total Amount: ₱${collection.formattedTotalAmount()}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          if (collection.description != null) ...[
            const Gap(16),
            Text(
              'Description:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Gap(8),
            Text(
              collection.description!,
              style:  TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the chart section.
  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chart Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Gap(16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 250,
            child: ReusableChart(
              chartType: collection.type ?? 'Pie Chart',
              items: collection.items,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the items section.
  Widget _buildItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Gap(16),
        if (collection.items != null && collection.items!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: collection.items!.length,
            itemBuilder: (context, index) {
              return _buildCollectionItem(collection.items![index]);
            },
          )
        else
          const Center(
            child: Text(
              'No items available for this collection.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),

           Container(
      // margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.8)))
        // borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     blurRadius: 6,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
               'TOTAL',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Gap(12),
          Text(
            '₱${collection.formattedTotalAmount()}',
            style:  TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
               color: Palette.GREEN3,
            ),
          ),
        ],
      ),
    )
      ],
    );
  }

  /// Builds a card for each collection item.
  Widget _buildCollectionItem(CollectionItem item) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.8)))
        // borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     blurRadius: 6,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.label ?? 'No Label',
              style: const TextStyle(
                fontSize: 14,
                // fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Gap(12),
          Text(
            '₱${item.amount?.toStringAsFixed(2) ?? '0.00'}',
            style:  TextStyle(
              fontSize: 14,
              // fontWeight: FontWeight.bold,
              color: Palette.GREEN3,
            ),
          ),
        ],
      ),
    );
  }
}
