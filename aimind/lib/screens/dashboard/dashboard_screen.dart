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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'My ',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Cards',
                          style: TextStyle(fontSize: 28, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.grey[400], shape: BoxShape.circle),
                      child: Icon(Icons.add)),
                ],
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              height: 200,
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                children: [
                  CustomCard(
                      balance: 5250.20,
                      cardNumber: 12345678,
                      expiricyMonth: 10,
                      expiryYear: 24,
                      color: Colors.deepPurple[300]!),
                  CustomCard(
                      balance: 342.23,
                      cardNumber: 12345678,
                      expiricyMonth: 11,
                      expiryYear: 23,
                      color: Colors.blue[300]!),
                ],
              ),
            ),
            SizedBox(height: 25),
            SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: ExpandingDotsEffect(activeDotColor: Colors.grey.shade800),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomDashButton(
                    iconImagePath: 'assets/images/background.png',
                    buttontext: 'Send',
                    onPressed: () {},
                  ),
                  CustomDashButton(
                    iconImagePath: 'assets/images/background.png',
                    buttontext: 'Pay',
                    onPressed: () {},
                  ),
                  CustomDashButton(
                    iconImagePath: 'assets/images/background.png',
                    buttontext: 'Bills',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Psicólogos Recomendados',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'Ver todos',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                child: Expanded(
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
