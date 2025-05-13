import 'package:flutter/material.dart';

class ProfilSayfasi extends StatelessWidget {
  final String kullaniciEmail;

  const ProfilSayfasi({Key? key, required this.kullaniciEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "👤 Kullanıcı Bilgileri",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(height: 32),
            Text("📧 E-posta: $kullaniciEmail", style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text("🎬 İzlenen dizi/film sayısı: ...", style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // geri dön
              },
              child: Text("← Ana Sayfaya Dön"),
            ),
          ],
        ),
      ),
    );
  }
}
