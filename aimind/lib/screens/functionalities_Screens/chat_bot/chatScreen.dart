import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aimind/theme/theme_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final String backendUrl = 'https://aimind-project.onrender.com/chat';

  bool isLoading = false;

  void sendMessage() async {
    String userInput = controller.text;
    if (userInput.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(
        text: userInput,
        isUser: true,
        animationController: AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        ),
      ));
      controller.clear();
      messages.last.animationController.forward();
      isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"text": userInput}), // Usamos "text" en vez de "mensaje"
      );

      if (response.statusCode == 200) {
        String reply = jsonDecode(response.body)['respuesta'];
        setState(() {
          final botMessage = ChatMessage(
            text: reply,
            isUser: false,
            animationController: AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            ),
          );
          messages.add(botMessage);
          botMessage.animationController.forward();
          isLoading = false;
        });
        _scrollToBottom();
      } else if (response.statusCode == 307) {
        var redirectUrl = response.headers['location'];
        final redirectResponse = await http.post(
          Uri.parse(redirectUrl!),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"text": userInput}),
        );
        setState(() {
          final botMessage = ChatMessage(
            text: jsonDecode(redirectResponse.body)['respuesta'],
            isUser: false,
            animationController: AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            ),
          );
          messages.add(botMessage);
          botMessage.animationController.forward();
          isLoading = false;
        });
        _scrollToBottom();
      } else {
        setState(() {
          final errorMessage = ChatMessage(
            text: "Lo siento, hubo un error al conectar con la IA.",
            isUser: false,
            animationController: AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            ),
          );
          messages.add(errorMessage);
          errorMessage.animationController.forward();
          isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      print("Error de conexión: $e"); // <-- AGREGA ESTO
      setState(() {
        final errorMessage = ChatMessage(
          text: "Error de conexión.",
          isUser: false,
          animationController: AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
          ),
        );
        messages.add(errorMessage);
        errorMessage.animationController.forward();
        isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget buildLoadingBubble(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Escribiendo...",
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
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
        backgroundColor: themeProvider.themeData.colorScheme.surface,
        elevation: 0,
        title: Text(
          "Psicólogo Virtual",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
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
              reverse: false,
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (_, i) {
                if (i < messages.length) {
                  return SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: messages[i].animationController,
                      curve: Curves.easeOut,
                    ),
                    child: buildMessage(messages[i], isDarkMode),
                  );
                } else {
                  return buildLoadingBubble(isDarkMode);
                }
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: themeProvider.themeData.colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: "Escribe tu mensaje...",
                      hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: isDarkMode ? Colors.indigo[300] : Colors.indigo),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(ChatMessage msg, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isUser
              ? (isDarkMode ? Colors.indigo[400] : Colors.indigo)
              : (isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final AnimationController animationController;

  ChatMessage({required this.text, required this.isUser, required this.animationController});
}
