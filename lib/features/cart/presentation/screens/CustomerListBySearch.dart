import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/sale/domain/entities/loyalty_search_result.dart';
import 'package:quikservnew/features/sale/domain/parameters/loyalty_search_request.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';

class CustomerListBySearchPage extends StatelessWidget {
  CustomerListBySearchPage({super.key});

  final TextEditingController searchController = TextEditingController();
  List<LoyaltyCustomer> customers = [];

  @override
  Widget build(BuildContext context) {
    context.read<SaleCubit>().fetchLoyaltyDetailsBySearch(
      LoyaltySearchRequest(search: ""),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Loyalty List',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.theme,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ), // ← back arrow color
      ),
      body: Column(
        children: [
          /// Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (value.length > 3) {
                  print('searchController $value');
                  context.read<SaleCubit>().fetchLoyaltyDetailsBySearch(
                    LoyaltySearchRequest(search: value),
                  );
                }
                if (value.length <=1) {
                  context.read<SaleCubit>().fetchLoyaltyDetailsBySearch(
                    LoyaltySearchRequest(search: ""),
                  );
                }
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: "Search customer by mobileNo or email",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
          ),

          /// Customer List
          Expanded(
            child: BlocConsumer<SaleCubit, SaleState>(
              listener: (context, state) {
                if (state is LoyaltyBySearchError) {
                  print('LoyaltyBySearchError ${state.error}');
                }
                if (state is LoyaltyBySearchFetchSuccess) {
                  print('LoyaltyBySearchFetchSuccess ${state.response}');
                }
              },
              builder: (context, state) {
                /// Loading
                if (state is LoyaltyDetailsBySearchInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// Success
                if (state is LoyaltyBySearchFetchSuccess) {
                  print('ResponseSearch ${state.response.data}');
                  customers.clear();
                  customers = state.response.data ?? [];

                  if (customers.isEmpty) {
                    return const Center(child: Text("No customer found"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pop(customer); // ← returns selected customer
                        },
                        child: Card(
                          color: Color(0xFFFFF4D7),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Name
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        customer.customerName ?? "",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// Phone
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 18),
                                    const SizedBox(width: 8),
                                    Text(customer.phoneNo ?? ""),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                /// Email
                                Row(
                                  children: [
                                    const Icon(Icons.email, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(customer.email ?? "")),
                                  ],
                                ),

                                const Divider(),

                                /// Loyalty Info
                                Text("Loyalty: ${customer.loyaltyName ?? ""}"),

                                Text(
                                  "Points Earned: ${customer.totalPointsEarned ?? "0"}",
                                ),

                                Text(
                                  "Earned Amount: ₹${customer.totalEarnedAmount ?? "0.00"}",
                                ),

                                Text(
                                  "Amount Per Point: ₹${customer.amountPerPoint ?? "0.00"}",
                                ),

                                Text(
                                  "Min Redeem Amount: ₹${customer.minRedeemPoint ?? "0.00"}",
                                ),

                                Text(
                                  "Validity Days: ${customer.redeemValidityDays ?? 0}",
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                /// Default State
                return const Center(child: Text("Search customer"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
