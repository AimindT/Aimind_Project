import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: ListView(
        padding: EdgeInsets.all(12),
        physics: BouncingScrollPhysics(),
        children: [
          Container(height: 35),
          userTile(),
          divider(),
          colorTiles(),
          divider(),
          bwTiles()
        ],
      ),
    );
  }

  Widget userTile() {
    String url =
        'https://static.wikia.nocookie.net/mokeys-show/images/4/43/Screenshot_2025-01-10_212625.png/revision/latest?cb=20250112022914';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 230, 228, 228),
        backgroundImage: NetworkImage(url),
      ),
      title: Text(
        'Chris Chaparro',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

Widget divider() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Divider(
      thickness: 1.5,
    ),
  );
}

Widget colorTiles() {
  return Column(
    children: [
      colorTile(Icons.person_outline, Colors.deepPurple, 'Personal data'),
      colorTile(Icons.settings_outlined, Colors.blue, 'Settings'),
      colorTile(Icons.credit_card, Colors.pink, 'Payment'),
      colorTile(Icons.favorite_border, Colors.orange, 'Personal Data')
    ],
  );
}

Widget bwTiles() {
  return Column(
    children: [
      bwTile(Icons.info_outline, 'FAQs'),
      bwTile(Icons.border_color_outlined, 'Handbook'),
      bwTile(Icons.textsms_outlined, 'Community')
    ],
  );
}

Widget bwTile(IconData icon, String text) {
  return colorTile(icon, Colors.black, text, blackAndWhite: true);
}

Widget colorTile(IconData icon, Color color, String text,
    {bool blackAndWhite = false}) {
  Color pickedColor = Color(0xfff3f4fe);
  return ListTile(
    leading: Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: blackAndWhite ? pickedColor : color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: color),
    ),
    title: Text(text, style: TextStyle(fontWeight: FontWeight.w600)),
    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
  );
}
