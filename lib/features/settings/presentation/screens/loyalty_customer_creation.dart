import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:quikservnew/core/config/colors.dart';

class AddLoyaltyCustomer extends StatefulWidget {
  const AddLoyaltyCustomer({super.key});

  @override
  State<AddLoyaltyCustomer> createState() => _AssignLoyaltyPageState();
}

class _AssignLoyaltyPageState extends State<AddLoyaltyCustomer> {
  final _formKey = GlobalKey<FormState>();

  final _nameController  = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading        = false;
  bool _isLoadingCards   = false;

  // ── Loyalty cards from API ────────────────────────────────────────────────
  List<Map<String, dynamic>> _loyaltyCards = [];
  Map<String, dynamic>? _selectedCard;

  static const String _loyaltyListUrl = 'https://online.cristaledu.com/api/loyalty';
  static const String _assignUrl      = 'https://online.cristaledu.com/api/loyalty/assign';

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _fetchLoyaltyCards();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ── API calls ─────────────────────────────────────────────────────────────

  Future<void> _fetchLoyaltyCards() async {
    setState(() => _isLoadingCards = true);
    try {
      final response = await http.get(
        Uri.parse(_loyaltyListUrl),
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Handle both { data: [...] } and plain [...] responses
        final List list = decoded is List ? decoded : decoded['data'] ?? [];
        setState(() {
          _loyaltyCards = list.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      }
    } catch (e) {
      _showResult(success: false, message: 'Failed to load loyalty cards: $e');
    } finally {
      if (mounted) setState(() => _isLoadingCards = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCard == null) {
      _showResult(success: false, message: 'Please select a loyalty card');
      return;
    }

    setState(() => _isLoading = true);

    final body = {
      'loyalty_id':    _selectedCard!['id'],
      'loyalty_name':  _selectedCard!['name'],
      'customer_name': _nameController.text.trim(),
      'phone':         _phoneController.text.trim(),
      'email':         _emailController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(_assignUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept':        'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showResult(success: true, message: 'Loyalty card assigned successfully!');
        _formKey.currentState!.reset();
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        setState(() => _selectedCard = null);
      } else {
        final decoded = jsonDecode(response.body);
        _showResult(
          success: false,
          message: decoded['message'] ?? 'Server error ${response.statusCode}',
        );
      }
    } catch (e) {
      if (mounted) _showResult(success: false, message: 'Network error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showResult({required bool success, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_outline : Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(message, style: const TextStyle(fontSize: 13))),
          ],
        ),
        backgroundColor:
        success ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Assign Loyalty Card',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor:appThemeLightOrange,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header card ──────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF1565C0).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.person_add_alt_1,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer Enrollment',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0))),
                          SizedBox(height: 2),
                          Text('Assign a loyalty card to a customer',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF546E7A))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Loyalty card dropdown ────────────────────────────────────
              _buildLabel('Loyalty Card', Icons.card_giftcard),
              const SizedBox(height: 6),
              _isLoadingCards
                  ? Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
                  : DropdownButtonFormField<Map<String, dynamic>>(
                value: _selectedCard,
                decoration: _dropdownDecoration(),
                hint: Text('Select a loyalty card',
                    style: TextStyle(
                        color: Colors.grey.shade400, fontSize: 13)),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF1565C0)),
                items: _loyaltyCards
                    .map((card) => DropdownMenuItem<Map<String, dynamic>>(
                  value: card,
                  child: Row(
                    children: [
                      const Icon(Icons.loyalty,
                          size: 16, color: Color(0xFF1565C0)),
                      const SizedBox(width: 8),
                      Text(
                        card['name'] ?? 'Unnamed',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedCard = val),
                validator: (_) => _selectedCard == null
                    ? 'Please select a loyalty card'
                    : null,
              ),

              // ── Selected card preview ────────────────────────────────────
              if (_selectedCard != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFF1565C0).withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Color(0xFF1565C0)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 16,
                          children: [
                            _previewChip(
                              Icons.currency_rupee,
                              '₹${_selectedCard!['amount_per_point'] ?? '-'} / pt',
                            ),
                            _previewChip(
                              Icons.redeem,
                              'Min ₹${_selectedCard!['min_redeem_amount'] ?? '-'}',
                            ),
                            _previewChip(
                              Icons.calendar_today,
                              '${_selectedCard!['redeem_validity_days'] ?? '-'} days',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // ── Customer name ────────────────────────────────────────────
              _buildField(
                controller: _nameController,
                label: 'Customer Name',
                hint: 'e.g. Rahul Sharma',
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Customer name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Phone ────────────────────────────────────────────────────
              _buildField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'e.g. 9876543210',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (v.trim().length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Email ────────────────────────────────────────────────────
              _buildField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'e.g. rahul@email.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email address is required';
                  }
                  final emailRegex =
                  RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(v.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // ── Save button ──────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appThemeYellow,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                    appThemeYellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.how_to_reg, size: 20,color: Colors.black,),
                      SizedBox(width: 8),
                      Text('Assign Loyalty Card',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper widgets ────────────────────────────────────────────────────────

  Widget _buildLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF1565C0)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF37474F))),
      ],
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
        const BorderSide(color: Color(0xFF1565C0), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC62828)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
        const BorderSide(color: Color(0xFFC62828), width: 1.5),
      ),
    );
  }

  Widget _previewChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF1565C0)),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, icon),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
            TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon:
            Icon(icon, color: const Color(0xFF1565C0), size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Color(0xFF1565C0), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFC62828)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Color(0xFFC62828), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}