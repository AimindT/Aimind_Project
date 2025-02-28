import 'package:aimind/widgets/custom_card.dart';
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
            )
            // 3 buttons

            //column -> stats + transactions
          ],
        ),
      ),
    );
  }
}
