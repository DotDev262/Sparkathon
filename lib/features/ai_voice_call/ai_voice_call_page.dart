// lib/features/ai_voice_call/ai_voice_call_page.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // For json encoding/decoding

enum CallStatus { idle, connecting, inCall, listening, speaking, ended, error }

class AIVoiceCallPage extends StatefulWidget {
  const AIVoiceCallPage({super.key});

  @override
  State<AIVoiceCallPage> createState() => _AIVoiceCallPageState();
}

class _AIVoiceCallPageState extends State<AIVoiceCallPage> {
  CallStatus _callStatus = CallStatus.idle;
  String _transcript = ''; // Stores user's last input
  String _aiResponse = ''; // Stores AI's last response
  final TextEditingController _messageController = TextEditingController();

  // --- N8N Webhook URL ---
  // IMPORTANT: Replace this with your actual N8N webhook URL
  static const String _n8nWebhookUrl =
      'http://11.12.19.173:5678/webhook-test/632370fd-f7f2-4592-be2f-20aacbb117cc';
  // Example: 'https://your.n8n.cloud/webhook/your-ai-voice-api'
  // Or for local: 'http://192.168.1.XX:5678/webhook/your-ai-voice-api'
  // (Use your local IP if running N8N locally and testing on device)

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // --- N8N Interaction Logic ---

  Future<void> _sendToN8n({required String eventType, String? message}) async {
    if (_n8nWebhookUrl == 'YOUR_N8N_WEBHOOK_URL_HERE') {
      logger.e(
        'N8N Webhook URL not set! Please replace "YOUR_N8N_WEBHOOK_URL_HERE" with your actual N8N webhook URL.',
      );
      setState(() {
        _callStatus = CallStatus.error;
        _aiResponse = 'Configuration Error: N8N Webhook URL not set.';
      });
      return;
    }

    try {
      logger.d('Sending event to N8N: $eventType with message: $message');
      setState(() {
        if (eventType == 'start_call') {
          _callStatus = CallStatus.connecting;
          _aiResponse = '';
          _transcript = '';
        } else if (eventType == 'user_message') {
          _callStatus =
              CallStatus.listening; // Simulate listening while sending
          _transcript = 'You: "$message"';
        }
      });

      final response = await http.post(
        Uri.parse(_n8nWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'eventType': eventType,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
          // Add any other context needed by N8N, e.g., 'userId': '123'
        }),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          logger.d('N8N response received: ${response.body}');
          final Map<String, dynamic> responseData = json.decode(response.body);

          setState(() {
            _aiResponse = responseData['aiResponse'] ?? 'No response from AI.';
            _callStatus = CallStatus.inCall; // Back to in-call after response
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'AI Response: ${_aiResponse.substring(0, _aiResponse.length > 50 ? 50 : _aiResponse.length)}...',
              ),
            ),
          );
        } else {
          logger.e(
            'N8N request failed with status: ${response.statusCode}, body: ${response.body}',
          );
          setState(() {
            _callStatus = CallStatus.error;
            _aiResponse = 'Error communicating with AI: ${response.statusCode}';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.statusCode} - ${response.body}'),
            ),
          );
        }
      }
    } catch (e) {
      logger.e('Error sending to N8N: $e');
      if (mounted) {
        setState(() {
          _callStatus = CallStatus.error;
          _aiResponse = 'Network Error: Cannot reach N8N service.';
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Network Error: $e')));
      }
    }
  }

  void _startCall() {
    _sendToN8n(eventType: 'start_call');
  }

  void _endCall() {
    _sendToN8n(eventType: 'end_call'); // Notify N8N call ended
    setState(() {
      _callStatus = CallStatus.ended;
      _aiResponse = 'Call ended. Thank you for using our AI assistant!';
    });
    // Optionally navigate back after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _handleUserMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty && _callStatus == CallStatus.inCall) {
      _sendToN8n(eventType: 'user_message', message: message);
      _messageController.clear();
    } else if (_callStatus != CallStatus.inCall) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please start the call first.')),
      );
    }
  }

  // This is for the microphone button, will also send the message from text field
  void _onMicButtonPressed() {
    _handleUserMessage(); // Re-use the text field logic for simplicity
    // In a real app, this would trigger speech-to-text and then send the result
    // For hackathon, it just sends whatever is in the text field or an empty string.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            if (_callStatus == CallStatus.inCall ||
                _callStatus == CallStatus.connecting) {
              _endCall(); // Ensure call ends if user goes back
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'AI Voice Assistant',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryBlue, AppColors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primaryBlue.withValues(
                        alpha: 0.2,
                      ),
                      child: Icon(
                        _getCallIcon(),
                        size: 70,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _getCallStatusText(),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    if (_callStatus == CallStatus.connecting ||
                        _callStatus == CallStatus.listening ||
                        _callStatus == CallStatus.speaking)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryBlue,
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Display AI Response
                    if (_aiResponse.isNotEmpty)
                      Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI:',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlue,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _aiResponse,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Display User Transcript
                    if (_transcript.isNotEmpty &&
                        _transcript != 'You: ""') // Don't show empty user input
                      Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: AppColors.yellow.withValues(alpha: .1),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You:',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkBlue,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _transcript
                                    .replaceAll('You: "', '')
                                    .replaceAll(
                                      '"',
                                      '',
                                    ), // Clean up for display
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Input and Action Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your question...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.grey300.withValues(alpha: .5),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: (value) => _handleUserMessage(),
                          enabled:
                              _callStatus ==
                              CallStatus.inCall, // Only enabled when in call
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        onPressed: _callStatus == CallStatus.inCall
                            ? _handleUserMessage
                            : null, // Only enabled when in call
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        mini: true,
                        heroTag:
                            'sendMessageBtn', // Unique tag for multiple FABs
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _callStatus == CallStatus.idle ||
                              _callStatus == CallStatus.ended ||
                              _callStatus == CallStatus.error
                          ? ElevatedButton.icon(
                              onPressed: _startCall,
                              icon: const Icon(Icons.call),
                              label: const Text('Start Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: _endCall,
                              icon: const Icon(Icons.call_end),
                              label: const Text('End Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                      if (_callStatus == CallStatus.inCall ||
                          _callStatus == CallStatus.listening)
                        FloatingActionButton(
                          onPressed: _callStatus == CallStatus.listening
                              ? null
                              : _onMicButtonPressed,
                          backgroundColor: _callStatus == CallStatus.listening
                              ? AppColors.grey
                              : AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
                          heroTag: 'micButton', // Unique tag for multiple FABs
                          child: Icon(
                            _callStatus == CallStatus.listening
                                ? Icons.mic_off
                                : Icons.mic,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods for UI state (unchanged) ---

  String _getCallStatusText() {
    switch (_callStatus) {
      case CallStatus.idle:
        return 'Ready to connect.';
      case CallStatus.connecting:
        return 'Connecting to AI Assistant...';
      case CallStatus.inCall:
        return 'Connected to AI Assistant.';
      case CallStatus.listening:
        return 'Sending message...'; // Updated text for N8N
      case CallStatus.speaking:
        return 'Receiving AI response...'; // Updated text for N8N
      case CallStatus.ended:
        return 'Call ended.';
      case CallStatus.error:
        return 'Connection Error.';
    }
  }

  IconData _getCallIcon() {
    switch (_callStatus) {
      case CallStatus.idle:
      case CallStatus.ended:
        return Icons.phone;
      case CallStatus.connecting:
        return Icons.ring_volume;
      case CallStatus.inCall:
        return Icons.headset_mic;
      case CallStatus.listening:
        return Icons.mic; // Still mic for listening, but text changes
      case CallStatus.speaking:
        return Icons.record_voice_over; // Still same, but text changes
      case CallStatus.error:
        return Icons.error_outline;
    }
  }
}
