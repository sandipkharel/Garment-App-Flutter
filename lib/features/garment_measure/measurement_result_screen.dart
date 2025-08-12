import 'package:flutter/material.dart';
import 'dart:io';

class MeasurementResultScreen extends StatefulWidget {
  final String imagePath;
  final String scaleReference;

  const MeasurementResultScreen({
    Key? key,
    required this.imagePath,
    required this.scaleReference,
  }) : super(key: key);

  @override
  State<MeasurementResultScreen> createState() =>
      _MeasurementResultScreenState();
}

class _MeasurementResultScreenState extends State<MeasurementResultScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showKeypoints = true;
  bool _showMeasurements = true;

  // Mock measurement data - in real app, this would come from AI processing
  final Map<String, double> _measurements = {
    'Chest Width': 20.5,
    'Waist Width': 18.2,
    'Hip Width': 21.8,
    'Shoulder Width': 16.4,
    'Sleeve Length': 25.3,
    'Garment Length': 28.7,
    'Neck Width': 7.2,
    'Armhole Depth': 8.9,
  };

  final Map<String, String> _sizeComparison = {
    'XS': 'Too Small',
    'S': 'Too Small',
    'M': 'Perfect Fit',
    'L': 'Too Large',
    'XL': 'Too Large',
    'XXL': 'Too Large',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Measurement Results',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareResults,
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveMeasurements,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF6B73FF),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF6B73FF),
              tabs: const [
                Tab(text: 'Image'),
                Tab(text: 'Measurements'),
                Tab(text: 'Analysis'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildImageTab(),
                _buildMeasurementsTab(),
                _buildAnalysisTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Overlay Controls
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Image Container
                Container(
                  width: double.infinity,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    image: DecorationImage(
                      image: FileImage(File(widget.imagePath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: _showKeypoints ? _buildKeypointOverlay() : null,
                ),

                // Overlay Controls
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildToggleButton(
                          'Keypoints',
                          Icons.gps_fixed,
                          _showKeypoints,
                          (value) => setState(() => _showKeypoints = value),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: _buildToggleButton(
                          'Measurements',
                          Icons.straighten,
                          _showMeasurements,
                          (value) => setState(() => _showMeasurements = value),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24.0),

          // AI Confidence Score
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF48BB78), Color(0xFF38A169)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Confidence Score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        '94.2% - High Accuracy',
                        style: TextStyle(color: Colors.white70, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '94.2%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypointOverlay() {
    return Stack(
      children: [
        // Keypoint markers
        Positioned(
          top: 50.0,
          left: 80.0,
          child: _buildKeypointMarker('Chest', Colors.red),
        ),
        Positioned(
          top: 120.0,
          left: 85.0,
          child: _buildKeypointMarker('Waist', Colors.blue),
        ),
        Positioned(
          top: 180.0,
          left: 90.0,
          child: _buildKeypointMarker('Hip', Colors.green),
        ),
        Positioned(
          top: 30.0,
          left: 40.0,
          child: _buildKeypointMarker('Shoulder', Colors.orange),
        ),
        Positioned(
          top: 60.0,
          left: 20.0,
          child: _buildKeypointMarker('Sleeve', Colors.purple),
        ),

        // Measurement lines
        if (_showMeasurements) ...[
          _buildMeasurementLine(
            Offset(80.0, 50.0),
            Offset(200.0, 50.0),
            '20.5"',
            Colors.red,
          ),
          _buildMeasurementLine(
            Offset(85.0, 120.0),
            Offset(195.0, 120.0),
            '18.2"',
            Colors.blue,
          ),
        ],
      ],
    );
  }

  Widget _buildKeypointMarker(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMeasurementLine(
    Offset start,
    Offset end,
    String measurement,
    Color color,
  ) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 300.0),
      painter: MeasurementLinePainter(
        start: start,
        end: end,
        measurement: measurement,
        color: color,
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFF6B73FF).withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: value
                ? const Color(0xFF6B73FF)
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.0,
              color: value ? const Color(0xFF6B73FF) : Colors.grey,
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: value ? const Color(0xFF6B73FF) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Measurements Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B73FF), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Extracted Measurements',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Scale Reference: ${widget.scaleReference}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14.0),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24.0),

          // Measurements Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 1.5,
            ),
            itemCount: _measurements.length,
            itemBuilder: (context, index) {
              String key = _measurements.keys.elementAt(index);
              double value = _measurements.values.elementAt(index);
              return _buildMeasurementCard(key, value);
            },
          ),

          const SizedBox(height: 24.0),

          // Export Options
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Export Measurements',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _exportToPDF,
                        icon: const Icon(Icons.picture_as_pdf, size: 20.0),
                        label: const Text('PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53E3E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _exportToCSV,
                        icon: const Icon(Icons.table_chart, size: 20.0),
                        label: const Text('CSV'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF48BB78),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementCard(String measurement, double value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            measurement,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '${value.toStringAsFixed(1)}"',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B73FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Size Comparison
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF48BB78), Color(0xFF38A169)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Size Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildSizeComparisonItem('XS', 'Too Small', Colors.red),
                _buildSizeComparisonItem('S', 'Too Small', Colors.red),
                _buildSizeComparisonItem(
                  'M',
                  'Perfect Fit',
                  Colors.green,
                  isRecommended: true,
                ),
                _buildSizeComparisonItem('L', 'Too Large', Colors.orange),
                _buildSizeComparisonItem('XL', 'Too Large', Colors.orange),
                _buildSizeComparisonItem('XXL', 'Too Large', Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 24.0),

          // AI Recommendations
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B73FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFF6B73FF),
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    const Text(
                      'AI Recommendations',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildRecommendationItem(
                  'Size M fits perfectly based on your measurements',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildRecommendationItem(
                  'Consider a slightly longer sleeve for better fit',
                  Icons.info_outline,
                  Colors.blue,
                ),
                _buildRecommendationItem(
                  'Waist measurement suggests a tailored fit',
                  Icons.tune,
                  Colors.orange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24.0),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _findSimilarPatterns,
                  icon: const Icon(Icons.search, size: 20.0),
                  label: const Text('Find Patterns'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B73FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _adjustPattern,
                  icon: const Icon(Icons.tune, size: 20.0),
                  label: const Text('Adjust Pattern'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48BB78),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeComparisonItem(
    String size,
    String status,
    Color color, {
    bool isRecommended = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: isRecommended ? Colors.white : color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
              border: isRecommended
                  ? Border.all(color: Colors.white, width: 2.0)
                  : null,
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isRecommended ? const Color(0xFF48BB78) : color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              status,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Text(
                'RECOMMENDED',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF48BB78),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14.0, color: Color(0xFF2D3748)),
            ),
          ),
        ],
      ),
    );
  }

  void _shareResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing measurement results...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _saveMeasurements() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Measurements saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting to PDF...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _exportToCSV() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting to CSV...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _findSimilarPatterns() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Finding similar patterns...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _adjustPattern() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening pattern adjustment...'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}

class MeasurementLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final String measurement;
  final Color color;

  MeasurementLinePainter({
    required this.start,
    required this.end,
    required this.measurement,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw line
    canvas.drawLine(start, end, paint);

    // Draw measurement text
    final textPainter = TextPainter(
      text: TextSpan(
        text: measurement,
        style: TextStyle(
          color: color,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final center = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2 - 10,
    );

    // Draw background for text
    final backgroundRect = Rect.fromCenter(
      center: center,
      width: textPainter.width + 8,
      height: textPainter.height + 4,
    );

    final backgroundPaint = Paint()..color = Colors.white.withOpacity(0.9);

    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, const Radius.circular(4.0)),
      backgroundPaint,
    );

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
