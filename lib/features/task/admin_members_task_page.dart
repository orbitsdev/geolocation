import 'package:flutter/material.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AdminTaskCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar
          SliverAppBar(
            

            flexibleSpace: FlexibleSpaceBar(
              title: Text('Manage Task'),
              background: Image.network(
                'https://i.pravatar.cc/600',
                fit: BoxFit.cover,
              ),
            ),
            pinned: true,
          ),

          // Sliver List for Task Details and Files
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Officer Information Section
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Finance Officer',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Task Details Section
                  Text(
                    'Budget Report Review',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Review the submitted budget report and provide feedback.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Due Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Oct 15, 2024',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Static Attached Files Section
                  Text(
                    'Submitted Files',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    
                    
                    leading: Icon(Icons.insert_drive_file, color: Colors.grey[600]),
                    title: Text(
                      'Budget_Report_Q3_2024.pdf',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    onTap: () {
                     Modal.showToast(msg: 'function is not available for now');
                    },
                  ),
                  ListTile(
                    
                    leading: Icon(Icons.insert_drive_file, color: Colors.grey[600]),
                    title: Text(
                      'Strategic_Planning_Overview.docx',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    onTap: () {
                     Modal.showToast(msg: 'function is not available for now');
                    },
                  ),
                  ListTile(
                    
                    leading: Icon(Icons.insert_drive_file, color: Colors.grey[600]),
                    title: Text(
                      'Project_Timeline_Gantt_Chart.xlsx',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    onTap: () {
                     Modal.showToast(msg: 'function is not available for now');
                    },
                  ),
                  ListTile(
                    
                    leading: Icon(Icons.insert_drive_file, color: Colors.grey[600]),
                    title: Text(
                      'Executive_Summary_Presentation.pptx',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    onTap: () {
                     Modal.showToast(msg: 'function is not available for now');
                    },
                  ),
                ],
              ),
            ),
          ),

          // Sliver FillRemaining for Buttons at the Bottom
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                       Modal.showToast(msg: 'function is not available for now');
                       Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Approve',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                       Modal.showToast(msg: 'function is not available for now');
                       Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    
                    ),
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
