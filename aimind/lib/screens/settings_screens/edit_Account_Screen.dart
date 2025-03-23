import 'package:aimind/theme/theme_provider.dart';
import 'package:aimind/widgets/custom_text_field.dart';
import 'package:aimind/widgets/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final String url =
      'https://static.wikia.nocookie.net/mokeys-show/images/4/43/Screenshot_2025-01-10_212625.png/revision/latest?cb=20250112022914';

  String gender = 'man';
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Ionicons.chevron_back_outline)),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    fixedSize: Size(60, 50),
                    elevation: 3),
                icon: Icon(
                  Ionicons.checkmark,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Text(
                    'Tu Cuenta',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 40),
              EditItem(
                title: '',
                widget: Padding(
                  padding: EdgeInsets.only(right: 80),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor:
                            isDarkMode ? Colors.white : Colors.black,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Color.fromARGB(255, 230, 228, 228),
                          backgroundImage: NetworkImage(url),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.lightBlueAccent,
                        ),
                        child: Text('Subir Foto'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              EditItem(
                  widget: CustomTextField(
                    keyboardType: TextInputType.text,
                    maxLegth: 100,
                  ),
                  title: 'Nombre'),
              SizedBox(height: 40),
              EditItem(
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              gender = 'man';
                            });
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: gender == 'man'
                                  ? Colors.deepPurple
                                  : Colors.grey.shade200,
                              fixedSize: Size(50, 50)),
                          icon: Icon(
                            Ionicons.male,
                            color:
                                gender == 'man' ? Colors.white : Colors.black,
                            size: 18,
                          )),
                      SizedBox(width: 20),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              gender = 'woman';
                            });
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: gender == 'woman'
                                  ? Colors.deepPurple
                                  : Colors.grey.shade200,
                              fixedSize: Size(50, 50)),
                          icon: Icon(
                            Ionicons.female,
                            color:
                                gender == 'woman' ? Colors.white : Colors.black,
                            size: 18,
                          )),
                    ],
                  ),
                  title: 'Genero'),
              SizedBox(height: 40),
              EditItem(widget: TextField(), title: 'Edad'),
              SizedBox(height: 40),
              EditItem(
                  widget: CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    maxLegth: 100,
                  ),
                  title: 'Email')
            ],
          ),
        ),
      ),
    );
  }
}
