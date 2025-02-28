import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double balance;
  final int cardNumber;
  final int expiricyMonth;
  final int expiryYear;
  final Color color;

  const CustomCard(
      {super.key,
      required this.balance,
      required this.cardNumber,
      required this.expiricyMonth,
      required this.expiryYear,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Balance',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              '\$$balance',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$cardNumber',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '$expiricyMonth/$expiryYear',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
