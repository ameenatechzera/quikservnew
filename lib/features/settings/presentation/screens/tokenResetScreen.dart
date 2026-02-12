import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/settings/domain/parameters/salesTokenUpdateRequest.dart';
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
    // TODO: implement initState

    context.read<SettingsCubit>().fetchSalesTokenFromServer();
    super.initState();
  }
  

  void _resetToken() {
    setState(() {
     // _tokenController.clear();
      _tokenController.text='1';
    });
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a token')),
      );
      return;
    }
    final dbName = await SharedPreferenceHelper().getDatabaseName();
    final branchId = await SharedPreferenceHelper().getBranchId();
    //final userId = await SharedPreferenceHelper().getU();
    context.read<SettingsCubit>().updateSalesTokenFromServer(UpdateSalesTokenRequest(db_name: dbName!, branchId: branchId,
        tokenNo: _tokenController.text.toString(), userId: '1'));

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
    if(state is UpdateSalesTokenSuccess){
      Navigator.pop(context);
    }
    if(state is FetchSalesTokenSuccess){
      print('FetchSalesTokenSuccess ${state.tokenResult.salesBillToken.first.billTokenNo}');
      _tokenController.text = state.tokenResult.salesBillToken.first.billTokenNo;
    }
  },
  builder: (context, state) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row with TextFormField + Reset Button
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Token',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                ElevatedButton.icon(
                  //onClick: _resetToken,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    // Background color
                    foregroundColor: Colors.white,
                    // Text color
                    shadowColor: Colors.black,
                    // Shadow color
                    elevation: 4,
                    // Elevation
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 5),
                    // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                          10), // Rounded corners
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
                  // Background color
                  foregroundColor: Colors.white,
                  // Text color
                  shadowColor: Colors.black,
                  // Shadow color
                  elevation: 4,
                  // Elevation
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 5),
                  // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        10), // Rounded corners
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
