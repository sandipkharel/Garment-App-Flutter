import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'download_pattern_screen.dart';

class PatternAdjustmentScreen extends StatefulWidget {
  const PatternAdjustmentScreen({Key? key}) : super(key: key);

  @override
  State<PatternAdjustmentScreen> createState() =>
      _PatternAdjustmentScreenState();
}

class _PatternAdjustmentScreenState extends State<PatternAdjustmentScreen> {
  final _formKey = GlobalKey<FormState>();
  // Adjustment controllers
  final TextEditingController _neckDropController = TextEditingController();
  final TextEditingController _sleeveLengthController = TextEditingController();
  final TextEditingController _hemWidthController = TextEditingController();
  final TextEditingController _neckWidthController = TextEditingController();
  final TextEditingController _neckbandWidthController =
      TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _waistWidthController = TextEditingController();
  final TextEditingController _hipWidthController = TextEditingController();
  final TextEditingController _inseamLengthController = TextEditingController();
  final TextEditingController _riseController = TextEditingController();
  // Pattern type selection
  String _selectedPatternType = 'Tshirt';
  String _selectedSize = 'M';
  // Preview state
  bool _showPreview = false;
  bool _isProcessing = false;

  final List<String> _patternTypes = [
    'Tshirt',
    'Singlet',
    'Jumper',
    'Jacket',
    'Legging',
    'Trackpant',
    'Trackshort',
  ];

  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  // Define which fields are shown for each pattern type
  final Map<String, List<String>> _patternAdjustments = {
    'Tshirt': [
      'length',
      'neckDrop',
      'neckWidth',
      'neckbandWidth',
      'sleeveLength',
      'hemWidth',
    ],
    'Singlet': ['length', 'neckDrop', 'neckWidth', 'hemWidth'],
    'Jumper': [
      'length',
      'neckDrop',
      'neckWidth',
      'neckbandWidth',
      'sleeveLength',
      'hemWidth',
    ],
    'Jacket': [
      'length',
      'neckDrop',
      'neckWidth',
      'neckbandWidth',
      'sleeveLength',
      'hemWidth',
    ],
    'Legging': ['length', 'waistWidth', 'hipWidth', 'inseamLength', 'hemWidth'],
    'Trackpant': [
      'length',
      'waistWidth',
      'hipWidth',
      'inseamLength',
      'rise',
      'hemWidth',
    ],
    'Trackshort': ['length', 'waistWidth', 'hipWidth', 'hemWidth'],
  };

  @override
  void initState() {
    super.initState();
    _resetControllers();
  }

  void _resetControllers() {
    _neckDropController.text = '0';
    _sleeveLengthController.text = '0';
    _hemWidthController.text = '0';
    _neckWidthController.text = '0';
    _neckbandWidthController.text = '0';
    _lengthController.text = '0';
    _waistWidthController.text = '0';
    _hipWidthController.text = '0';
    _inseamLengthController.text = '0';
    _riseController.text = '0';
  }

  @override
  void dispose() {
    _neckDropController.dispose();
    _sleeveLengthController.dispose();
    _hemWidthController.dispose();
    _neckWidthController.dispose();
    _neckbandWidthController.dispose();
    _lengthController.dispose();
    _waistWidthController.dispose();
    _hipWidthController.dispose();
    _inseamLengthController.dispose();
    _riseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Pattern Adjustment',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              _showHelpDialog();
            },
          ),
        ],
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
                    'Welcome to Pattern Adjustment!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Customize your garment dimensions effortlessly.',
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Pattern Type Selection
            _buildSectionTitle('Pattern Type'),
            const SizedBox(height: 12.0),
            _buildPatternTypeSelector(),
            const SizedBox(height: 24.0),

            // Size Selection
            _buildSectionTitle('Base Size'),
            const SizedBox(height: 12.0),
            _buildSizeSelector(),
            const SizedBox(height: 24.0),

            // Adjustment Form
            _buildSectionTitle('Adjustments'),
            const SizedBox(height: 12.0),
            _buildAdjustmentForm(),
            const SizedBox(height: 24.0),

            // Preview Section
            if (_showPreview) ...[
              _buildSectionTitle('Preview'),
              const SizedBox(height: 12.0),
              _buildPreviewSection(),
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

  Widget _buildPatternTypeSelector() {
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
          const Text(
            'Select Pattern Type',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _patternTypes.map((type) {
              final isSelected = _selectedPatternType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPatternType = type;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6A82FB)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF6A82FB)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector() {
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
          const Text(
            'Base Size',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12.0),
          DropdownButtonFormField<String>(
            value: _selectedSize,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
            items: _sizes.map((size) {
              return DropdownMenuItem(value: size, child: Text(size));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSize = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentForm() {
    final fields = _patternAdjustments[_selectedPatternType] ?? [];
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (fields.contains('length'))
              _buildAdjustmentField(
                controller: _lengthController,
                label: 'Length Adjustment',
                hint: 'Enter length change (cm)',
                icon: Icons.straighten,
              ),
            if (fields.contains('neckDrop'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _neckDropController,
                  label: 'Neck Drop',
                  hint: 'Enter neck drop adjustment (cm)',
                  icon: Icons.arrow_downward,
                ),
              ),
            if (fields.contains('neckWidth'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _neckWidthController,
                  label: 'Neck Width',
                  hint: 'Enter neck width adjustment (cm)',
                  icon: Icons.width_normal,
                ),
              ),
            if (fields.contains('neckbandWidth'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _neckbandWidthController,
                  label: 'Neckband Width',
                  hint: 'Enter neckband width (cm)',
                  icon: Icons.circle,
                ),
              ),
            if (fields.contains('sleeveLength'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _sleeveLengthController,
                  label: 'Sleeve Length',
                  hint: 'Enter sleeve length adjustment (cm)',
                  icon: Icons.access_time,
                ),
              ),
            if (fields.contains('hemWidth'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _hemWidthController,
                  label: 'Hem Width',
                  hint: 'Enter hem width adjustment (cm)',
                  icon: Icons.width_full,
                ),
              ),
            if (fields.contains('waistWidth'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _waistWidthController,
                  label: 'Waist Width',
                  hint: 'Enter waist width adjustment (cm)',
                  icon: Icons.horizontal_rule,
                ),
              ),
            if (fields.contains('hipWidth'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _hipWidthController,
                  label: 'Hip Width',
                  hint: 'Enter hip width adjustment (cm)',
                  icon: Icons.horizontal_split,
                ),
              ),
            if (fields.contains('inseamLength'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _inseamLengthController,
                  label: 'Inseam Length',
                  hint: 'Enter inseam length adjustment (cm)',
                  icon: Icons.straighten,
                ),
              ),
            if (fields.contains('rise'))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAdjustmentField(
                  controller: _riseController,
                  label: 'Rise',
                  hint: 'Enter rise adjustment (cm)',
                  icon: Icons.vertical_align_bottom,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustmentField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF6A82FB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(icon, color: const Color(0xFF6A82FB), size: 20.0),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12.0,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              final double? number = double.tryParse(value);
              if (number == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    final fields = _patternAdjustments[_selectedPatternType] ?? [];
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
              Icon(Icons.preview, color: const Color(0xFF6A82FB)),
              const SizedBox(width: 8.0),
              const Text(
                'Adjustment Summary',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildPreviewItem('Pattern Type', _selectedPatternType),
          _buildPreviewItem('Base Size', _selectedSize),
          if (fields.contains('length'))
            _buildPreviewItem('Length', '${_lengthController.text} cm'),
          if (fields.contains('neckDrop'))
            _buildPreviewItem('Neck Drop', '${_neckDropController.text} cm'),
          if (fields.contains('neckWidth'))
            _buildPreviewItem('Neck Width', '${_neckWidthController.text} cm'),
          if (fields.contains('neckbandWidth'))
            _buildPreviewItem(
              'Neckband Width',
              '${_neckbandWidthController.text} cm',
            ),
          if (fields.contains('sleeveLength'))
            _buildPreviewItem(
              'Sleeve Length',
              '${_sleeveLengthController.text} cm',
            ),
          if (fields.contains('hemWidth'))
            _buildPreviewItem('Hem Width', '${_hemWidthController.text} cm'),
          if (fields.contains('waistWidth'))
            _buildPreviewItem(
              'Waist Width',
              '${_waistWidthController.text} cm',
            ),
          if (fields.contains('hipWidth'))
            _buildPreviewItem('Hip Width', '${_hipWidthController.text} cm'),
          if (fields.contains('inseamLength'))
            _buildPreviewItem(
              'Inseam Length',
              '${_inseamLengthController.text} cm',
            ),
          if (fields.contains('rise'))
            _buildPreviewItem('Rise', '${_riseController.text} cm'),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (!_showPreview) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateAndPreview,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A82FB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Preview Adjustments',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _resetForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Reset',
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
                  onPressed: _isProcessing ? null : _processAdjustments,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48BB78),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Process & Download',
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

  void _validateAndPreview() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showPreview = true;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _showPreview = false;
      _formKey.currentState!.reset();
      _resetControllers();
    });
  }

  void _processAdjustments() {
    setState(() {
      _isProcessing = true;
    });
    // Simulate processing time
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });
      final fields = _patternAdjustments[_selectedPatternType] ?? [];
      final adjustments = <String, double>{};
      if (fields.contains('length'))
        adjustments['length'] = double.tryParse(_lengthController.text) ?? 0.0;
      if (fields.contains('neckDrop'))
        adjustments['neckDrop'] =
            double.tryParse(_neckDropController.text) ?? 0.0;
      if (fields.contains('neckWidth'))
        adjustments['neckWidth'] =
            double.tryParse(_neckWidthController.text) ?? 0.0;
      if (fields.contains('neckbandWidth'))
        adjustments['neckbandWidth'] =
            double.tryParse(_neckbandWidthController.text) ?? 0.0;
      if (fields.contains('sleeveLength'))
        adjustments['sleeveLength'] =
            double.tryParse(_sleeveLengthController.text) ?? 0.0;
      if (fields.contains('hemWidth'))
        adjustments['hemWidth'] =
            double.tryParse(_hemWidthController.text) ?? 0.0;
      if (fields.contains('waistWidth'))
        adjustments['waistWidth'] =
            double.tryParse(_waistWidthController.text) ?? 0.0;
      if (fields.contains('hipWidth'))
        adjustments['hipWidth'] =
            double.tryParse(_hipWidthController.text) ?? 0.0;
      if (fields.contains('inseamLength'))
        adjustments['inseamLength'] =
            double.tryParse(_inseamLengthController.text) ?? 0.0;
      if (fields.contains('rise'))
        adjustments['rise'] = double.tryParse(_riseController.text) ?? 0.0;
      // Navigate to download screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DownloadPatternScreen(
            patternType: _selectedPatternType,
            size: _selectedSize,
            adjustments: adjustments,
          ),
        ),
      );
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.help_outline, color: const Color(0xFF6A82FB)),
              const SizedBox(width: 8.0),
              const Text('Pattern Adjustment Help'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem('ðŸ“� Length: Adjust overall garment length'),
              _buildHelpItem('ðŸ”½ Neck Drop: Modify neckline depth'),
              _buildHelpItem('ðŸ“� Neck Width: Change neck opening width'),
              _buildHelpItem('â­• Neckband: Set neckband width'),
              _buildHelpItem('â�±ï¸� Sleeve Length: Adjust sleeve length'),
              _buildHelpItem('ðŸ“� Hem Width: Modify bottom hem width'),
              _buildHelpItem(
                'ðŸ’¡ Use positive values to increase, negative to decrease',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 14.0)),
    );
  }
}
