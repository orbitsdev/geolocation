import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/collections/create_collection_page.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fl_chart/fl_chart.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Collections', ),

         actions: [
              TextButton.icon(
                onPressed: () {
                  // Navigate to Create Post Page
                  Get.to(() => CreateCollectionPage(), transition: Transition.cupertino);
                },
                icon: Icon(Icons.create, color: Palette.PRIMARY),
                label: Text(
                  'Create Collection',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              ),
            ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childCount: 3, // Three types of charts for demonstration
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _buildCollectionCard(
                      context,
                      title: 'Pie Chart Collection',
                      description:
                          'This collection displays the data using a pie chart.',
                      date: 'Sep 10, 2024',
                      chartType: 'pie',
                      data: [30, 50, 20], // Example data for the chart
                      labels: ['Label1', 'Label2', 'Label3'], // Labels for the chart
                    );
                  case 1:
                    return _buildCollectionCard(
                      context,
                      title: 'Bar Chart Collection',
                      description:
                          'This collection displays the data using a bar chart.',
                      date: 'Sep 11, 2024',
                      chartType: 'bar',
                      data: [30, 50, 20], // Example data for the chart
                      labels: ['Label1', 'Label2', 'Label3'], // Labels for the chart
                    );
                  case 2:
                    return _buildCollectionCard(
                      context,
                      title: 'Line Chart Collection',
                      description:
                          'This collection displays the data using a line chart.',
                      date: 'Sep 12, 2024',
                      chartType: 'line',
                      data: [30, 50, 20], // Example data for the chart
                      labels: ['Label1', 'Label2', 'Label3'], // Labels for the chart
                    );
                  default:
                    return Container(); // Fallback in case of index out of bounds
                }
              },
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildCollectionCard(
    BuildContext context, {
    required String title,
    required String date,
    String? description,
    required String chartType,
    required List<double> data,
    required List<String> labels,
  }) {
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title, Date, and 3-Dot Menu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey[600]),
              onPressed: () {
                _showCollectionMenu(context);
              },
            ),
          ],
        ),
        SizedBox(height: 8),

        // Optional Description
        if (description != null) ...[
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
        ],

        // Chart
        SizedBox(
          height: 200, // Adjust as needed
          child: _buildChart(chartType, data, labels),
        ),
      ],
    ),
  );
}

void _showCollectionMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.edit, ),
            title: Text('Edit Collection'),
            onTap: () {
              // Handle edit action
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete,),
            title: Text('Delete Collection'),
            onTap: () {
              // Handle delete action
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

  Widget _buildChart(String chartType, List<double> data, List<String> labels) {
    switch (chartType) {
      case 'pie':
        return PieChart(
          PieChartData(
            sections: _buildPieChartSections(data, labels),
            borderData: FlBorderData(show: false),
          ),
        );
      case 'bar':
        return BarChart(
          BarChartData(
            barGroups: _buildBarChartGroups(data),
            borderData: FlBorderData(show: false),
          ),
        );
      case 'line':
        return LineChart(
          LineChartData(
            lineBarsData: _buildLineChartData(data),
            borderData: FlBorderData(show: false),
          ),
        );
      default:
        return Center(child: Text('Invalid chart type'));
    }
  }

  List<PieChartSectionData> _buildPieChartSections(List<double> data, List<String> labels) {
    return List.generate(data.length, (i) {
      return PieChartSectionData(
        color: _getColor(i),
        value: data[i],
        title: '${labels[i]}: ${data[i]}',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  List<BarChartGroupData> _buildBarChartGroups(List<double> data) {
    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i],
            color: _getColor(i),
            width: 20,
          ),
        ],
      );
    });
  }

  List<LineChartBarData> _buildLineChartData(List<double> data) {
    return [
      LineChartBarData(
        spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),
        isCurved: true,
        color:Colors.blue,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
      ),
    ];
  }

  Color _getColor(int index) {
    switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
