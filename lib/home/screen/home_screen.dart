import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speechtotextapk/history/screen/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeechToText speechToText = SpeechToText();
  String kata = "Tekan Tombol untuk Memulai";
  bool tekan = false;
  List<String> history = []; // List to store history

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        flexibleSpace: Image(
          image: AssetImage('assets/rs_pkum.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
              ),
              child: Text(
                'Menu Navigasi',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.black,
              ),
              title: Text(
                'Lihat Histori',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context); // Tutup drawer saat item diklik
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(history: history),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 150),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              'Halaman Utama',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              kata,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: AvatarGlow(
        animate: tekan,
        duration: Duration(seconds: 2),
        glowColor: Color.fromARGB(97, 14, 77, 55),
        repeat: true,
        startDelay: Duration(milliseconds: 15),
        child: GestureDetector(
          onTapDown: (details) async {
            if (!tekan) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  tekan = true;
                });
                speechToText.listen(onResult: (result) {
                  setState(() {
                    kata = result.recognizedWords;
                  });
                });
              } else {
                print(
                    "Programnya rusak, bukan programmernya. orang udah di masukin masa gaada Speechnya");
              }
            }
          },
          onTapUp: (details) {
            speechToText.stop();
            setState(() {
              tekan = false;
              history.add(kata); // Add current text to history
              kata = "Tekan untuk memulai kembali"; // Reset text
            });
          },
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green,
            child: Icon(
              tekan ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
