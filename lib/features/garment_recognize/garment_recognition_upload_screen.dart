import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'recognition_result_screen.dart';

class GarmentRecognitionUploadScreen extends StatefulWidget {
  const GarmentRecognitionUploadScreen({Key? key}) : super(key: key);

  @override
  State<GarmentRecognitionUploadScreen> createState() =>
      _GarmentRecognitionUploadScreenState();
}

class _GarmentRecognitionUploadScreenState
    extends State<GarmentRecognitionUploadScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // 🔥 Using the same gradient from Login Page
  final LinearGradient _primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)], // Same as login page
  );

  final Color _textPrimary = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _primaryGradient, // Full background gradient
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Recognize Garment',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: _primaryGradient),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionCard(),
                const SizedBox(height: 24.0),
                _buildAIRecognitionCard(),
                const SizedBox(height: 24.0),
                Text(
                  'Upload Photo',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Take a photo or choose from gallery',
                  style: TextStyle(fontSize: 14.0, color: Colors.white70),
                ),
                const SizedBox(height: 16.0),
                if (_selectedImage == null)
                  _buildUploadSection()
                else
                  _buildImagePreview(),
                const SizedBox(height: 32.0),
                if (_selectedImage != null) _buildAnalyzeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // Semi-transparent card
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
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
          _buildInstructionItem(
            '1. Take a photo of someone wearing the garment',
            Icons.person_outline,
          ),
          _buildInstructionItem(
            '2. Ensure the garment is clearly visible',
            Icons.visibility,
          ),
          _buildInstructionItem(
            '3. Good lighting and clear background',
            Icons.wb_sunny_outlined,
          ),
          _buildInstructionItem(
            '4. Full body or upper body shot works best',
            Icons.crop_free,
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecognitionCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.psychology, color: Colors.white, size: 28.0),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Our AI will analyze garment style, fit & features to suggest matching patterns from the Pattern Room database.',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.0,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _processRecognition,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    'Analyzing...',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Text(
                'Analyze Garment',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(),
      child: Container(
        width: double.infinity,
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person_add, size: 50.0, color: Colors.white70),
            SizedBox(height: 12.0),
            Text(
              'Tap to upload garment photo',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              'Camera or Gallery',
              style: TextStyle(fontSize: 14.0, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              height: 300.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, size: 20.0),
                    label: const Text('Retake'),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library, size: 20.0),
                    label: const Text('Change'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: const Text(
          'Select Camera or Gallery to upload garment photo.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processRecognition() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              RecognitionResultScreen(imagePath: _selectedImage!.path),
        ),
      );
    }
  }
}
