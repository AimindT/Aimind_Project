import 'package:aimind/widgets/forward_button.dart';
import 'package:aimind/widgets/setting_Item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SettingsScreen2 extends StatefulWidget {
  const SettingsScreen2({super.key});

  @override
  State<SettingsScreen2> createState() => _SettingsScreen2State();
}

class _SettingsScreen2State extends State<SettingsScreen2> {
  final String url =
      'https://static.wikia.nocookie.net/mokeys-show/images/4/43/Screenshot_2025-01-10_212625.png/revision/latest?cb=20250112022914';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 100,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Text(
            'Account',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 3.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 230, 228, 228),
                      radius: 30,
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uranus Code',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Youtube Channel',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    )
                  ],
                ),
                Spacer(),
                ForwardButton(
                  onTap: () {},
                )
              ],
            ),
          ),
          SizedBox(height: 40),
          Text(
            'Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          SettingItem(
            title: 'Language',
            icon: Ionicons.earth,
            bgColor: Colors.red.shade100,
            iconColor: Colors.red,
            value: 'English',
            onTap: () {},
          ),
          SizedBox(height: 20),
          SettingItem(
            title: 'Language',
            icon: Ionicons.earth,
            bgColor: Colors.red.shade100,
            iconColor: Colors.red,
            value: 'English',
            onTap: () {},
          ),
          SizedBox(height: 20),
          SettingItem(
            title: 'Language',
            icon: Ionicons.earth,
            bgColor: Colors.red.shade100,
            iconColor: Colors.red,
            value: 'English',
            onTap: () {},
          ),
          SizedBox(height: 20),
          SettingItem(
            title: 'Language',
            icon: Ionicons.earth,
            bgColor: Colors.red.shade100,
            iconColor: Colors.red,
            value: 'English',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
