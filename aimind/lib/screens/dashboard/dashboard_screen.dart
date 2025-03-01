import 'package:aimind/widgets/custom_card.dart';
import 'package:aimind/widgets/custom_dash_button.dart';
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
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            //App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                              style:
                                  TextStyle(fontSize: 28, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
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
            // cards
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
                  CustomCard(
                      balance: 420.42,
                      cardNumber: 12345678,
                      expiricyMonth: 8,
                      expiryYear: 22,
                      color: Colors.green[300]!)
                ],
              ),
            ),
            SizedBox(height: 25),
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(activeDotColor: Colors.grey.shade800),
            ),
            SizedBox(height: 25)
            // 3 buttons
            ,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomDashButton(
                      iconImagePath: 'assets/images/background.png',
                      buttontext: 'Send'),
                  CustomDashButton(
                      iconImagePath: 'assets/images/background.png',
                      buttontext: 'Pay'),
                  CustomDashButton(
                      iconImagePath: 'assets/images/background.png',
                      buttontext: 'Bills'),
                ],
              ),
            ),
            SizedBox(height: 25),
            //column -> stats + transactions
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 80,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.grey[100]!,
                                borderRadius: BorderRadius.circular(12)),
                            child: Image.asset('assets/images/background.png'),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Statistics',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Payments and Icome',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]!),
                              )
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
