import 'package:flutter/material.dart';
import 'package:quikservnew/features/settings/presentation/helper/print_settings_helper.dart';
import 'package:quikservnew/features/settings/presentation/widgets/aboutus_widgets.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});
  final AboutUsHelper helper = AboutUsHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/quikserv_icon.png', height: 90),
              const SizedBox(height: 12),
              const Text(
                "QUIKSERV",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Developed By Techzera Infologics Pvt Ltd",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              infoCard(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: infoTile(
                    icon: Icons.chat_bubble_outline,
                    title: "support@quikserv.app",
                    onTap: helper.openEmail,
                  ),
                ),
              ),
              infoCard(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: infoTile(
                    assetIcon: 'assets/icons/whatsapp_icon.png',
                    title: "+91-7592909990",
                    onTap: helper.openWhatsApp,
                  ),
                ),
              ),
              infoCard(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: infoTile(
                    icon: Icons.call,
                    title: "+91-7592909990",
                    onTap: helper.makeCall,
                  ),
                ),
              ),
              infoCard(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: infoTile(
                    icon: Icons.language,
                    title: "www.quikserv.app",
                    onTap: AboutUsHelper().openWebsite,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF0C2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "About Us",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      const Text(
                        "QuikSERV is a smart and easy-to-use billing application designed for hospitality businesses. "
                        "It helps businesses manage billing, sales, and inventory smoothly, even during busy hours.\n\n"
                        "Our focus is to provide a fast, reliable, and user-friendly solution that simplifies daily operations "
                        "and improves efficiency at the billing counter.\n\n"
                        "QuikSERV is built keeping real business needs in mind — accuracy, speed, and simplicity. "
                        "Our vision is to become a trusted digital partner for food businesses by delivering simple, stable, "
                        "and scalable billing solutions that support growth and operational excellence.",

                        textAlign: TextAlign.start,
                        style: TextStyle(height: 1.6, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
