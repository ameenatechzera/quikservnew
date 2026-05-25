import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/cart/presentation/screens/CustomerListBySearch.dart';
import 'package:quikservnew/features/sale/domain/entities/loyalty_search_result.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/features/settings/presentation/screens/loyalty_customer_creation.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  LoyaltyCustomer? _selectedCustomer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SettingsCubit>().fetchLoyaltyCustomersFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Loyalty Customers',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.theme,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    _selectedCustomer = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CustomerListBySearchPage(),
                      ),
                    );
                    // print('selectedCustomer $_selectedCustomer');
                    // print(
                    //   'totalSalesController ${totalSalesController.text.toString()}',
                    // );
                    // print(
                    //   'totalEarnedAmount ${_selectedCustomer!.totalEarnedAmount}',
                    // );
                    // double totalSalesAmount = double.parse(totalSalesController.text.toString());
                    // double totalEarnedAmount = double.parse(_selectedCustomer!.totalEarnedAmount.toString());
                    // if(totalSalesAmount>=totalEarnedAmount){
                    //   _redeemEligible = true;
                    // }
                    setState(() {});
                  },
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Refresh',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddLoyaltyCustomer();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is FetchLoyaltyCustomersSuccess) {
              final customers = state.customerListResult.data;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            child: Icon(Icons.person),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.customerName ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),
                                Text(
                                  customer.loyalityName ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 18),
                                    const SizedBox(width: 6),
                                    Text(customer.phoneNo ?? ''),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    const Icon(Icons.email, size: 18),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(customer.email ?? '')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
