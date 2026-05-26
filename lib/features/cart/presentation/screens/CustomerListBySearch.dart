import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/sale/domain/entities/loyalty_search_result.dart';
import 'package:quikservnew/features/sale/domain/parameters/loyalty_search_request.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';

class CustomerListBySearchPage extends StatefulWidget {
  const CustomerListBySearchPage({super.key});

  @override
  State<CustomerListBySearchPage> createState() =>
      _CustomerListBySearchPageState();
}

class _CustomerListBySearchPageState extends State<CustomerListBySearchPage> {
  final TextEditingController searchController = TextEditingController();

  List<LoyaltyCustomer> searchCustomers = [];

  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().fetchLoyaltyCustomersFromServer();
    // context.read<SaleCubit>().fetchLoyaltyDetailsBySearch(
    //   LoyaltySearchRequest(search: ""),
    // );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool get isSearching => searchController.text.trim().length >= 2;
  Widget miniDetail(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

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
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              controller: searchController,

              onChanged: (value) {
                setState(() {});

                /// Search API
                if (value.trim().length >= 2) {
                  context.read<SaleCubit>().fetchLoyaltyDetailsBySearch(
                    LoyaltySearchRequest(search: value.trim()),
                  );
                }
                /// Empty -> show normal customer list
                else if (value.trim().isEmpty) {
                  context
                      .read<SettingsCubit>()
                      .fetchLoyaltyCustomersFromServer();
                }
                // if (value.length >= 2) {
                // context.read<SaleCubit>().fetchLoyaltyDetailsBySearch(
                //   LoyaltySearchRequest(search: value),
                // );
                // } else if (value.isEmpty) {
                //   context.read<SaleCubit>().fetchLoyaltyDetailsBySearch(
                //     LoyaltySearchRequest(search: ""),
                //   );
                // }
              },

              decoration: InputDecoration(
                fillColor: Colors.white,

                hintText: "Search customer by mobileNo or email",

                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.theme),
                ),

                filled: true,
              ),
            ),
          ),

          /// CUSTOMER LIST
          Expanded(
            child: isSearching
                ? BlocConsumer<SaleCubit, SaleState>(
                    listener: (context, state) {
                      if (state is LoyaltyBySearchError) {
                        print('LoyaltyBySearchError ${state.error}');
                      }
                    },

                    builder: (context, state) {
                      /// LOADING
                      if (state is LoyaltyDetailsBySearchInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      /// ERROR
                      if (state is LoyaltyBySearchError) {
                        return const Center(child: Text("No Data"));
                      }

                      /// SUCCESS
                      if (state is LoyaltyBySearchFetchSuccess) {
                        searchCustomers = state.response.data ?? [];

                        if (searchCustomers.isEmpty) {
                          return const Center(child: Text("No customer found"));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(12),

                          itemCount: searchCustomers.length,

                          itemBuilder: (context, index) {
                            final customer = searchCustomers[index];

                            return GestureDetector(
                              onTap: () => Navigator.of(context).pop(customer),

                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),

                                padding: const EdgeInsets.all(14),

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.circular(14),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  children: [
                                    /// TOP SECTION
                                    Row(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,

                                          decoration: BoxDecoration(
                                            color: AppColors.theme.withOpacity(
                                              0.10,
                                            ),

                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),

                                          child: Icon(
                                            Icons.person,
                                            color: AppColors.primary,
                                            size: 26,
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                customer.customerName ?? "",

                                                maxLines: 1,

                                                overflow: TextOverflow.ellipsis,

                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),

                                              const SizedBox(height: 3),

                                              Text(
                                                customer.loyaltyName ?? "",

                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),

                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(
                                              0.10,
                                            ),

                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),

                                          child: Text(
                                            "${customer.totalPointsEarned ?? "0"} pts",

                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),

                                    /// PHONE
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 15,
                                          color: Colors.grey.shade600,
                                        ),

                                        const SizedBox(width: 6),

                                        Text(
                                          customer.phoneNo ?? "",

                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    /// EMAIL
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          size: 15,
                                          color: Colors.grey.shade600,
                                        ),

                                        const SizedBox(width: 6),

                                        Expanded(
                                          child: Text(
                                            customer.email ?? "",

                                            maxLines: 1,

                                            overflow: TextOverflow.ellipsis,

                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),

                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,

                                        borderRadius: BorderRadius.circular(12),
                                      ),

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,

                                        children: [
                                          miniDetail(
                                            "Earned",
                                            "₹${customer.totalEarnedAmount ?? "0"}",
                                          ),

                                          miniDetail(
                                            "Redeem",
                                            "₹${customer.minRedeemPoint ?? "0"}",
                                          ),

                                          miniDetail(
                                            "Valid",
                                            "${customer.redeemValidityDays ?? 0}d",
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

                      return const SizedBox();
                    },
                  )
                : BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      if (state is FetchLoyaltyCustomersSuccess) {
                        final customers = state.customerListResult.data;

                        if (customers.isEmpty) {
                          return const Center(child: Text("No customer found"));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: customers.length,
                          itemBuilder: (context, index) {
                            final customer = customers[index];

                            return GestureDetector(
                              onTap: () => Navigator.of(context).pop(customer),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  children: [
                                    /// TOP SECTION
                                    Row(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: AppColors.theme.withOpacity(
                                              0.10,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: AppColors.primary,
                                            size: 26,
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                customer.customerName ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                customer.loyalityName ?? '',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),

                                    /// PHONE
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 15,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          customer.phoneNo ?? '',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    /// EMAIL
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          size: 15,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            customer.email ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // child: Card(
                              //   elevation: 3,
                              //   margin: const EdgeInsets.only(bottom: 12),
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(12),
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(16),
                              //     child: Row(
                              //       children: [
                              //         const CircleAvatar(
                              //           radius: 28,
                              //           child: Icon(Icons.person),
                              //         ),

                              //         const SizedBox(width: 16),

                              //         Expanded(
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Text(
                              //                 customer.customerName ?? '',
                              //                 style: const TextStyle(
                              //                   fontSize: 18,
                              //                   fontWeight: FontWeight.bold,
                              //                 ),
                              //               ),

                              //               const SizedBox(height: 6),

                              //               Text(
                              //                 customer.loyalityName ?? '',
                              //                 style: const TextStyle(
                              //                   fontSize: 16,
                              //                   fontWeight: FontWeight.w600,
                              //                 ),
                              //               ),

                              //               const SizedBox(height: 6),

                              //               Row(
                              //                 children: [
                              //                   const Icon(
                              //                     Icons.phone,
                              //                     size: 18,
                              //                   ),
                              //                   const SizedBox(width: 6),
                              //                   Text(customer.phoneNo ?? ''),
                              //                 ],
                              //               ),

                              //               const SizedBox(height: 4),

                              //               Row(
                              //                 children: [
                              //                   const Icon(
                              //                     Icons.email,
                              //                     size: 18,
                              //                   ),
                              //                   const SizedBox(width: 6),
                              //                   Expanded(
                              //                     child: Text(
                              //                       customer.email ?? '',
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            );
                          },
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
