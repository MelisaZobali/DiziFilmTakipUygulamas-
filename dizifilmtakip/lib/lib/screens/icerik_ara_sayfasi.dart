import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IcerikAraSayfasi extends StatefulWidget {
  final String kullaniciEmail;
  const IcerikAraSayfasi({Key? key, required this.kullaniciEmail})
    : super(key: key);

  @override
  _IcerikAraSayfasiState createState() => _IcerikAraSayfasiState();
}

class _IcerikAraSayfasiState extends State<IcerikAraSayfasi> {
  final TextEditingController _aramaController = TextEditingController();
  final TextEditingController _bolumController = TextEditingController();
  List<dynamic> _icerikListesi = [];
  bool _loading = false;

  @override
  void dispose() {
    _aramaController.dispose();
    _bolumController.dispose();
    super.dispose();
  }

  Future<void> _icerikAra() async {
    final query = _aramaController.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);

    final url = Uri.parse('http://10.0.2.2:5000/icerik-listesi?q=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _icerikListesi = data;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('İçerik bulunamadı.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _icerikEkle(Map<String, dynamic> item) async {
    final baslik = item['Title'];
    final tur = item['Type'];
    int? bolum;

    if (tur == 'series') {
      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Kaçıncı Bölümdesin?'),
              content: TextField(
                controller: _bolumController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Bölüm Numarası'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Tamam'),
                ),
              ],
            ),
      );
      bolum = int.tryParse(_bolumController.text.trim());
    }

    final url = Uri.parse('http://10.0.2.2:5000/icerik-ekle');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.kullaniciEmail,
          'baslik': baslik,
          'tur': tur,
          'bolum': bolum,
        }),
      );
      final res = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['durum'] ?? res['hata'] ?? '')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ekleme hatası: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arka plan görseli
          Image.asset('assets/home_bg.png', fit: BoxFit.cover),
          // Üstüne yarı saydam karartma
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Arama çubuğu
                  TextField(
                    controller: _aramaController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Dizi/Film ara',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search, color: Colors.white70),
                        onPressed: _icerikAra,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // İçerik listesi veya yükleniyor göstergesi
                  _loading
                      ? CircularProgressIndicator(color: Colors.cyanAccent)
                      : Expanded(
                        child: ListView.builder(
                          itemCount: _icerikListesi.length,
                          itemBuilder: (context, i) {
                            final item = _icerikListesi[i];
                            return Card(
                              color: Colors.white.withOpacity(0.1),
                              child: ListTile(
                                title: Text(
                                  item['Title'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  item['Type'],
                                  style: TextStyle(color: Colors.white70),
                                ),
                                trailing: Icon(
                                  Icons.add,
                                  color: Colors.cyanAccent,
                                ),
                                onTap: () => _icerikEkle(item),
                              ),
                            );
                          },
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
