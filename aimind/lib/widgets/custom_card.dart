import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double balance;
  final int cardNumber;
  final int expiricyMonth;
  final int expiryYear;
  final Color color;

  const CustomCard({
    super.key,
    required this.balance,
    required this.cardNumber,
    required this.expiricyMonth,
    required this.expiryYear,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.5),
              Colors.white.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Balance',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$$balance',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '**** **** **** ${cardNumber.toString().substring(cardNumber.toString().length - 4)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$expiricyMonth/$expiryYear',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}