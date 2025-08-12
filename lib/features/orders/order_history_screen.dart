import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildOrderCard(
            context,
            orderId: 'ORD-20250801-001',
            date: '2025-08-01',
            pattern: 'T-Shirt',
            size: 'M',
            status: 'Completed',
            files: ['DXF', 'AI'],
          ),
          _buildOrderCard(
            context,
            orderId: 'ORD-20250725-002',
            date: '2025-07-25',
            pattern: 'Pants',
            size: 'L',
            status: 'Completed',
            files: ['DXF'],
          ),
          // Add more order cards as needed
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String orderId,
    required String date,
    required String pattern,
    required String size,
    required String status,
    required List<String> files,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #$orderId',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: status == 'Completed'
                        ? const Color(0xFF48BB78)
                        : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text('Date: $date', style: const TextStyle(fontSize: 14.0)),
            const SizedBox(height: 4.0),
            Text('Pattern: $pattern', style: const TextStyle(fontSize: 14.0)),
            const SizedBox(height: 4.0),
            Text('Size: $size', style: const TextStyle(fontSize: 14.0)),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.file_download, size: 18, color: Color(0xFF6B73FF)),
                const SizedBox(width: 6.0),
                ...files.map((file) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(file),
                        backgroundColor: const Color(0xFF6B73FF).withOpacity(0.1),
                        labelStyle: const TextStyle(color: Color(0xFF6B73FF)),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Download pattern files
                  },
                  icon: const Icon(Icons.download, color: Color(0xFF4299E1)),
                  label: const Text('Download'),
                ),
                const SizedBox(width: 8.0),
                TextButton.icon(
                  onPressed: () {
                    // TODO: View order details
                  },
                  icon: const Icon(Icons.info_outline, color: Color(0xFF6B73FF)),
                  label: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
