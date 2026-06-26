import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'arrival_screen.dart';

class CameraScreen1 extends StatefulWidget {
  final String destination;
  final String userText;

  const CameraScreen1({
    super.key,
    required this.destination,
    required this.userText,
  });

  @override
  State<CameraScreen1> createState() => _CameraScreen1State();
}

class _CameraScreen1State extends State<CameraScreen1> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  final FlutterTts _flutterTts = FlutterTts();

  String guideText = "Kamera hazırlanıyor...";
  String ttsText = "";

  bool _isRouteFound = true;

  // Konuşma bitti mi?
  bool _speechFinished = false;

  // Gidilecek yer adı
  String _cleanDestinationName = "";

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // KAMERA BAŞLAT
  void _initCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        return;
      }

      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
      );

      await _controller!.initialize();

      if (!mounted) return;

      setState(() {});

      // TTS AYARLARI
      await _flutterTts.setLanguage("tr-TR");
      await _flutterTts.setSpeechRate(0.5);

      // Konuşmanın tamamen bitmesini bekle
      await _flutterTts.awaitSpeakCompletion(true);

      // Konuşma bitince çalışır
      _flutterTts.setCompletionHandler(() {
        _speechFinished = true;
      });

      Future.delayed(
        const Duration(milliseconds: 200),
        _startNavigation,
      );
    } catch (e) {
      print("Kamera hatası: $e");
    }
  }

  // SESLİ YÖNLENDİRME
  void _startNavigation() async {
    String input =
    "${widget.destination} ${widget.userText}".toLowerCase();

    // Türkçe karakter temizleme
    input = input
        .replaceAll("ı", "i")
        .replaceAll("ğ", "g")
        .replaceAll("ü", "u")
        .replaceAll("ş", "s")
        .replaceAll("ö", "o")
        .replaceAll("ç", "c");

    _isRouteFound = true;
    _speechFinished = false;

    // ===== KÜTÜPHANE =====
    if (input.contains("kutuphane")) {
      guideText = "📍 Kütüphane";

      _cleanDestinationName = "Kütüphaneye";

      ttsText =
      "Kamera aktif. Kütüphane için düz ilerleyin. "
          "Asansöre ulaştığınızda iki kat düğmesine basın.";
    }

    // ===== KANTİN =====
    else if (input.contains("kantin")) {
      guideText = "📍 Kantin";

      _cleanDestinationName = "Kantine";

      ttsText =
      "Kamera aktif. Kantin için düz ilerleyin. "
          "İkinci kata çıkmak için asansörü kullanın.";
    }

    // ===== 4L1 =====
    else if (input.contains("4l1") ||
        input.contains("mobil") ||
        input.contains("uygulama")) {
      guideText = "📍 4L1 Sınıfı";

      _cleanDestinationName = "4L1 Sınıfına";

      ttsText =
      "Öğretmenler odasından sola dönün. "
          "Ek bina asansörüne binin ve dört kata çıkın.";
    }

    // ===== TUVALET =====
    else if (input.contains("tuvalet")) {
      guideText = "📍 Tuvalet";

      _cleanDestinationName = "Tuvalete";

      ttsText =
      "Koridor boyunca ilerleyin. "
          "Tuvalet sağ tarafta.";
    }

    // ===== REKTÖR =====
    else if (input.contains("mudur") ||
        input.contains("rektor")) {
      guideText = "📍 Rektör Odası";

      _cleanDestinationName = "Rektör Odasına";

      ttsText =
      "Merdivenlerden aşağı inin. "
          "Sağ koridora dönün.";
    }

    // ===== BULUNAMADI =====
    else {
      guideText = "❌ Yönlendirme bulunamadı";

      _isRouteFound = false;

      ttsText =
      "Bu konum için yönlendirme bulunamadı.";
    }

    if (mounted) {
      setState(() {});
    }

    // SESLENDİR
    await _flutterTts.speak(ttsText);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null ||
        !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // EKRANA DOKUNULUNCA
      onTap: () async {

        // Eğer konuşma bittiyse ve rota varsa
        // Arrival ekranına geç
        if (_speechFinished &&
            _isRouteFound &&
            _cleanDestinationName.isNotEmpty) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ArrivalScreen(
                destinationName: _cleanDestinationName,
              ),
            ),
          );
        }

        // Konuşma devam ediyorsa tekrar oku
        else {
          await _flutterTts.speak(ttsText);
        }
      },

      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [

            // KAMERA
            CameraPreview(_controller!),

            // ORTADAKİ OK
            Center(
              child: _isRouteFound
                  ? const Icon(
                Icons.arrow_upward_rounded,
                color: Color(0xFFB300FF),
                size: 130,
                shadows: [
                  Shadow(
                    color: Colors.purpleAccent,
                    blurRadius: 25,
                  ),
                  Shadow(
                    color: Colors.pinkAccent,
                    blurRadius: 40,
                  ),
                ],
              )
                  : const Icon(
                Icons.gpp_bad_outlined,
                color: Colors.redAccent,
                size: 90,
                shadows: [
                  Shadow(
                    color: Colors.red,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),

            // ALT PANEL
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2A003D),
                      Color(0xFF5A00A8),
                      Color(0xFFB300FF),
                    ],
                  ),
                  border: Border.all(
                    color: _isRouteFound
                        ? Colors.pinkAccent
                        : Colors.redAccent,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // BAŞLIK
                    Text(
                      guideText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // KULLANICI KOMUTU
                    Text(
                      "Siz: ${widget.userText}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BİLGİ MESAJI
                    Text(
                      _speechFinished
                          ? "Devam etmek için ekrana dokunun"
                          : "Sesli yönlendirme oynatılıyor...",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}