import 'package:flutter/material.dart';
import 'dart:async'; // Added for Timer

class DownloadPatternScreen extends StatefulWidget {
  final String patternType;
  final String size;
  final Map<String, double> adjustments;

  const DownloadPatternScreen({
    Key? key,
    required this.patternType,
    required this.size,
    required this.adjustments,
  }) : super(key: key);

  @override
  State<DownloadPatternScreen> createState() => _DownloadPatternScreenState();
}

class _DownloadPatternScreenState extends State<DownloadPatternScreen> {
  bool _isDownloading = false;
  bool _downloadComplete = false;
  String _downloadProgress = '0%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Download Pattern',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Pattern Download!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Your pattern is ready for download.',
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Pattern Summary
            _buildSectionTitle('Pattern Summary'),
            const SizedBox(height: 12.0),
            _buildPatternSummary(),
            const SizedBox(height: 24.0),

            // File Options
            _buildSectionTitle('Download Options'),
            const SizedBox(height: 12.0),
            _buildDownloadOptions(),
            const SizedBox(height: 24.0),

            // Download Progress
            if (_isDownloading) ...[
              _buildSectionTitle('Download Progress'),
              const SizedBox(height: 12.0),
              _buildDownloadProgress(),
              const SizedBox(height: 24.0),
            ],

            // Download Complete
            if (_downloadComplete) ...[
              _buildSectionTitle('Download Complete'),
              const SizedBox(height: 12.0),
              _buildDownloadComplete(),
              const SizedBox(height: 24.0),
            ],

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildPatternSummary() {
    return Container(
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
          Row(
            children: [
              Icon(Icons.pattern, color: const Color(0xFF6A82FB)),
              const SizedBox(width: 8.0),
              const Text(
                'Pattern Details',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildSummaryItem('Pattern Type', widget.patternType),
          _buildSummaryItem('Base Size', widget.size),
          if (widget.adjustments['length'] != null)
            _buildSummaryItem(
              'Length Adjustment',
              '${widget.adjustments['length']} cm',
            ),
          if (widget.adjustments['neckDrop'] != null)
            _buildSummaryItem(
              'Neck Drop',
              '${widget.adjustments['neckDrop']} cm',
            ),
          if (widget.adjustments['neckWidth'] != null)
            _buildSummaryItem(
              'Neck Width',
              '${widget.adjustments['neckWidth']} cm',
            ),
          if (widget.adjustments['neckbandWidth'] != null)
            _buildSummaryItem(
              'Neckband Width',
              '${widget.adjustments['neckbandWidth']} cm',
            ),
          if (widget.adjustments['sleeveLength'] != null)
            _buildSummaryItem(
              'Sleeve Length',
              '${widget.adjustments['sleeveLength']} cm',
            ),
          if (widget.adjustments['hemWidth'] != null)
            _buildSummaryItem(
              'Hem Width',
              '${widget.adjustments['hemWidth']} cm',
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadOptions() {
    return Container(
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
        children: [
          _buildDownloadOption(
            title: 'DXF File',
            subtitle: 'Vector format for cutting machines',
            icon: Icons.file_download,
            color: const Color(0xFF4299E1),
            onTap: () => _downloadFile('DXF'),
          ),
          const SizedBox(height: 12.0),
          _buildDownloadOption(
            title: 'Adobe Illustrator File',
            subtitle: 'AI format for design software',
            icon: Icons.design_services,
            color: const Color(0xFFED8936),
            onTap: () => _downloadFile('AI'),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isDownloading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _isDownloading ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: _isDownloading ? Colors.grey[300]! : color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(icon, color: color, size: 24.0),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: _isDownloading ? Colors.grey[600] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: _isDownloading ? Colors.grey[400] : color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadProgress() {
    return Container(
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
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A82FB)),
                ),
              ),
              const SizedBox(width: 12.0),
              Text(
                'Processing pattern adjustments...',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          LinearProgressIndicator(
            value: _getProgressValue(),
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6A82FB)),
          ),
          const SizedBox(height: 8.0),
          Text(
            _downloadProgress,
            style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadComplete() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF48BB78).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFF48BB78).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: const Color(0xFF48BB78), size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Download Complete!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF48BB78),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Your pattern files have been successfully generated and downloaded.',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (!_isDownloading && !_downloadComplete) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _downloadAllFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A82FB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Download All Files',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        if (_downloadComplete) ...[
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Back to Adjustments',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: _sharePattern,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48BB78),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Share Pattern',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  double _getProgressValue() {
    final progress = _downloadProgress.replaceAll('%', '');
    return double.tryParse(progress) ?? 0.0;
  }

  void _downloadFile(String fileType) {
    setState(() {
      _isDownloading = true;
      _downloadProgress = '0%';
    });
    // Simulate download progress
    _simulateDownload(fileType);
  }

  void _downloadAllFiles() {
    setState(() {
      _isDownloading = true;
      _downloadProgress = '0%';
    });
    // Simulate download progress for all files
    _simulateDownload('All Files');
  }

  void _simulateDownload(String fileType) {
    int progress = 0;
    const duration = Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {
      progress += 5;
      setState(() {
        _downloadProgress = '$progress%';
      });
      if (progress >= 100) {
        timer.cancel();
        setState(() {
          _isDownloading = false;
          _downloadComplete = true;
        });
        _showDownloadSuccess(fileType);
      }
    });
  }

  void _showDownloadSuccess(String fileType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fileType downloaded successfully!'),
        backgroundColor: const Color(0xFF48BB78),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _sharePattern() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Pattern'),
          content: const Text(
            'Share your pattern with others via email, messaging, or social media.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A82FB),
                foregroundColor: Colors.white,
              ),
              child: const Text('Share'),
            ),
          ],
        );
      },
    );
  }

  void _showShareSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pattern shared successfully!'),
        backgroundColor: Color(0xFF48BB78),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
