import 'package:just_audio/just_audio.dart';

class SoundPlayer {
  static Future<void> playCorrect() async {
    final player = AudioPlayer();
    try {
      await player.setAsset('assets/sounds/correct.mp3');
      await player.play();
    } catch (e) {
      print('Ошибка при воспроизведении звука правильного ответа: $e');
    } finally {
      await player.dispose();
    }
  }

  static Future<void> playWrong() async {
    final player = AudioPlayer();
    try {
      await player.setAsset('assets/sounds/error.mp3');
      await player.play();
    } catch (e) {
      print('Ошибка при воспроизведении звука неправильного ответа: $e');
    } finally {
      await player.dispose();
    }
  }
}
