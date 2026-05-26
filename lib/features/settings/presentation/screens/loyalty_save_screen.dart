import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/features/settings/domain/parameters/loyaltyCardSaveRequest.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class CreateLoyaltyPage extends StatefulWidget {
  const CreateLoyaltyPage({super.key});

  @override
  State<CreateLoyaltyPage> createState() => _CreateLoyaltyPageState();
}

class _CreateLoyaltyPageState extends State<CreateLoyaltyPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _amountPerPointController = TextEditingController();
  final _minRedeemController = TextEditingController();
  final _pointValueController = TextEditingController();
  final _validityDaysController = TextEditingController();

  bool _isLoading = false;

  Future<void> _save() async {
    final dbName = await SharedPreferenceHelper().getDatabaseName();
    final branchId = await SharedPreferenceHelper().getBranchId();
    context.read<SettingsCubit>().saveLoyaltyCard(
      LoyaltyCardSaveRequest(
        loyaltyName: _nameController.text.trim(),
        amountPerPoint: _amountPerPointController.text.trim().toString(),
        minRedeemPoint: _minRedeemController.text.trim(),
        redeemValidityDays: _validityDaysController.text.trim(),
        activeStatus: '1',
        dbname: dbName!,
        branchId: branchId,
        tokenNo: '',
        pointValue: _pointValueController.text.toString(),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountPerPointController.dispose();
    _minRedeemController.dispose();
    _validityDaysController.dispose();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Create Loyalty Program',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appThemeLightOrange,
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
              // ── Header card ────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1565C0).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loyalty Configuration',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Set up your rewards program details',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF546E7A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Fields ─────────────────────────────────────────────────
              _buildField(
                controller: _nameController,
                label: 'Loyalty Name',
                hint: 'e.g. Gold Rewards',
                icon: Icons.loyalty,
                keyboardType: TextInputType.text,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Loyalty name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildField(
                controller: _pointValueController,
                label: 'Point Value(₹) for redeem card',
                hint: 'e.g. 10.00',
                icon: Icons.currency_rupee,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Point Value is required';
                  }
                  if (double.tryParse(v.trim()) == null) {
                    return 'Enter a valid amount';
                  }
                  if (double.parse(v.trim()) <= 0) {
                    return 'Point must be greater than 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              _buildField(
                controller: _amountPerPointController,
                label: 'Amount per Point while sale',
                hint: 'e.g. 1',
                icon: Icons.currency_rupee,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Amount Per Point is required';
                  }
                  if (double.tryParse(v.trim()) == null) {
                    return 'Enter a valid amount';
                  }
                  if (double.parse(v.trim()) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _minRedeemController,
                label: 'Minimum Redeem Point',
                hint: 'e.g. 10',
                icon: Icons.redeem,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Minimum redeem amount is required';
                  }
                  if (double.tryParse(v.trim()) == null) {
                    return 'Enter a valid amount';
                  }
                  if (double.parse(v.trim()) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              _buildField(
                controller: _validityDaysController,
                label: 'Redeem Validity (Days)',
                hint: 'e.g. 30',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Validity days is required';
                  }
                  if (int.tryParse(v.trim()) == null) {
                    return 'Enter a valid number of days';
                  }
                  if (int.parse(v.trim()) <= 0) {
                    return 'Days must be greater than 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // ── Save button ────────────────────────────────────────────
              BlocConsumer<SettingsCubit, SettingsState>(
                listener: (context, state) {
                  if (state is SaveLoyaltyCardSuccess) {
                    Navigator.pop(context, true);
                  }
                  if (state is SaveLoyaltyCardError) {
                    print('error while save');
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appThemeYellow,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: const Color(
                          0xFF1565C0,
                        ).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_alt, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Save Loyalty Program',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF37474F),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
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
                color: Color(0xFF1565C0),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFC62828)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFC62828),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
