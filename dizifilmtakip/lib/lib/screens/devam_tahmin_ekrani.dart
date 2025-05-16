import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DevamTahminEkrani extends StatefulWidget {
  @override
  _DevamTahminEkraniState createState() => _DevamTahminEkraniState();
}

class _DevamTahminEkraniState extends State<DevamTahminEkrani> {
  final TextEditingController _diziAdiController = TextEditingController();
  String? _tahminSonucu;
  bool _yukleniyor = false;

  @override
  void dispose() {
    _diziAdiController.dispose();
    super.dispose();
  }

  Future<void> _tahminYap() async {
    final diziAdi = _diziAdiController.text.trim();
    if (diziAdi.isEmpty) return;

    setState(() {
      _yukleniyor = true;
      _tahminSonucu = null;
    });

    final url = Uri.parse('http://10.0.2.2:5000/devam-noktasi-tahmin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "diziAdi": diziAdi,
        "cevaplar": [
          "Karakterler arasındaki son olayları tam hatırlamıyorum.",
          "Ana karakterin ne yaptığına emin değilim.",
          "Hangi ilişkiler bozuldu ya da ilerledi, net değil.",
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _tahminSonucu = data['tahmin'];
    } else {
      _tahminSonucu = "Tahmin alınamadı. Hata kodu: ${response.statusCode}";
    }

    setState(() => _yukleniyor = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Neon soru işaretleri arka planı
          Image.asset('assets/devam_bg.png', fit: BoxFit.cover),
          // Üstüne hafif karartma
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Devam Noktası Tahmini',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Dizi Adı Input
                  TextField(
                    controller: _diziAdiController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Dizi Adı',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tahmin Göster Butonu
                  ElevatedButton(
                    onPressed: _yukleniyor ? null : _tahminYap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      _yukleniyor ? 'Tahmin Hesaplanıyor…' : 'Tahmini Göster',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sonuç veya Yükleniyor
                  if (_yukleniyor)
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyanAccent,
                      ),
                    )
                  else if (_tahminSonucu != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _tahminSonucu!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
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
