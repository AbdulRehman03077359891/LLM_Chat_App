import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LlamaApi {
  late final String serverUrl;
  late final int maxTokens;
  late final double temperature;

  LlamaApi(String s) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    serverUrl = prefs.getString('serverUrl') ?? 'http://127.0.0.1:8080';
    maxTokens = prefs.getInt('maxTokens') ?? 500;
    temperature = prefs.getDouble('temperature') ?? 0.7;
  }

  Future<void> generateStreamedResponse(
      List<Map<String, String>> messages, void Function(String) onData) async {
    if (serverUrl.isEmpty) {
      throw Exception('Server URL is not configured.');
    }

    final endpoint = Uri.parse('$serverUrl/v1/chat/completions');
    final body = jsonEncode({
      'messages': messages, // Send the entire history
      'max_tokens': maxTokens,
      'temperature': temperature,
      'stream': true, // Enable streaming mode
    });

    final headers = {'Content-Type': 'application/json'};

    final request = http.Request('POST', endpoint)
      ..headers.addAll(headers)
      ..body = body;

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      // Decode the streamed response line by line
      final stream = streamedResponse.stream.transform(utf8.decoder);

      await for (final line in stream) {
        final trimmedLine = line.trim();
        if (trimmedLine.isNotEmpty && trimmedLine.startsWith('data: ')) {
          final jsonLine = trimmedLine.substring(6); // Remove 'data: '

          if (jsonLine == '[DONE]') {
            // Handle end of stream
            break;
          }

          try {
            // Parse the JSON and extract content
            final parsedData = jsonDecode(jsonLine);
            if (parsedData['choices'] != null &&
                parsedData['choices'].isNotEmpty &&
                parsedData['choices'][0]['delta'] != null &&
                parsedData['choices'][0]['delta']['content'] != null) {
              final content = parsedData['choices'][0]['delta']['content'];
              onData(content); // Pass the streamed content to the callback
            }
          } catch (e) {
            // Handle parsing errors
            debugPrint('Error parsing streamed data: $e');
          }
        }
      }
    } else {
      throw Exception(
          'Failed to get a response: ${streamedResponse.statusCode}');
    }
  }

  Future<String> generateResponse(List<Map<String, String>> messages) async {
    if (serverUrl.isEmpty) {
      throw Exception('Server URL is not configured.');
    }

    final endpoint = Uri.parse('$serverUrl/v1/chat/completions');
    final body = jsonEncode({
      'messages': messages, // Send the entire history
      'max_tokens': maxTokens,
      'temperature': temperature,
    });

    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(endpoint, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('Failed to get a response: ${response.statusCode}');
    }
  }
}
