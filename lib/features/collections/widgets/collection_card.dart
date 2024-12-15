


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/helpers/formmater.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/collections/model/collection_item.dart';
import 'package:get/get.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CollectionCard({
    Key? key,
    required this.collection,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Title, Date, and Options
          _buildHeader(),

          const Gap(16),

          // Optional Description
          if (collection.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                collection.description!,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),

          // Chart
          SizedBox(
            height: 200,
            child: _buildChart(collection.type ?? 'Pie Chart', collection.items),
          ),
        ],
      ),
    );
  }

  /// Header Section
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                collection.title ?? 'No Title',
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Ensures text is visible
                ),
              ),
              const Gap(4),
              Text(
                collection.lastUpdated ?? 'No Date',
                style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey[800]),
              ),
              const Gap(4),
              Text(
                'Total: ₱ ${collection.formattedTotalAmount()}',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Palette.GREEN3,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the chart based on the collection type.
  Widget _buildChart(String chartType, List<CollectionItem>? items) {
    final data = items?.map((e) => e.amount?.toDouble() ?? 0.0).toList() ?? [];
    final labels = items?.map((e) => e.label ?? 'No Label').toList() ?? [];

    if (data.isEmpty || data.every((value) => value <= 0)) {
      return const Center(child: Text('No data available for the chart.'));
    }

    switch (chartType) {
      case 'Pie Chart':
        return PieChart(
          PieChartData(
            sections: _buildPieChartSections(data, labels),
            borderData: FlBorderData(show: false),
            sectionsSpace: 4,
            centerSpaceRadius: 50,
            centerSpaceColor: Colors.white,
          ),
        );

      case 'Bar Chart':
        return BarChart(
          BarChartData(
            barGroups: _buildBarChartGroups(data),
            titlesData: _buildChartTitles(labels),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true),
          ),
        );

      case 'Line Chart':
        return LineChart(
          LineChartData(
            lineBarsData: _buildLineChartData(data),
            titlesData: _buildChartTitles(labels),
            borderData: FlBorderData(show: false),
          ),
        );

      default:
        return const Center(child: Text('Invalid chart type.'));
    }
  }

  /// Chart Sections
  List<PieChartSectionData> _buildPieChartSections(
      List<double> data, List<String> labels) {
    final total = data.reduce((a, b) => a + b);
    return List.generate(data.length, (index) {
      final percentage = ((data[index] / total) * 100).toStringAsFixed(1);
      return PieChartSectionData(
        color: _getColor(index),
        value: data[index],
        title: '$percentage%',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  /// Chart Titles
  FlTitlesData _buildChartTitles(List<String> labels) {
    return FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < labels.length) {
              return Text(
                labels[index],
                style: Get.textTheme.bodySmall,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Bar Chart Groups
  List<BarChartGroupData> _buildBarChartGroups(List<double> data) {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index],
            color: _getColor(index),
            width: 16,
          ),
        ],
      );
    });
  }

  /// Line Chart Data
  List<LineChartBarData> _buildLineChartData(List<double> data) {
    return [
      LineChartBarData(
        spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index])),
        isCurved: true,
        color: Palette.GREEN3,
        belowBarData: BarAreaData(show: true, color: Palette.GREEN3.withOpacity(0.3)),
      ),
    ];
  }

  /// Color Mapping
  Color _getColor(int index) {
    const colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}
