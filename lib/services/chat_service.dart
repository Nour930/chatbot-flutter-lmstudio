import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // Utilisez l'adresse IP de votre machine Windows si vous utilisez un appareil physique ou un émulateur non configuré pour 10.0.2.2
  static const String baseUrl = 'http://192.168.1.17:1234/v1'; // <-- Mettez votre adresse IP ici
  
  Future<String> sendMessage(String message  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'  ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'mistral-7b-instruct-v0.2',
          'messages': [
            // Supprimez le message avec le rôle 'system'
            {
              'role': 'user',
              'content': message,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Erreur du serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
