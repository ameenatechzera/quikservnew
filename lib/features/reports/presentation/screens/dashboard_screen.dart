import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.white),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // TOP 2 CARDS
              Row(
                children: const [
                  Expanded(
                    child: _StatCard(title: 'Total Sales Count', value: '30'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(title: 'Total Sales Amount', value: '30'),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // CASH BALANCE
              Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: const [
                    Text(
                      'Cash Balance',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '₹65430',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // TRANSACTION
              const Text(
                'Transaction',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.receipt_long_outlined,
                      label: 'Sales Invoice',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.camera_alt_outlined,
                      label: 'Payment',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // REPORTS
              const Text(
                'Reports',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.receipt_outlined,
                      label: 'Sales Report',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.flag_outlined,
                      label: 'Item Report',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.calendar_month_outlined,
                      label: 'Daily Closing\nReport',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: SizedBox()),
                ],
              ),

              const Spacer(),

              // BOTTOM PILL NAV (DESIGN ONLY)
              Center(
                child: Container(
                  height: 56,
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6D568),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _NavIcon(icon: Icons.home_rounded, selected: false),
                      _NavCenterSelected(),
                      _NavIcon(icon: Icons.settings_rounded, selected: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,

      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const _NavIcon({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 40,
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, size: 22, color: Colors.black),
    );
  }
}

class _NavCenterSelected extends StatelessWidget {
  const _NavCenterSelected();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.pause, size: 16, color: Colors.white),
          ),
          SizedBox(width: 8),
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
