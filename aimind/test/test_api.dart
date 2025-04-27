import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final String backendUrl = 'https://aimind-project.onrender.com/chat';
  final String userInput = "Hola";

  try {
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": userInput}),  // Usar "text" en lugar de "mensaje"
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Respuesta del servidor: ${data['respuesta']}");
    } else if (response.statusCode == 307) {
      var redirectUrl = response.headers['location'];
      print('Redirección detectada a: $redirectUrl');
      // Hacer POST en la URL redirigida
      final redirectResponse = await http.post(
        Uri.parse(redirectUrl!),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": userInput}),
      );
      print('Respuesta del POST a la redirección: ${redirectResponse.body}');
    } else {
      print("Error HTTP: ${response.statusCode}");
      print("Body: ${response.body}");
    }
  } catch (e) {
    print("Error de conexión: $e");
  }
}
