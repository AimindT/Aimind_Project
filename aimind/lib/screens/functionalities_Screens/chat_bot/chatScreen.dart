import 'package:aimind/services/supabase_Service%20.dart';
import 'package:aimind/widgets/likert_scale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aimind/theme/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  String? avatarUrl; // To store the user's avatar URL
  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data to get avatarUrl
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }

  Future<void> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final userData = await _supabaseService.getProfile(user.id);
      if (mounted) {
        setState(() {
          avatarUrl = userData?['avatar_url'];
        });
      }
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      text: "Hola soy AIMIND, ¿cómo puedo ayudarte el día de hoy?",
      isUser: false,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    setState(() {
      messages.add(welcomeMessage);
    });
    welcomeMessage.animationController.forward();
  }

  Future<void> _showRatingDialog() async {
    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: LikertScaleDialog(
            onComplete: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Gracias por tu calificación!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        );
      },
    );

    if (result != true) {
      return;
    }
  }

  void sendMessage() async {
    String userInput = controller.text.trim();
    if (userInput.isEmpty) return;

    final userMessage = ChatMessage(
      text: userInput,
      isUser: true,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 600),
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
      print("Sending request to: $backendUrl");
      print("Request body: ${jsonEncode({"text": userInput})}");

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": userInput}),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 307) {
        final responseBody = jsonDecode(response.body);
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

        reply = _fixEncoding(reply);

        final botMessage = ChatMessage(
          text: reply,
          isUser: false,
          animationController: AnimationController(
            duration: const Duration(milliseconds: 600),
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

  String _fixEncoding(String text) {
    final Map<String, String> replacements = {
      'Ã¡': 'á',
      'Ã©': 'é',
      'Ã­': 'í',
      'Ã³': 'ó',
      'Ãº': 'ú',
      'Ãñ': 'ñ',
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

    try {
      final bytes = latin1.encode(result);
      result = utf8.decode(bytes);
    } catch (e) {
      print("Encoding fix error: $e");
    }

    return result;
  }

  void _addErrorMessage() {
    final errorMessage = ChatMessage(
      text: "Error al conectar con la IA.",
      isUser: false,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 600),
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

  Widget _buildImagePlaceholder() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: Icon(Icons.person, size: 20, color: Colors.grey[400]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        if (mounted) {
          Navigator.pop(context);
          await _showRatingDialog();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: isDarkMode ? Colors.indigo[800] : Colors.indigo[400],
          elevation: 2,
          title: Row(
            mainAxisSize:
                MainAxisSize.min, // Minimize the Row's width to center content
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage:
                    const AssetImage('assets/images/background.png'),
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 8),
              const Text(
                "AIMIND",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () async {
              if (mounted) {
                Navigator.pop(context);
                await _showRatingDialog();
              }
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [Colors.grey[900]!, Colors.grey[850]!]
                  : [Colors.grey[100]!, Colors.white],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i < messages.length) {
                      return FadeTransition(
                        opacity: messages[i].animationController,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: messages[i].isUser
                                ? const Offset(1, 0)
                                : const Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: messages[i].animationController,
                            curve: Curves.easeOutCubic,
                          )),
                          child: buildMessage(messages[i], isDarkMode),
                        ),
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
        ),
      ),
    );
  }

  Widget buildMessage(ChatMessage msg, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            CircleAvatar(
              radius: 18,
              backgroundImage: const AssetImage('assets/images/background.png'),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              decoration: BoxDecoration(
                color: msg.isUser
                    ? (isDarkMode ? Colors.indigo[500] : Colors.indigo[400])
                    : (isDarkMode ? Colors.grey[800] : Colors.white),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black26
                        : Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: msg.isUser
                      ? Colors.white
                      : (isDarkMode ? Colors.white : Colors.black87),
                ),
              ),
            ),
          ),
          if (msg.isUser) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl!,
                        fit: BoxFit.cover,
                        width: 36,
                        height: 36,
                        placeholder: (context, url) => _buildImagePlaceholder(),
                        errorWidget: (context, url, error) =>
                            _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildLoadingBubble(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: const AssetImage('assets/images/background.png'),
            backgroundColor:
                isDarkMode ? Colors.indigo[700] : Colors.indigo[300],
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black26
                      : Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDarkMode ? Colors.indigo[300]! : Colors.indigo[500]!,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Escribiendo...",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(bool isDarkMode) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
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
                  fontSize: 16,
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
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.indigo[600]!, Colors.indigo[400]!]
                        : [Colors.indigo[400]!, Colors.indigo[300]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  size: 24,
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
