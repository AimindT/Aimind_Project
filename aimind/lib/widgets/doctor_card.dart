import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
      final String doctorImagePath;
    final String rating;
    final String doctorName;
    final String doctorProfession;
  const DoctorCard({super.key, required this.doctorImagePath, required this.rating, required this.doctorName, required this.doctorProfession});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right:  25.0),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 3,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      doctorImagePath,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Nombre del doctor
                Text(
                  doctorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                // Especialidad del doctor
                Text(
                  doctorProfession,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                // Contenedor de las estrellas
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        rating,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}