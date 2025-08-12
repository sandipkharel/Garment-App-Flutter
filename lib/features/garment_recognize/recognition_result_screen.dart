import 'package:flutter/material.dart';
import 'dart:io';

class RecognitionResultScreen extends StatefulWidget {
  final String imagePath;

  const RecognitionResultScreen({Key? key, required this.imagePath})
    : super(key: key);

  @override
  State<RecognitionResultScreen> createState() =>
      _RecognitionResultScreenState();
}

class _RecognitionResultScreenState extends State<RecognitionResultScreen> {
  // Updated gradient & colors (matching Login/Upload screens)
  final LinearGradient _primaryGradient = const LinearGradient(
    colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)], // ✅ Same as Login Page
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final Color _textPrimary = Colors.white;

  // Mock data for demonstration
  final Map<String, dynamic> _recognitionResult = {
    'garmentType': 'Casual T-Shirt',
    'confidence': 0.92,
    'styleFeatures': [
      'Round neckline',
      'Short sleeves',
      'Relaxed fit',
      'Cotton blend',
      'Solid color',
    ],
    'matchingPatterns': [
      {
        'name': 'Basic T-Shirt Pattern',
        'description': 'Classic crew neck t-shirt with short sleeves',
        'matchScore': 0.95,
        'price': '\$12.99',
        'image': 'assets/images/pattern1.png',
      },
      {
        'name': 'Relaxed Fit T-Shirt',
        'description': 'Comfortable loose-fitting t-shirt pattern',
        'matchScore': 0.88,
        'price': '\$14.99',
        'image': 'assets/images/pattern2.png',
      },
      {
        'name': 'Premium Cotton T-Shirt',
        'description': 'High-quality cotton t-shirt with detailed instructions',
        'matchScore': 0.82,
        'price': '\$18.99',
        'image': 'assets/images/pattern3.png',
      },
    ],
    'analysis': {
      'fit': 'Relaxed',
      'neckline': 'Round',
      'sleeveType': 'Short',
      'fabric': 'Cotton blend',
      'style': 'Casual',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _primaryGradient, // Full-screen gradient background
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Recognition Results',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: _primaryGradient),
          ),
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
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24.0),
              _buildCard(
                title: 'Style Analysis',
                icon: Icons.analytics,
                child: _buildAnalysisGrid(),
              ),
              const SizedBox(height: 24.0),
              _buildStyleFeatures(),
              const SizedBox(height: 24.0),
              Text(
                'Matching Patterns',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              ..._recognitionResult['matchingPatterns']
                  .map<Widget>((pattern) => _buildPatternCard(pattern))
                  .toList(),
              const SizedBox(height: 32.0),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ UI Sections ------------------

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.file(
                File(widget.imagePath),
                width: 80.0,
                height: 80.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _recognitionResult['garmentType'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[300],
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${(_recognitionResult['confidence'] * 100).toInt()}% Confidence',
                        style: TextStyle(
                          color: Colors.green[300],
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    IconData? icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 24.0),
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          else
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          const SizedBox(height: 16.0),
          child,
        ],
      ),
    );
  }

  Widget _buildStyleFeatures() {
    return _buildCard(
      title: 'Style Features',
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _recognitionResult['styleFeatures'].map<Widget>((feature) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPatternCard(Map<String, dynamic> pattern) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.pattern,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern['name'],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      pattern['description'],
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pattern['price'],
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${(pattern['matchScore'] * 100).toInt()}% Match',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.greenAccent[100],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewPatternDetails(pattern),
                  icon: const Icon(Icons.visibility, size: 16.0),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: _primaryGradient,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _addToCart(pattern),
                    icon: const Icon(Icons.shopping_cart, size: 16.0),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisGrid() {
    final analysis = _recognitionResult['analysis'];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 2.5,
      children: [
        _buildAnalysisItem('Fit', analysis['fit'], Icons.accessibility),
        _buildAnalysisItem('Neckline', analysis['neckline'], Icons.circle),
        _buildAnalysisItem('Sleeve', analysis['sleeveType'], Icons.style),
        _buildAnalysisItem('Fabric', analysis['fabric'], Icons.texture),
      ],
    );
  }

  Widget _buildAnalysisItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.0, color: Colors.white),
              const SizedBox(width: 4.0),
              Text(
                label,
                style: const TextStyle(fontSize: 12.0, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _tryAnotherPhoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Try Another Photo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: _primaryGradient,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ElevatedButton.icon(
              onPressed: _browseAllPatterns,
              icon: const Icon(Icons.search),
              label: const Text('Browse All Patterns'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------ Actions ------------------

  void _shareResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing recognition results...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _viewPatternDetails(Map<String, dynamic> pattern) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${pattern['name']}')),
    );
  }

  void _addToCart(Map<String, dynamic> pattern) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Added ${pattern['name']} to cart')));
  }

  void _tryAnotherPhoto() {
    Navigator.pop(context);
  }

  void _browseAllPatterns() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening pattern browser...')));
  }
}
