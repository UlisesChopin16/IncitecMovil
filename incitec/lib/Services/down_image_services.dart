import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<void> downloadImage(String imageUrl, SendPort sendPort) async {
  try {
    final uri = Uri.parse(imageUrl);
    
    final response = await http.get(uri);
      sendPort.send(response.bodyBytes);
  } catch (error) {
    print('Error al descargar la imagen: $error');
    throw Exception('Error: $error');
  }
}

Future<void> _downloadImageIsolate(_IsolateData data) async {
  await downloadImage(data.imageUrl, data.sendPort);
}

class ImageLoader {
  static Future<Uint8List> load(String imageUrl) async {
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(
        _downloadImageIsolate,
        _IsolateData(receivePort.sendPort, imageUrl),
      );

      final completer = Completer<Uint8List>();
      receivePort.listen(
        (data) {
          completer.complete(data);
        },
        onError: (error) {
          completer.completeError(error);
        },
        onDone: () {
          // Si el aislado se cierra antes de completar, manejar aquí.
          receivePort.close();
        },
      );

      return completer.future;
    } catch (error) {
      throw Exception('Error al iniciar el aislado: $error');
    }
  }
}


class _IsolateData {
  final SendPort sendPort;
  final String imageUrl;

  _IsolateData(this.sendPort, this.imageUrl);
}
