import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text(""),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/quikserv_icon.png',
                  height: 90,
                ),

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
                  "Developed By Teczera",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                infoCard(
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: _infoTile(
                      icon: Icons.chat_bubble_outline,
                      title: "Quikserv 2@gmail.com",
                                       ),
                   ),
                ),

                /// ✅ WhatsApp asset icon
                infoCard(
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: _infoTile(
                      assetIcon: 'assets/icons/whatsapp_icon.png',
                      title: "973383883893",
                                       ),
                   ),
                ),

                infoCard(
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: _infoTile(
                      icon: Icons.call,
                      title: "97227277272",
                                       ),
                   ),
                ),

                infoCard(
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: _infoTile(
                      icon: Icons.language,
                      title: "www.techzera.in",
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
                      Padding(
                        padding: const EdgeInsets.only(top: 26.0),

                        child: const Text(
                          "Teczera Is A Technology-Driven Company Focused On Building "
                              "Simple, Smart, And Reliable Digital Solutions. We Specialize "
                              "In Creating User-Friendly Products That Help Businesses "
                              "Streamline Operations, Improve Efficiency, And Grow With "
                              "Confidence.\n\n"
                              "At Teczera, We Believe In Clean Design, Powerful Technology, "
                              "And Practical Innovation. Our Solutions Are Designed To Be "
                              "Easy To Use, Scalable, And Tailored To Real Business Needs.",
                          style: TextStyle(height: 1.5, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )

        ),
      ),
    );
  }

  /// REUSABLE INFO TILE
//   static Widget _infoTile({
//     required IconData icon,
//     required String title,
//     Color iconColor = Colors.black,
//   }) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Icon(icon, color: iconColor),
//       title: Text(title),
//       trailing: const Icon(Icons.chevron_right),
//       onTap: () {},
//     );
//   }
// }
  Widget _infoTile({
    IconData? icon,
    String? assetIcon,
    required String title,
    //Color iconColor = Colors.black,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: assetIcon != null
          ? Image.asset(
        assetIcon,
        width: 22,
        height: 22,
        //color: iconColor,
      )
          : Icon(
        icon,
        //color: iconColor,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget infoCard(Widget child) {
    return
      Card(
      color: Colors.white, // ✅ white background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.grey, // ✅ black border
          width: 1,
        ),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: child,
    );
  }

}
