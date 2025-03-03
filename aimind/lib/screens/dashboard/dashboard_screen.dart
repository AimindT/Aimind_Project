import 'package:aimind/widgets/custom_card.dart';
import 'package:aimind/widgets/custom_dash_button.dart';
import 'package:aimind/widgets/doctor_card.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Texto "Hola, Chris Chaparro"
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
                  // CircleAvatar
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/streak.jpg'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // PageView para las tarjetas
            SizedBox(
              height: 160,
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                children: [
                  CustomCard(
                    title: 'Tarjeta 1',
                    text: 'Este es un texto de ejemplo para la tarjeta 1.',
                    imagePath: 'assets/images/Psic1.jpg',
                    color: Colors.black, // Fondo negro
                  ),
                  CustomCard(
                    title: 'Tarjeta 2',
                    text: 'Este es un texto de ejemplo para la tarjeta 2.',
                    imagePath: 'assets/images/Psic2.png',
                    color: Colors.black, // Fondo negro
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Indicador de página
            SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: ExpandingDotsEffect(activeDotColor: Colors.grey.shade800),
            ),
            const SizedBox(height: 20),
            // Botones personalizados
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
            const SizedBox(height: 20),
            // Título "Psicólogos Recomendados"
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
            // Lista horizontal de psicólogos
            Expanded(
              child: SizedBox(
                height: 200,
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
            ),
          ],
        ),
      ),
    );
  }
}