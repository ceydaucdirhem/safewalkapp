import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'camerascreen.dart';

class VoiceInputScreen extends StatefulWidget {
  @override
  _VoiceInputScreenState createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    _initVoice();
  }

  void _initVoice() async {

    await _speechToText.initialize();

    await _flutterTts.setLanguage("tr-TR");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void _onMicButtonPressed() async {

    await _flutterTts.speak("Sizi dinliyorum");

    Future.delayed(const Duration(milliseconds: 1200), () {
      _startListening();
    });
  }

  void _startListening() async {

    setState(() {
      _isListening = true;
      _wordsSpoken = "";
    });

    await _speechToText.listen(
      localeId: "tr_TR",
      listenMode: ListenMode.dictation,

      onResult: (result) {

        setState(() {

          _wordsSpoken = result.recognizedWords;

          if (result.finalResult) {

            _isListening = false;

            _processCommand(
              _wordsSpoken.toLowerCase(),
            );
          }
        });
      },
    );
  }

  void _stopListening() async {

    await _speechToText.stop();

    setState(() {
      _isListening = false;
    });
  }

  // SESLİ ASİSTAN KOMUTLARI
  void _processCommand(String command) async {

    String response = "";

    // KÜTÜPHANE
    if (command.contains("kütüphane")) {

      response =
      "Kütüphane ikinci kattadır. "
          "5. kat Asansörü kullanın ve ikinci kat düğmesine basın. "
          "Asansörden çıktıktan sonra sağa dönün. "
          "Koridorun sonunda kütüphane bulunmaktadır.";
    }

    // KANTİN
    else if (command.contains("kantin")) {

      response =
      "Kantin ikinci kattadır. "
          "Gitmek için 5. kat asansörü kullanın. "
          "İki kat düğmesine tıklayın. "
          "Asansörden çıktıktan sonra düz ilerleyin. "
          "Kantin sol tarafta kalacaktır.";
    }

    // Mobil Uygulamalar Sınıfı
    else if (command.contains("Mobil") ||
        command.contains("mobil uygulamalar")) {

      response =
      "Mobil uygulamalar dersi için dört L bir sınıfına gidiyorsunuz. "
          "Öncelikle ikinci kattan öğretmenler odasının kapısından sola dönün. "
          "Ek bina asansörüne binin. "
          "Dört kat düğmesine tıklayın. "
          "Asansörden indikten sonra düz ilerleyin. "
          "Sınıf hemen solunuzda kalacaktır.";
    }

    // TUVALET
    else if (command.contains("tuvalet")) {

      response =
      "En yakın tuvalet bulunduğunuz koridorun sonunda sağ taraftadır.";
    }

    // MÜDÜR ODASI
    else if (command.contains("müdür")) {

      response =
      "Müdür odası giriş kattadır. "
          "Merdivenlerden indikten sonra sağ koridora dönünüz.";
    }

    // ANLAŞILMAYAN KOMUT
    else {

      response = "Komutu anlayamadım";
    }

    // SESLİ YANIT
    await _flutterTts.speak(response);

    // KONUŞMA BİTSİN
    await Future.delayed(
      const Duration(seconds: 3),
    );

    // KAMERA AÇ


      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CameraScreen1(
              destination: '',
              userText: command, // 👈 Değişen kısım: 'response' yerine 'command' gönderiyoruz!
            ),
          ),
        );
      }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Color(0xFF0B0014),
              Color(0xFF2A0A3D),
              Color(0xFF4A0D6B),
              Color(0xFF1A0033),

            ],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              GestureDetector(

                onTap: _isListening
                    ? _stopListening
                    : _onMicButtonPressed,

                child: AnimatedContainer(

                  duration: const Duration(
                    milliseconds: 300,
                  ),

                  height: 110,
                  width: 110,

                  decoration: BoxDecoration(

                    shape: BoxShape.circle,

                    gradient: _isListening

                        ? const LinearGradient(

                      colors: [

                        Color(0xFFFF4FD8),
                        Color(0xFFB300FF),
                        Color(0xFF6A00FF),

                      ],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )

                        : const LinearGradient(

                      colors: [

                        Color(0xFF6A00FF),
                        Color(0xFF4B0082),

                      ],
                    ),

                    boxShadow: [

                      BoxShadow(

                        color: _isListening
                            ? Colors.pinkAccent.withOpacity(0.6)
                            : Colors.deepPurple.withOpacity(0.6),

                        blurRadius: 25,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: Icon(

                    _isListening
                        ? Icons.graphic_eq
                        : Icons.mic,

                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(

                _isListening
                    ? "Dinleniyor..."
                    : "Konuşmak için dokun",

                style: const TextStyle(

                  color: Colors.white,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 20),

              Padding(

                padding: const EdgeInsets.all(20),

                child: Text(

                  _wordsSpoken,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}