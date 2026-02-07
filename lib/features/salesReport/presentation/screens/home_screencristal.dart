import 'package:flutter/material.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/custom_bottombar.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/header_cristal.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/post_card_cristal.dart';

class Home_cristal extends StatelessWidget {
  const Home_cristal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      bottomNavigationBar: const CustomBottomBar(),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  PostCard(),
                  SizedBox(height: 16),
                  PostCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
