import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'measurement_result_screen.dart';

class GarmentMeasurementUploadScreen extends StatefulWidget {
  const GarmentMeasurementUploadScreen({Key? key}) : super(key: key);

  @override
  State<GarmentMeasurementUploadScreen> createState() =>
      _GarmentMeasurementUploadScreenState();
}

class _GarmentMeasurementUploadScreenState
    extends State<GarmentMeasurementUploadScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _scaleReference;

  final List<Map<String, dynamic>> _scaleOptions = [
    {
      'name': 'Credit Card',
      'diameter': '85.6mm x 53.98mm',
      'description': 'Universal standard size - Most accurate',
      'icon': Icons.credit_card,
      'color': Color(0xFF6A82FB), // Updated to login theme
      'isRecommended': true,
    },
    {
      'name': 'Fit Finder',
      'diameter': 'AI-powered estimation',
      'description': 'Use AI to estimate without reference',
      'icon': Icons.psychology,
      'color': Color(0xFFFC5C7D), // Updated to login theme
      'isRecommended': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)], // Login gradient
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Measure Garment',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstructionCard(),
                  const SizedBox(height: 24.0),
                  _buildScaleReferenceSection(),
                  const SizedBox(height: 24.0),
                  _buildImageUploadSection(),
                  const SizedBox(height: 32.0),
                  if (_selectedImage != null) _buildProcessButton(),
                ],
              ),
            ),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  /// ------------------- UI COMPONENTS -------------------

  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)], // Login gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 12.0),
              const Expanded(
                child: Text(
                  'Upload Instructions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildInstructionItem('1. Lay your garment flat on a solid surface'),
          _buildInstructionItem('2. Ensure good lighting and no shadows'),
          _buildInstructionItem(
            '3. Place a credit card for scale or use AI-powered Fit Finder',
          ),
          _buildInstructionItem('4. Take photo from directly above'),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleReferenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scale Reference',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Use credit card for precise measurements or AI-powered Fit Finder for estimation',
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildScaleReferenceCard(
                _scaleOptions[0],
                _scaleReference == _scaleOptions[0]['name'],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScaleReferenceCard(
                _scaleOptions[1],
                _scaleReference == _scaleOptions[1]['name'],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScaleReferenceCard(
    Map<String, dynamic> option,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (option['name'] == 'Fit Finder') {
          _showFitFinderDialog();
        } else {
          setState(() => _scaleReference = option['name']);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? option['color'].withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? option['color'] : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: option['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(option['icon'], color: option['color'], size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              option['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? option['color'] : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              option['diameter'],
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              option['description'],
              style: TextStyle(fontSize: 9, color: Colors.grey[500]),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            _buildSelectionTag(isSelected, option),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTag(bool isSelected, Map<String, dynamic> option) {
    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: option['color'],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'SELECTED',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else if (option['isRecommended'] == true) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'RECOMMENDED',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Garment Photo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _selectedImage == null ? _buildUploadBox() : _buildImagePreview(),
      ],
    );
  }

  Widget _buildUploadBox() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Upload your garment photo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a photo or choose from gallery',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUploadButton(
                'Camera',
                Icons.camera_alt,
                () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(width: 16),
              _buildUploadButton(
                'Gallery',
                Icons.photo_library,
                () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A82FB), // Login button color
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildPreviewButton(
                    'Retake',
                    Icons.camera_alt,
                    () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPreviewButton(
                    'Change',
                    Icons.photo_library,
                    () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: const Color(0xFF2D3748),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildProcessButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _processMeasurement,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A82FB), // Login button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : const Text(
                'Process Measurement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  /// ------------------- FUNCTIONS -------------------

  void _showFitFinderDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.psychology, color: Colors.blue),
            SizedBox(width: 8),
            Text('Fit Finder'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'AI-powered measurement estimation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Fit Finder uses AI to estimate garment measurements without requiring a reference object.\n\n'
              '• No reference object needed\n• Faster measurement process\n• Works with any garment type\n• Approximate accuracy: 85-90%',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _scaleReference = 'Fit Finder (AI Estimation)');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFC5C7D), // Login theme secondary
              foregroundColor: Colors.white,
            ),
            child: const Text('Use Fit Finder'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', Colors.red);
    }
  }

  Future<void> _processMeasurement() async {
    if (_selectedImage == null || _scaleReference == null) {
      _showSnackBar(
        'Please select an image and scale reference',
        Colors.orange,
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeasurementResultScreen(
            imagePath: _selectedImage!.path,
            scaleReference: _scaleReference!,
          ),
        ),
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
