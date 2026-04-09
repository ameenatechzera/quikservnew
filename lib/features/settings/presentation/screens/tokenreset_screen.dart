import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/settings/domain/parameters/sales_tokenupdate_request.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class ResetTokenScreen extends StatefulWidget {
  const ResetTokenScreen({super.key});

  @override
  State<ResetTokenScreen> createState() => _ResetTokenScreenState();
}

class _ResetTokenScreenState extends State<ResetTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();
  @override
  void initState() {
    context.read<SettingsCubit>().fetchSalesTokenFromServer();
    super.initState();
  }

  void _resetToken() {
    setState(() {
      _tokenController.text = '1';
    });
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a token')));
      return;
    }
    final dbName = await SharedPreferenceHelper().getDatabaseName();
    final branchId = await SharedPreferenceHelper().getBranchId();
    //final userId = await SharedPreferenceHelper().getU();
    context.read<SettingsCubit>().updateSalesTokenFromServer(
      UpdateSalesTokenRequest(
        dbname: dbName!,
        branchId: branchId,
        tokenNo: _tokenController.text.toString(),
        userId: '1',
      ),
    );

    // Save logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Token "$token" saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Token')),

      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is UpdateSalesTokenSuccess) {
            Navigator.pop(context);
          }
          if (state is FetchSalesTokenSuccess) {
            _tokenController.text =
                state.tokenResult.salesBillToken.first.billTokenNo;
          }
        },
        builder: (context, state) {
          final isLoading = state is! FetchSalesTokenSuccess;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Row with TextFormField + Reset Button
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          TextFormField(
                            controller: _tokenController,
                            decoration: const InputDecoration(
                              labelText: 'Enter Token',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          if (isLoading)
                            const Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: LinearProgressIndicator(minHeight: 2),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _resetToken();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _saveToken();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
