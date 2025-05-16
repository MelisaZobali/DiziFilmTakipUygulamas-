import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OneriChatbotEkrani extends StatefulWidget {
  @override
  _OneriChatbotEkraniState createState() => _OneriChatbotEkraniState();
}

class _OneriChatbotEkraniState extends State<OneriChatbotEkrani> {
  final TextEditingController mesajController = TextEditingController();
  String? yanit;
  bool yukleniyor = false;

  Future<void> oneriAl() async {
    setState(() {
      yukleniyor = true;
      yanit = null;
    });

    final url = Uri.parse('http://10.0.2.2:5000/oneri-chatbotu');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"mesaj": mesajController.text.trim()}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        yanit = data['oneri'];
      });
    } else {
      setState(() {
        yanit = "Bir hata oluştu: ${response.statusCode}";
      });
    }
    setState(() => yukleniyor = false);
  }

  @override
  void dispose() {
    mesajController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan + overlay
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/chatbot_bg.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Öneri Chatbotu',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mesaj girişi
                  TextField(
                    controller: mesajController,
                    maxLines: 4,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ne izlemek istersin? Nasıl hissediyorsun?",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Öneri Al butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: yukleniyor ? null : oneriAl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        yukleniyor ? 'Yükleniyor…' : 'Öneri Al',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Yanıt gösterimi
                  if (yukleniyor)
                    CircularProgressIndicator(color: Colors.cyanAccent)
                  else if (yanit != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        yanit!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
