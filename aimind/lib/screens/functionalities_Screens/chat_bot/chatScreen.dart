import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aimind/theme/theme_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final String backendUrl = 'https://aimind-project.onrender.com/chat/';
  bool isLoading = false;

  void sendMessage() async {
    String userInput = controller.text.trim();
    if (userInput.isEmpty) return;

    final userMessage = ChatMessage(
      text: userInput,
      isUser: true,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    setState(() {
      messages.add(userMessage);
      controller.clear();
      isLoading = true;
    });
    userMessage.animationController.forward();
    _scrollToBottom();

    try {
      // Print the request being sent for debugging
      print("Sending request to: $backendUrl");
      print("Request body: ${jsonEncode({"text": userInput})}");

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": userInput}),
      );

      // Print response details for debugging
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 307) {
        // Parse the response body
        final responseBody = jsonDecode(response.body);

        // Check which field exists in the response
        String reply = "";
        if (responseBody.containsKey('respuesta')) {
          reply = responseBody['respuesta'];
        } else if (responseBody.containsKey('text')) {
          reply = responseBody['text'];
        } else if (responseBody.containsKey('response')) {
          reply = responseBody['response'];
        } else {
          reply = "No se pudo interpretar la respuesta.";
        }

        // Fix encoding issues with Latin-1 characters
        reply = _fixEncoding(reply);

        final botMessage = ChatMessage(
          text: reply,
          isUser: false,
          animationController: AnimationController(
            duration: const Duration(milliseconds: 400),
            vsync: this,
          ),
        );
        setState(() {
          messages.add(botMessage);
          isLoading = false;
        });
        botMessage.animationController.forward();
      } else {
        print("Error status: ${response.statusCode}");
        print("Error body: ${response.body}");
        _addErrorMessage();
      }
    } catch (e) {
      print("Exception during API call: $e");
      _addErrorMessage();
    }
    _scrollToBottom();
  }

  // Function to fix encoding issues
  String _fixEncoding(String text) {
    // Replace common encoding issues with proper Spanish characters
    final Map<String, String> replacements = {
      'Ã¡': 'á',
      'Ã©': 'é',
      'Ã­': 'í',
      'Ã³': 'ó',
      'Ãº': 'ú',
      'Ã±': 'ñ',
      'Ã': 'í',
      'Â¿': '¿',
      'Â¡': '¡',
      'Ã\u0081': 'Á',
      'Ã\u0089': 'É',
      'Ã\u008D': 'Í',
      'Ã\u0093': 'Ó',
      'Ã\u009A': 'Ú',
      'Ã\u0091': 'Ñ',
    };

    String result = text;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });

    // Alternative approach - try to decode as Latin-1 and re-encode as UTF-8
    try {
      final bytes = latin1.encode(result);
      result = utf8.decode(bytes);
    } catch (e) {
      // If that fails, keep the original after replacements
      print("Encoding fix error: $e");
    }

    return result;
  }

  void _addErrorMessage() {
    final errorMessage = ChatMessage(
      text: "Error al conectar con la IA.",
      isUser: false,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );
    setState(() {
      messages.add(errorMessage);
      isLoading = false;
    });
    errorMessage.animationController.forward();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    for (var message in messages) {
      message.animationController.dispose();
    }
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: themeProvider.themeData.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: themeProvider.themeData.colorScheme.surface,
        elevation: 0,
        title: Text(
          "AIMIND",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (_, i) {
                if (i < messages.length) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: messages[i].animationController,
                      curve: Curves.easeOutBack,
                    )),
                    child: buildMessage(messages[i], isDarkMode),
                  );
                } else {
                  return buildLoadingBubble(isDarkMode);
                }
              },
            ),
          ),
          buildInputField(isDarkMode),
        ],
      ),
    );
  }

  Widget buildMessage(ChatMessage msg, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isUser
              ? (isDarkMode ? Colors.indigo[400] : Colors.indigo[300])
              : (isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            fontSize: 18,
            height: 1.4,
            color: msg.isUser
                ? Colors.white
                : (isDarkMode ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget buildLoadingBubble(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Escribiendo...",
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(bool isDarkMode) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => sendMessage(),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  hintText: "Escribe tu mensaje...",
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.black45,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: sendMessage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.indigo[400] : Colors.indigo,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  size: 26,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final AnimationController animationController;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.animationController,
  });
}
