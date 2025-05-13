import 'package:flutter/material.dart';

class AnaSayfa extends StatelessWidget {
  final String kullaniciEmail;

  const AnaSayfa({Key? key, required this.kullaniciEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hoş geldin, $kullaniciEmail',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/icerik');
                },
                child: Text("📺 İçerik Ara ve Ekle"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/devam');
                },
                child: Text("🔍 Devam Noktası Tahmini"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/oneri');
                },
                child: Text("💬 Öneri Chatbotu"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Ana sayfaya dönüş
                },
                child: Text("🔁 Ana Sayfaya Dön"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilSayfasi(kullaniciEmail: kullaniciEmail),
      ),
    );
  },
  child: Text("👤 Profil"),
),

            ],
          ),
        ),
      ),
    );
  }
}
