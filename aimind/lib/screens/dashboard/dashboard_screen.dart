import 'package:aimind/widgets/custom_card.dart';
import 'package:aimind/widgets/custom_dash_button.dart';
import 'package:aimind/widgets/doctor_card.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola,',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          'Chris Chaparro',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 32, // Aumenta el radio del CircleAvatar externo
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 3.0, // Aumenta el ancho del borde
                          ),
                        ),
                        child: CircleAvatar(
                          radius:
                              30, // Reduce el radio del CircleAvatar interno
                          backgroundImage:
                              AssetImage('assets/images/streak.jpg'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                height: 200,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  children: [
                    CustomCard(
                      title: 'Tu racha',
                      text: 'Este es un texto de ejemplo para la tarjeta 1.',
                      imagePath: 'assets/images/Psic1.jpg',
                      color: Colors.black,
                    ),
                    CustomCard(
                      title: 'Novedades',
                      text: 'Este es un texto de ejemplo para la tarjeta 2.',
                      imagePath: 'assets/images/Psic2.png',
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              SmoothPageIndicator(
                controller: _controller,
                count: 2,
                effect:
                    ExpandingDotsEffect(activeDotColor: Colors.grey.shade800),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomDashButton(
                      iconImagePath: 'assets/images/background.png',
                      buttontext: 'Habla Con Aimind',
                      onPressed: () {},
                    ),
                    CustomDashButton(
                      iconImagePath: 'assets/images/RapTer.jpeg',
                      buttontext: 'Terapia Rapida',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Psicólogos Recomendados',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 255,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    DoctorCard(
                      doctorImagePath: 'assets/images/Psic1.jpg',
                      doctorName: 'Dra. Hidaelia Sánchez',
                      doctorProfession: 'Psicología clínica',
                      rating: '4.9',
                    ),
                    DoctorCard(
                      doctorImagePath: 'assets/images/Psic2.png',
                      doctorName: 'Dr. Fernando Guzmán',
                      doctorProfession: 'Psicología clínica',
                      rating: '4.5',
                    ),
                    DoctorCard(
                      doctorImagePath: 'assets/images/Psic3.png',
                      doctorName: 'Lic. Rubí Montoya',
                      doctorProfession: 'Psicología clínica',
                      rating: '4.4',
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            // Position the CurvedNavigationBar at the bottom
            left: 0,
            right: 0,
            bottom: 0,
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: Colors.black,
              color: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              items: const <Widget>[
                Icon(Icons.home, size: 26, color: Colors.white),
                Icon(Icons.notifications, size: 26, color: Colors.white),
                Icon(Icons.person, size: 26, color: Colors.white)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
