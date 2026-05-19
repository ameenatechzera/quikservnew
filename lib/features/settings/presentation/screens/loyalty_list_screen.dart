import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/settings/domain/entities/loyaltyListResult.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';

class LoyaltyListPage extends StatefulWidget {
  const LoyaltyListPage({super.key});

  @override
  State<LoyaltyListPage> createState() => _LoyaltyListPageState();
}

class _LoyaltyListPageState extends State<LoyaltyListPage> {
  List<LoyaltyList> _cards = [];

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    context.read<SettingsCubit>().fetchLoyaltyCardListFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Loyalty Programs',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _fetchCards,
          ),
        ],
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is FetchLoyaltyCardSuccess) {
            setState(() {
              _cards = state.cardListResult.data;
            });
          }
        },
        builder: (context, state) {
          // Loading state
          if (state is FetchLoyaltyCardListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (state is FetchLoyaltyCardError) {
            return _ErrorState(
              message: state.message ?? 'Something went wrong',
              onRetry: _fetchCards,
            );
          }

          // Empty state
          if (_cards.isEmpty) {
            return const _EmptyState();
          }

          // Success state
          return RefreshIndicator(
            onRefresh: _fetchCards,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cards.length,
              itemBuilder: (context, i) {
                return _LoyaltyCard(card: _cards[i]);
              },
            ),
          );
        },
      ),
    );
  }
}

// ───────────────── Loyalty Card ─────────────────

class _LoyaltyCard extends StatelessWidget {
  const _LoyaltyCard({required this.card});

  final LoyaltyList card;

  static const List<Color> _accents = [
    Color(0xFF1565C0),
    Color(0xFF6A1B9A),
    Color(0xFF00695C),
    Color(0xFFE65100),
    Color(0xFF283593),
    Color(0xFF880E4F),
  ];

  @override
  Widget build(BuildContext context) {
    final index = card.loyalityId ?? 0;
    final accent = _accents[index % _accents.length];

    // Safe bool conversion
    final enabled = card.activeStatus == true ||
        card.activeStatus == 1 ||
        card.activeStatus.toString() == '1';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    card.loyalityName ?? 'Unnamed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: enabled
                        ? Colors.white.withOpacity(0.25)
                        : Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    enabled ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Row(
              children: [
                _StatCell(
                  icon: Icons.currency_rupee,
                  label: 'Amount / Point',
                  value: '₹${card.amountPerPoint ?? '-'}',
                  accent: accent,
                ),

                _Divider(),

                _StatCell(
                  icon: Icons.redeem,
                  label: 'Min Redeem',
                  value: '₹${card.minRedeemAmt ?? '-'}',
                  accent: accent,
                ),

                _Divider(),

                _StatCell(
                  icon: Icons.calendar_today,
                  label: 'Validity',
                  value:
                  '${card.redeemValidityDays ?? '-'} days',
                  accent: accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────── Stat Cell ─────────────────

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: accent,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: Colors.grey.shade200,
    );
  }
}

// ───────────────── Empty State ─────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.card_giftcard_outlined,
            size: 72,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),

          Text(
            'No loyalty programs yet',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Create your first loyalty program to get started',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────── Error State ─────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}