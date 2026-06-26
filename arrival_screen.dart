import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ArrivalScreen extends StatefulWidget {
  final String destinationName;

  const ArrivalScreen({
    super.key,
    required this.destinationName,
  });

  @override
  State<ArrivalScreen> createState() => _ArrivalScreenState();
}

class _ArrivalScreenState extends State<ArrivalScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  // Sesli okunacak metin
  String arrivalText = "";

  @override
  void initState() {
    super.initState();

    // Gidilen yere göre mesaj hazırla
    _prepareArrivalMessage();

    // Sayfa tamamen açıldıktan sonra otomatik konuş
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      // Küçük gecikme (TTS bug fix)
      await Future.delayed(
        const Duration(milliseconds: 400),
      );

      await _flutterTts.setLanguage("tr-TR");

      await _flutterTts.setSpeechRate(0.5);

      await _flutterTts.setPitch(1.0);

      // Otomatik konuş
      await _flutterTts.speak(arrivalText);
    });
  }

  // Gidilen yere göre mesaj oluştur
  void _prepareArrivalMessage() {

    String destination =
    widget.destinationName.toLowerCase();

    destination = destination
        .replaceAll("ı", "i")
        .replaceAll("ğ", "g")
        .replaceAll("ü", "u")
        .replaceAll("ş", "s")
        .replaceAll("ö", "o")
        .replaceAll("ç", "c");

    // ===== KÜTÜPHANE =====
    if (destination.contains("kutuphane")) {

      arrivalText =
      "Kütüphaneye başarıyla vardınız.";
    }

    // ===== KANTİN =====
    else if (destination.contains("kantin")) {

      arrivalText =
      "Kantine başarıyla vardınız.";
    }

    // ===== 4L1 =====
    else if (destination.contains("4l1")) {

      arrivalText =
      "4 L 1 sınıfına başarıyla vardınız.";
    }

    // ===== TUVALET =====
    else if (destination.contains("tuvalet")) {

      arrivalText =
      "Tuvalete başarıyla vardınız.";
    }

    // ===== REKTÖR =====
    else if (destination.contains("rektor")) {

      arrivalText =
      "Rektör odasına başarıyla vardınız.";
    }

    // ===== DİĞER =====
    else {

      arrivalText =
      "${widget.destinationName} başarıyla vardınız.";
    }
  }

  // Tekrar seslendirme
  void _speakArrival() async {

    // Önce eski sesi durdur
    await _flutterTts.stop();

    await _flutterTts.setLanguage("tr-TR");

    await _flutterTts.setSpeechRate(0.5);

    await _flutterTts.setPitch(1.0);

    // Yeniden konuş
    await _flutterTts.speak(arrivalText);
  }

  @override
  void dispose() {

    // Sayfadan çıkınca sesi kapat
    _flutterTts.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      behavior: HitTestBehavior.opaque,

      // Ekranın herhangi bir yerine dokununca
      // sesi tekrar oynat
      onTap: () {
        _speakArrival();
      },

      child: Scaffold(

        backgroundColor: const Color(0xFF1A002C),

        body: Center(

          child: Padding(

            padding: const EdgeInsets.all(24.0),

            child: Column(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                // BAŞARI İKONU
                Container(

                  padding:
                  const EdgeInsets.all(20),

                  decoration:
                  const BoxDecoration(

                    shape: BoxShape.circle,

                    color: Color(0xFF2A003D),

                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFB300FF),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.check_circle_outline_rounded,

                    color: Color(0xFFB300FF),

                    size: 100,
                  ),
                ),

                const SizedBox(height: 40),

                // GİDİLEN YER
                Text(
                  widget.destinationName,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // ALT BAŞLIK
                const Text(
                  "Başarıyla Vardınız",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 15),

                // BİLGİ METNİ
                const Text(
                  "(Sesi tekrar duymak için ekrana dokunun)",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 50),

                // GERİ DÖN BUTONU
                ElevatedButton.icon(

                  onPressed: () {

                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.arrow_back_rounded,

                    color: Colors.white,
                  ),

                  label: const Text(
                    "Ana Sayfaya Dön",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                    const Color(0xFF5A00A8),

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}